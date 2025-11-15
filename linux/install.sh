#!/bin/bash

# Linux専用設定のインストールスクリプト
# Linux固有の設定をインストール

set -e

LINUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

echo ""
echo "=== Linux専用設定をインストール ==="
echo ""

# 現時点ではLinux専用の設定はありません
# 将来的にLinux固有の設定（例：i3wm、Wayland設定など）をここに追加できます

echo "Linux専用の設定は現時点では未定義です"

echo ""
echo "✓ Linux専用設定のインストールが完了しました"
