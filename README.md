# Clean Branches Plugin for Oh My Zsh

A powerful, unified, and interactive branch cleanup tool for Zsh.

This plugin provides a single command, `gprune`, to find all local Git branches that are safe to delete, including:
- **[stale]**: Branches whose remote counterpart has been deleted.
- **[merged]**: Branches that have already been fully merged into your main branch (`main` or `master`).
- **[WIP - unmerged]**: Local-only branches that were never pushed and are not merged. **(Use with caution!)**

It uses `fzf` to provide a beautiful interactive UI, allowing you to easily select and delete multiple branches at once.

## Prerequisites

- [Oh My Zsh](https://ohmyz.sh/)
- [fzf](https://github.com/junegunn/fzf) (e.g., `brew install fzf`)

## Installation

1.  Clone this repository into your Oh My Zsh custom plugins directory:
    ```sh
    git clone https://github.com/wu9o/ohmyzsh-cleanbranches.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cleanbranches
    ```

2.  Add the plugin to the list of plugins in your `~/.zshrc` file:
    ```zsh
    plugins=(
        # other plugins...
        cleanbranches
    )
    ```

3.  Restart your terminal or source your `~/.zshrc` file:
    ```sh
    source ~/.zshrc
    ```

## Usage

Navigate to any Git repository and run the command:

```sh
gprune
```

An interactive `fzf` window will open, listing all deletable branches with their status.

- Use `TAB` to select one or more branches.
- Press `Enter` to confirm your selection.
- A final confirmation prompt will appear before deletion.

![Screenshot of gprune in action](https://link-to-your-screenshot.com/image.png)  <!-- You can add a screenshot later -->

## How it Works

The `gprune` command performs the following steps:
1.  Fetches the latest remote state using `git fetch --prune`.
2.  Identifies your main branch (`main` or `master`).
3.  Finds branches in three categories:
    - **stale**: Compares local branches with remote ones that are "gone".
    - **merged**: Uses `git branch --merged` to find branches whose work is already in the main branch. This includes local-only branches that were created and then merged.
    - **WIP - unmerged**: Finds local-only branches that are not merged. Deleting these may result in permanent data loss.
4.  Presents a unique, tagged list of these branches for you to choose from.
