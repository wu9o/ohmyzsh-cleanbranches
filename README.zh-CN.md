# Oh My Zsh 的 Clean Branches 插件

一个强大的、统一的、交互式的 Git 分支清理工具。

本插件提供了一个单一命令 `gprune`，用于查找所有可以被安全删除的本地 Git 分支，包括：
- **[stale]**: 远程已经不存在的本地分支。
- **[merged]**: 已经完全合并到主分支 (`main` 或 `master`) 的分支。
- **[WIP - unmerged]**: 仅在本地存在、从未推送且未合并的分支。**(请谨慎处理!)**

它使用 `fzf` 提供了一个美观的交互式界面，让你能轻松地一次性选择并删除多个分支。

## 先决条件

- [Oh My Zsh](https://ohmyz.sh/)
- [fzf](https://github.com/junegunn/fzf) (例如: `brew install fzf`)

## 安装

1.  克隆本仓库到你的 Oh My Zsh 自定义插件目录：
    ```sh
    git clone https://github.com/wu9o/ohmyzsh-cleanbranches.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cleanbranches
    ```

2.  将插件添加到你的 `~/.zshrc` 文件中的插件列表里：
    ```zsh
    plugins=(
        # 其他插件...
        cleanbranches
    )
    ```

3.  重启你的终端，或重新加载 `~/.zshrc` 文件：
    ```sh
    source ~/.zshrc
    ```

## 使用方法

进入任意一个 Git 仓库，然后运行命令：

```sh
gprune
```

一个 `fzf` 交互式窗口将会打开，列出所有可被删除的分支及其状态。

- 使用 `TAB` 键选择一个或多个分支。
- 按 `Enter` 键确认你的选择。
- 在执行删除前，会有一个最终的确认提示。

![gprune 运行截图](https://link-to-your-screenshot.com/image.png) <!-- 你可以稍后添加截图 -->

## 工作原理

`gprune` 命令会执行以下步骤：
1.  使用 `git fetch --prune` 获取最新的远程状态。
2.  自动识别你的主分支 (`main` 或 `master`)。
3.  查找三类分支：
    - **stale**: 对比本地分支和已“消失”的远程分支。
    - **merged**: 使用 `git branch --merged` 查找其工作已完全包含在主分支中的分支。这也包括那些仅在本地创建然后被合并的分支。
    - **WIP - unmerged**: 查找仅在本地存在且未合并的分支。删除这类分支可能会导致工作永久丢失。
4.  将一个去重后、带有清晰标记的分支列表呈现给你，供你选择。