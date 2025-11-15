#!/bin/bash

# macOS専用設定のインストールスクリプト
# macOS固有の設定（Karabiner、VSCodeなど）をインストール

set -e

MACOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$MACOS_DIR/.." && pwd)"

# 共通関数ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"

echo ""
echo "=== macOS専用設定をインストール ==="
echo ""

# .config ディレクトリ作成
mkdir -p "$HOME/.config"

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
  echo "! VSCodeがインストールされていないため、VSCode設定をスキップします"
fi

echo ""
echo "✓ macOS専用設定のインストールが完了しました"
