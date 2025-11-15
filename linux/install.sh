#!/bin/bash

# Linux専用設定のインストールスクリプト
# Linux固有の設定をインストール

set -e

LINUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$LINUX_DIR/.." && pwd)"

# 共通ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"
source "$DOTFILES_DIR/lib/utils.sh"

print_section "Linux専用設定をインストール"

# .config ディレクトリ作成
ensure_config_dir

# VSCode設定
VSCODE_USER_DIR="$HOME/.config/Code/User"
if [ -d "$VSCODE_USER_DIR" ]; then
  echo ""
  echo "VSCode設定をセットアップします..."
  if [ -f "$LINUX_DIR/vscode/settings.json" ]; then
    create_symlink "$LINUX_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
  fi
  if [ -f "$LINUX_DIR/vscode/keybindings.json" ]; then
    create_symlink "$LINUX_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
  fi
else
  print_warning "VSCodeがインストールされていないため、VSCode設定をスキップします"
fi

print_success "Linux専用設定のインストールが完了しました"
