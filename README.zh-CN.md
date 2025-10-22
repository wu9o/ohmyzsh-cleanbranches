# Oh My Zsh - Clean Branches 插件

[English](./README.md) | [中文](./README.zh-CN.md)

一个简单而强大的 Oh My Zsh 插件，用于清理已在远程仓库中删除的本地分支。它利用 `fzf` 提供了一个交互式界面，让你可以一次性选择并删除多个分支。

## 功能

当团队协作时，远程仓库中已经合并或删除的分支，在本地通常还会保留。随着时间推移，本地会积累大量无用的分支，导致分支列表混乱。

此插件可以帮你快速找到这些“过时”的本地分支，并以交互方式安全地删除它们。

## 安装

1.  **克隆此仓库** 到你的 Oh My Zsh 自定义插件目录：

    ```bash
    git clone https://github.com/wu9o/ohmyzsh-cleanbranches.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cleanbranches
    ```

2.  **添加插件** 到你的 `~/.zshrc` 文件中的 `plugins` 数组里：

    ```zsh
    plugins=(... cleanbranches)
    ```

3.  **重启终端** 或重新加载 `~/.zshrc` 文件使配置生效：

    ```bash
    source ~/.zshrc
    ```

## 使用方法

1.  在你的终端中，进入任意一个 Git 仓库目录，然后运行 `gprune` 命令：

    ```bash
    gprune
    ```

2.  插件会自动抓取远程最新状态，并列出所有在远程已被删除的本地分支。

3.  使用 `TAB` 键来多选你想要删除的分支。

4.  按 `Enter` 键确认选择。

5.  在执行删除前，会有一个最终的确认提示。

## 依赖

本插件依赖 `fzf`。请确保你的系统已安装 `fzf`。

你可以通过包管理器来安装，例如：

```bash
# 在 macOS 上使用 Homebrew
brew install fzf

# 在 Debian/Ubuntu 上使用 APT
sudo apt-get install fzf
```

## 许可证

本项目基于 MIT 许可证。
