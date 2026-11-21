#!/usr/bin/env bash
# 一键安装 cht-work-skill 的全部快捷按钮（slash commands）到 CodeBuddy 用户命令目录。
# 用法：bash scripts/install-commands.sh [目标目录]
# 默认目标：~/.codebuddy/commands

set -e
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/commands"
DEST_DIR="${1:-$HOME/.codebuddy/commands}"

if [ ! -d "$SRC_DIR" ]; then
  echo "找不到按钮源目录：$SRC_DIR" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
echo "从 $SRC_DIR 安装按钮到 $DEST_DIR"

count=0
for f in "$SRC_DIR"/*.md; do
  [ -e "$f" ] || continue
  base="$(basename "$f")"
  # 示例模板（项目速记-示例.md）不安装为命令，仅作参考
  case "$base" in
    项目速记-示例.md)
      echo "  跳过（模板）: $base"
      continue
      ;;
  esac
  cp "$f" "$DEST_DIR/$base"
  echo "  已安装: /${base%.md}"
  count=$((count + 1))
done

echo "完成：$count 个按钮已安装。"
echo "下一步：在会话里执行一次 /reload-plugins 让命令生效。"
