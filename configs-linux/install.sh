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

# stow が必須
if ! command -v stow >/dev/null 2>&1; then
  print_error "GNU stow が見つかりません。パッケージマネージャで stow をインストールしてください。"
fi

# stow で Linux 専用設定をリンク
stow -d "$DOTFILES_DIR" -t "$HOME" configs-linux

print_success "Linux専用設定のインストールが完了しました"
