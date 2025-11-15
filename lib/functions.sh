#!/bin/bash

# dotfiles 共通関数ライブラリ
# 各install.shから読み込んで使用する共通関数を定義

# シンボリックリンクを作成する関数
# 使用例: create_symlink "/path/to/source" "/path/to/target"
create_symlink() {
  local source="$1"
  local target="$2"

  if [ -L "$target" ]; then
    echo "✓ $target はすでにシンボリックリンクです（スキップ）"
  elif [ -f "$target" ] || [ -d "$target" ]; then
    echo "! $target が存在します。バックアップを作成します..."
    mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    ln -s "$source" "$target"
    echo "✓ $target を作成しました"
  else
    ln -s "$source" "$target"
    echo "✓ $target を作成しました"
  fi
}
