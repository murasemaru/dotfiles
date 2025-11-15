#!/bin/bash

# Linux専用設定のインストールスクリプト
# Linux固有の設定をインストール

set -e

LINUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$LINUX_DIR/.." && pwd)"

# 共通関数ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"

echo ""
echo "=== Linux専用設定をインストール ==="
echo ""

# 現時点ではLinux専用の設定はありません
# 将来的にLinux固有の設定（例：i3wm、Wayland設定など）をここに追加できます

echo "Linux専用の設定は現時点では未定義です"

echo ""
echo "✓ Linux専用設定のインストールが完了しました"
