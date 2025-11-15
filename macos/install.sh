#!/bin/bash

# macOS専用設定のインストールスクリプト
# macOS固有の設定（Karabiner、VSCodeなど）をインストール

set -e

MACOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# シンボリックリンクを作成する関数
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
