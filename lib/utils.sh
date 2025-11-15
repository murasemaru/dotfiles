#!/bin/bash

# ユーティリティ関数ライブラリ
# 各install.shで使用する便利な関数を定義

# .configディレクトリを作成
# 使用例: ensure_config_dir
ensure_config_dir() {
  mkdir -p "$HOME/.config"
}

# セクション見出しを表示
# 使用例: print_section "共通設定をインストール"
print_section() {
  local title="$1"
  echo ""
  echo "=== $title ==="
  echo ""
}

# 成功メッセージを表示
# 使用例: print_success "インストールが完了しました"
print_success() {
  local message="$1"
  echo ""
  echo "✓ $message"
}

# 警告メッセージを表示
# 使用例: print_warning "ファイルが見つかりません"
print_warning() {
  local message="$1"
  echo "! $message"
}

# エラーメッセージを表示して終了
# 使用例: print_error "必須ファイルが見つかりません"
print_error() {
  local message="$1"
  echo "エラー: $message" >&2
  exit 1
}
