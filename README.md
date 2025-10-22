# Oh My Zsh - Clean Branches Plugin

[English](./README.md) | [中文](./README.zh-CN.md)

A simple but powerful Oh My Zsh plugin that helps you clean up local branches that have been removed from the remote repository. It provides an interactive way to select and delete multiple branches at once, using the power of `fzf`.

## Why use this?

If you work in a team with a lot of branches, your local repository can get cluttered with old branches that have already been merged and deleted on the remote. This plugin makes it easy to find and remove these stale branches, keeping your local workspace tidy.

## Installation

1.  **Clone this repository** into your Oh My Zsh custom plugins directory:

    ```bash
    git clone https://github.com/wu9o/ohmyzsh-cleanbranches.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cleanbranches
    ```

2.  **Add the plugin** to the `plugins` array in your `~/.zshrc` file:

    ```zsh
    plugins=(... cleanbranches)
    ```

3.  **Restart your terminal** or source your `~/.zshrc` file to apply the changes:

    ```bash
    source ~/.zshrc
    ```

## Usage

1.  Run the `gprune` command in your terminal:

    ```bash
    gprune
    ```

2.  You will be presented with a list of local branches that are no longer on the remote.

3.  Use the `TAB` key to select the branches you want to delete.

4.  Press `Enter` to confirm your selection.

5.  You will be asked for a final confirmation before the branches are deleted.

## Dependencies

This plugin requires `fzf` to be installed on your system. You can install it with your favorite package manager, for example:

```bash
# Using Homebrew on macOS
brew install fzf

# Using APT on Debian/Ubuntu
sudo apt-get install fzf
```

## License

This project is licensed under the MIT License.