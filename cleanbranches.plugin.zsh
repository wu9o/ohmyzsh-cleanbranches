# 清理在远程已被删除的本地分支 (fzf 交互选择版)
function gprune() {
  # 0. 检查 fzf 是否已安装
  if ! command -v fzf &> /dev/null;
  then
    echo "错误: 未找到 fzf 命令。"
    echo "请先安装 fzf (例如: brew install fzf) 后再运行此命令。"
    return 1
  fi

  # 1. 更新远程状态
  git fetch --prune
  
  # 2. 查找所有 "gone" 的本地分支
  local branches_found
  branches_found=$(git branch -vv | grep ': gone]' | awk '{print $1}')
  
  if [[ -z "$branches_found" ]]; then
    echo "没有找到在远程已被删除的本地分支。"
    return 0
  fi
  
  # 将分支列表转换为数组
  local -a branch_array
  branch_array=(${(f)branches_found})
  
  # 3. 使用 fzf 进行交互式多选
  local -a branches_to_delete
  local selected_output
  
  # 将数组内容通过管道传给 fzf
  selected_output=$(printf '%s\n' "${branch_array[@]}" | fzf --multi --prompt="请按 TAB 键选择要删除的分支, 按 Enter 键确认 > ")
  
  # 如果用户没有选择任何东西 (按下了 ESC 或 Ctrl-C)，则退出
  if [[ -z "$selected_output" ]]; then
    echo "操作已取消。"
    return 0
  fi
  
  # 将 fzf 返回的字符串（每行一个分支）读入最终的删除数组
  branches_to_delete=(${(f)selected_output})
  
  # 4. 最终确认并执行删除
  echo
  echo "以下分支将被删除："
  printf '  %s\n' "${branches_to_delete[@]}"
  echo
  
  read -k 1 -r 'REPLY?确认删除吗？(y/N) '
  echo
  
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf '%s\n' "${branches_to_delete[@]}" | xargs git branch -D
    echo "清理完成！"
  else
    echo "操作已取消。"
  fi
}

