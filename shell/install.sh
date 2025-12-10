#!/bin/bash

# シェル設定（zsh）を stow で展開する

set -e

SHELL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SHELL_DIR/.." && pwd)"

# 共通ライブラリを読み込み
source "$DOTFILES_DIR/lib/utils.sh"
source "$DOTFILES_DIR/lib/shell_check.sh"

print_section "シェル設定をインストール"

# stow が必須
if ! command -v stow >/dev/null 2>&1; then
  print_error "GNU stow が見つかりません。パッケージマネージャで stow をインストールしてください。"
fi

# zsh チェック
check_and_setup_zsh

# stow でシェル設定をリンク
stow -d "$DOTFILES_DIR" -t "$HOME" shell

print_success "シェル設定のインストールが完了しました"
