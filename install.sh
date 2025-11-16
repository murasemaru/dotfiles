#!/bin/bash

# dotfiles インストールスクリプト
# 使い方:
#   ./install.sh              # シンボリックリンクのみ
#   ./install.sh --packages   # パッケージもインストール
#
# 対応OS: macOS, Linux (Debian, RedHat系), Windows (WSL)

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================
# オプション解析
# ============================================
INSTALL_PACKAGES=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --packages|-p)
      INSTALL_PACKAGES=true
      shift
      ;;
    --help|-h)
      echo "使い方: $0 [オプション]"
      echo ""
      echo "オプション:"
      echo "  --packages, -p    パッケージもインストール"
      echo "  --help, -h        このヘルプを表示"
      echo ""
      echo "例:"
      echo "  $0              # シンボリックリンクのみ"
      echo "  $0 --packages   # パッケージもインストール"
      exit 0
      ;;
    *)
      echo "不明なオプション: $1"
      echo "$0 --help でヘルプを表示"
      exit 1
      ;;
  esac
done

# ============================================
# カラー定義
# ============================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ============================================
# ライブラリ読み込み
# ============================================
source "$DOTFILES_DIR/lib/os_detect.sh"
source "$DOTFILES_DIR/lib/software_check.sh"
if [ "$INSTALL_PACKAGES" = true ]; then
  source "$DOTFILES_DIR/lib/package_installer.sh"
fi

# ============================================
# OS検出
# ============================================
OS="$(detect_os)"

# ============================================
# メイン処理
# ============================================

echo ""
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  dotfiles セットアップ${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "検出されたOS: ${GREEN}${OS}${NC}"
echo ""

# dotfilesディレクトリの存在確認
if [ ! -d "$DOTFILES_DIR" ]; then
  echo -e "${RED}エラー: $DOTFILES_DIR が見つかりません${NC}"
  exit 1
fi

# 共通設定のインストール
if [ -f "$DOTFILES_DIR/common/install.sh" ]; then
  bash "$DOTFILES_DIR/common/install.sh"
else
  echo -e "${RED}エラー: common/install.sh が見つかりません${NC}"
  exit 1
fi

# OS固有の設定のインストール
case "$OS" in
  macos)
    if [ -f "$DOTFILES_DIR/macos/install.sh" ]; then
      bash "$DOTFILES_DIR/macos/install.sh"
    else
      echo -e "${YELLOW}警告: macos/install.sh が見つかりません${NC}"
    fi
    ;;
  debian|redhat|linux)
    if [ -f "$DOTFILES_DIR/linux/install.sh" ]; then
      bash "$DOTFILES_DIR/linux/install.sh"
    else
      echo -e "${YELLOW}警告: linux/install.sh が見つかりません${NC}"
    fi
    ;;
  wsl|windows)
    if [ -f "$DOTFILES_DIR/windows/install.sh" ]; then
      bash "$DOTFILES_DIR/windows/install.sh"
    else
      echo -e "${YELLOW}警告: windows/install.sh が見つかりません${NC}"
    fi
    ;;
  unknown)
    echo ""
    echo -e "${YELLOW}警告: OSを特定できませんでした${NC}"
    echo "共通設定のみがインストールされました"
    ;;
esac

# ============================================
# ソフトウェア依存関係チェック
# ============================================
prompt_install_missing_software

# Oh My Zsh のチェック
check_oh_my_zsh

# fzf のチェック
check_fzf

# ============================================
# パッケージインストール（オプション）
# ============================================
if [ "$INSTALL_PACKAGES" = true ]; then
  install_packages "$OS"
fi

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  セットアップが完了しました！${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

if [ "$INSTALL_PACKAGES" = false ]; then
  echo -e "${YELLOW}ヒント: パッケージをインストールする場合は --packages オプションを使用してください${NC}"
  echo -e "  ${BLUE}./install.sh --packages${NC}"
  echo ""
fi

echo "次のコマンドで設定を反映してください:"
echo -e "  ${BLUE}source ~/.zshrc${NC}"
echo ""
