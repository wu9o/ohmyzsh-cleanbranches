# A unified, interactive branch cleanup tool for Oh My Zsh.
# Finds and allows deletion of "stale", "merged", and "WIP-unmerged" branches.
function gprune() {
  # 1. Prerequisite checks
  if ! git rev-parse --is-inside-work-tree &> /dev/null;
  then
    echo "Error: Not a git repository."
    return 1
  fi

  if ! command -v fzf &> /dev/null;
  then
    echo "Error: fzf is required but not found. Please install it (e.g., brew install fzf)."
    return 1
  fi

  # 2. Fetch latest remote state
  echo "Fetching remote state..."
  git fetch --prune
  
  # 3. Determine the main branch (main or master)
  local main_branch
  main_branch=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's@^origin/@@' 2>/dev/null)
  if [[ -z "$main_branch" ]]; then
    if git show-ref --verify --quiet refs/heads/main;
    then
      main_branch="main"
    elif git show-ref --verify --quiet refs/heads/master;
    then
      main_branch="master"
    else
      echo "Error: Could not determine the main branch ('main' or 'master')."
      return 1
    fi
  fi
  
  # 4. Use a Zsh associative array to store unique branches and their types
  typeset -A branch_info
  
  # Category 1: Find stale branches
  local stale_branches
  stale_branches=$(git branch -vv | grep ': gone]' | awk '{print $1}')
  for branch in ${(f)stale_branches};
  do
    branch_info[$branch]="[stale]"
  done
  
  # Category 2: Find merged branches
  local merged_branches
  merged_branches=$(git branch --merged "$main_branch" | awk -v main_branch="$main_branch" '{ branch_name = ($1 == "*" ? $2 : $1); if (branch_name != main_branch && branch_name != "master" && branch_name != "main") print branch_name }')
  for branch in ${(f)merged_branches}; do
    if [[ -n "${branch_info[$branch]}" ]]; then
      branch_info[$branch]+=" [merged]"
    else
      branch_info[$branch]="[merged]"
    fi
  done

  # Category 3: Find WIP (unmerged, local-only) branches
  local all_local_branches
  all_local_branches=$(git for-each-ref --format='%(refname:short)' refs/heads/ | awk -v main_branch="$main_branch" '{ if ($1 != main_branch && $1 != "master" && $1 != "main") print $1 }')
  for branch in ${(f)all_local_branches}; do
    # If the branch is not already in our list, it's a WIP branch
    if [[ -z "${branch_info[$branch]}" ]]; then
      branch_info[$branch]="[WIP - unmerged]"
    fi 
  done

  # 5. Prepare the list for fzf and pipe it directly
  if [ ${#branch_info[@]} -eq 0 ]; then
    echo "No stale or merged local branches to clean up. Your repository is clean!"
    return 0
  fi
  
  # 6. Use fzf for interactive selection by piping the loop output directly
  local selected_output
  selected_output=$( \
    for branch in "${(@k)branch_info}"; do \
      printf '%-40s %s\n' "$branch" "${branch_info[$branch]}"; \
    done | fzf --multi --prompt="Select branches to delete (TAB to mark, Enter to confirm) > " \
  )
  
  if [[ -z "$selected_output" ]]; then
    echo "Operation canceled."
    return 0
  fi
  
  local branches_to_delete
  branches_to_delete=$(echo "$selected_output" | awk '{print $1}')
  
  # 7. Final confirmation and deletion
  echo
  echo "The following branches will be force-deleted (-D):"
  echo "$branches_to_delete" | sed 's/^/  /'
  echo
  echo "WARNING: Branches marked [WIP - unmerged] have no remote backup and are not merged."
  echo "Deleting them may result in permanent data loss."
  
  read -k 1 -r 'REPLY?Are you absolutely sure? (y/N) '
  echo
  
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "$branches_to_delete" | xargs -n 1 git branch -D
    echo "Done!"
  else
    echo "Operation canceled."
  fi
}