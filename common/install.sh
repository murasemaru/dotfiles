#!/bin/bash

# 共通設定のインストールスクリプト
# すべてのOS（macOS、Linux）で共通する設定をインストール
#
# 注意: この dotfiles 環境は zsh を前提としています

set -e

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$COMMON_DIR/.." && pwd)"

# 共通ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"
source "$DOTFILES_DIR/lib/utils.sh"
source "$DOTFILES_DIR/lib/shell_check.sh"

print_section "共通設定をインストール"

# ============================================
# zsh チェック
# ============================================
check_and_setup_zsh

# 基本設定ファイル
create_symlink "$COMMON_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$COMMON_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$COMMON_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$COMMON_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$COMMON_DIR/.default-gems" "$HOME/.default-gems"

# zsh モジュール設定
create_symlink "$COMMON_DIR/.zsh" "$HOME/.zsh"

# .config ディレクトリ作成
ensure_config_dir

# neovim設定
create_symlink "$COMMON_DIR/nvim" "$HOME/.config/nvim"

# tmuxinator設定
create_symlink "$COMMON_DIR/tmuxinator" "$HOME/.config/tmuxinator"

print_success "共通設定のインストールが完了しました"
