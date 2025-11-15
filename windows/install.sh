#!/bin/bash

# Windows専用設定のインストールスクリプト
# Windows固有の設定をインストール（WSL環境を想定）

set -e

WINDOWS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$WINDOWS_DIR/.." && pwd)"

# 共通ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"
source "$DOTFILES_DIR/lib/utils.sh"

print_section "Windows専用設定をインストール"

# .config ディレクトリ作成
ensure_config_dir

# WSL環境かどうかを確認
if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "WSL環境を検出しました"

  # VSCode設定（WSL内でVSCodeを使う場合）
  VSCODE_USER_DIR="$HOME/.config/Code/User"
  if [ -d "$VSCODE_USER_DIR" ]; then
    echo ""
    echo "VSCode設定をセットアップします..."
    if [ -f "$WINDOWS_DIR/vscode/settings.json" ]; then
      create_symlink "$WINDOWS_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
    fi
    if [ -f "$WINDOWS_DIR/vscode/keybindings.json" ]; then
      create_symlink "$WINDOWS_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    fi
  else
    print_warning "VSCodeがインストールされていないため、VSCode設定をスキップします"
  fi
else
  print_warning "WSL環境ではないようです"
  echo "この設定はWSL（Windows Subsystem for Linux）での使用を想定しています"
fi

print_success "Windows専用設定のインストールが完了しました"
