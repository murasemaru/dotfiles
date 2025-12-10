#!/bin/bash

# 共通設定のインストールスクリプト
# すべてのOS（macOS、Linux）で共通する設定をインストール
#
set -e

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$COMMON_DIR/.." && pwd)"

# 共通ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"
source "$DOTFILES_DIR/lib/utils.sh"

print_section "共通設定をインストール"

# stow が必須
if ! command -v stow >/dev/null 2>&1; then
  print_error "GNU stow が見つかりません。パッケージマネージャで stow をインストールしてください。"
fi

# stow で共通設定をリンク
stow -d "$DOTFILES_DIR" -t "$HOME" configs-common

print_success "共通設定のインストールが完了しました"
