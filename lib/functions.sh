#!/bin/bash

# dotfiles 共通関数ライブラリ
# 各install.shから読み込んで使用する共通関数を定義

# バックアップディレクトリ
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# シンボリックリンクを作成する関数
# 使用例: create_symlink "/path/to/source" "/path/to/target"
create_symlink() {
  local source="$1"
  local target="$2"

  if [ -L "$target" ]; then
    echo "✓ $target はすでにシンボリックリンクです（スキップ）"
  elif [ -f "$target" ] || [ -d "$target" ]; then
    echo "! $target が存在します。バックアップを作成します..."

    # バックアップディレクトリを作成
    mkdir -p "$BACKUP_DIR"

    # ファイル名を取得（パスを保持）
    local backup_path="$BACKUP_DIR${target#$HOME}"
    local backup_dir=$(dirname "$backup_path")

    # バックアップ先のディレクトリを作成
    mkdir -p "$backup_dir"

    # バックアップを作成
    mv "$target" "$backup_path"
    echo "  → バックアップ: $backup_path"

    # シンボリックリンクを作成
    ln -s "$source" "$target"
    echo "✓ $target を作成しました"
  else
    ln -s "$source" "$target"
    echo "✓ $target を作成しました"
  fi
}
