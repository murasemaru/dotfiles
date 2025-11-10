#!/bin/bash

# dotfiles インストールスクリプト
# 使い方: ./install.sh

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "==================================="
echo "dotfiles セットアップを開始します"
echo "==================================="

# dotfilesディレクトリの存在確認
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "エラー: $DOTFILES_DIR が見つかりません"
  exit 1
fi

cd "$DOTFILES_DIR"

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

# 基本設定ファイルのシンボリックリンク作成
echo ""
echo "シンボリックリンクを作成します..."
echo ""

create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.default-gems" "$HOME/.default-gems"

# neovim設定
mkdir -p "$HOME/.config"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# VSCode設定
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_USER_DIR" ]; then
  echo ""
  echo "VSCode設定をセットアップします..."
  create_symlink "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
  create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
else
  echo ""
  echo "! VSCodeがインストールされていないため、VSCode設定をスキップします"
fi

echo ""
echo "==================================="
echo "セットアップが完了しました！"
echo "==================================="
echo ""
echo "次のコマンドで設定を反映してください:"
echo "  source ~/.zshrc"
echo ""
