#!/bin/bash

# macOS専用設定のインストールスクリプト
# macOS固有の設定（Karabiner、VSCodeなど）をインストール

set -e

MACOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$MACOS_DIR/.." && pwd)"

# 共通ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"
source "$DOTFILES_DIR/lib/utils.sh"

print_section "macOS専用設定をインストール"

# .config ディレクトリ作成
ensure_config_dir

# Karabiner設定
if [ -d "$MACOS_DIR/karabiner" ]; then
  create_symlink "$MACOS_DIR/karabiner" "$HOME/.config/karabiner"
else
  echo "! Karabiner設定が見つかりません（スキップ）"
fi

# VSCode設定
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_USER_DIR" ]; then
  echo ""
  echo "VSCode設定をセットアップします..."
  if [ -f "$MACOS_DIR/vscode/settings.json" ]; then
    create_symlink "$MACOS_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
  fi
  if [ -f "$MACOS_DIR/vscode/keybindings.json" ]; then
    create_symlink "$MACOS_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
  fi
else
  print_warning "VSCodeがインストールされていないため、VSCode設定をスキップします"
fi

print_success "macOS専用設定のインストールが完了しました"
