# Clean up local branches that have been deleted on the remote.
# (Interactive version using fzf)
function gprune() {
  # 1. Check if inside a git repository
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Error: Not a git repository."
    return 1
  fi

  # 2. Check if fzf is installed
  if ! command -v fzf &> /dev/null;
  then
    echo "Error: fzf command not found."
    echo "Please install fzf (e.g., brew install fzf) to use this command."
    return 1
  fi

  # 3. Update remote status
  git fetch --prune
  
  # 4. Find all local branches that are "gone" from the remote
  local branches_found
  branches_found=$(git branch -vv | grep ': gone]' | awk '{print $1}')
  
  if [[ -z "$branches_found" ]]; then
    echo "No stale local branches found."
    return 0
  fi
  
  # Convert the branch list to an array
  local -a branch_array
  branch_array=(${(f)branches_found})
  
  # 5. Use fzf for interactive multi-selection
  local -a branches_to_delete
  local selected_output
  
  # Pipe the array content to fzf
  selected_output=$(printf '%s\n' "${branch_array[@]}" | fzf --multi --prompt="Select branches to delete with TAB, confirm with Enter > ")
  
  # Exit if the user selected nothing (pressed ESC or Ctrl-C)
  if [[ -z "$selected_output" ]]; then
    echo "Operation canceled."
    return 0
  fi
  
  # Read the fzf output (one branch per line) into the final delete array
  branches_to_delete=(${(f)selected_output})
  
  # 6. Final confirmation and deletion
  echo
  echo "The following branches will be deleted:"
  printf '  %s\n' "${branches_to_delete[@]}"
  echo
  
  read -k 1 -r 'REPLY?Are you sure? (y/N) '
  echo
  
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf '%s\n' "${branches_to_delete[@]}" | xargs git branch -D
    echo "Done!"
  else
    echo "Operation canceled."
  fi
}