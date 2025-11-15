#!/bin/bash

# Windows専用設定のインストールスクリプト
# Windows固有の設定をインストール（WSL環境を想定）

set -e

WINDOWS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$WINDOWS_DIR/.." && pwd)"

# 共通関数ライブラリを読み込み
source "$DOTFILES_DIR/lib/functions.sh"

echo ""
echo "=== Windows専用設定をインストール ==="
echo ""

# WSL環境かどうかを確認
if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "WSL環境を検出しました"

  # WSL固有の設定をここに追加
  # 例：
  # - Windows側のディレクトリへのシンボリックリンク
  # - Windows Terminalの設定
  # - .wslconfigの設定

  echo "WSL固有の設定は現時点では未定義です"
else
  echo "注意: WSL環境ではないようです"
  echo "この設定はWSL（Windows Subsystem for Linux）での使用を想定しています"
fi

echo ""
echo "✓ Windows専用設定のインストールが完了しました"
