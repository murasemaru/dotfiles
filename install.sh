#!/bin/bash

# dotfiles インストールスクリプト
# 使い方: ./install.sh
#
# 対応OS: macOS, Linux (Debian, RedHat系)

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================
# カラー定義
# ============================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ============================================
# OS検出
# ============================================
detect_os() {
  case "$(uname -s)" in
    Linux*)
      if [ -f /etc/debian_version ]; then
        echo "debian"
      elif [ -f /etc/redhat-release ]; then
        echo "redhat"
      else
        echo "linux"
      fi
      ;;
    Darwin*)
      echo "macos"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

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
  unknown)
    echo ""
    echo -e "${YELLOW}警告: OSを特定できませんでした${NC}"
    echo "共通設定のみがインストールされました"
    ;;
esac

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  セットアップが完了しました！${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo "次のコマンドで設定を反映してください:"
echo -e "  ${BLUE}source ~/.zshrc${NC}"
echo ""
