#!/bin/bash

# シェル環境チェック関数ライブラリ
# zshのインストールとデフォルトシェル設定を確認・変更

# zsh環境をチェックし、必要に応じてセットアップ
# この関数は shell/install.sh から呼び出される
check_and_setup_zsh() {
  echo "環境チェック: zsh"

  # zshがインストールされているか確認
  if ! command -v zsh &> /dev/null; then
    echo ""
    echo "警告: zsh がインストールされていません"
    echo "この dotfiles 環境は zsh を前提としています"
    echo ""
    echo "zsh をインストールしてください:"
    echo "  Debian/Ubuntu: sudo apt-get install zsh"
    echo "  RedHat/CentOS: sudo yum install zsh"
    echo "  macOS:         brew install zsh"
    echo ""
    read -p "インストール後、Enter キーを押して続行してください..."
  fi

  # 現在のデフォルトシェルを確認
  CURRENT_SHELL="$(basename "$SHELL")"
  echo "現在のシェル: $CURRENT_SHELL"

  if [ "$CURRENT_SHELL" != "zsh" ]; then
    echo ""
    echo "デフォルトシェルが zsh ではありません"
    echo "この dotfiles 環境は zsh を前提としています"
    echo ""
    read -p "デフォルトシェルを zsh に変更しますか？ (y/N): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      ZSH_PATH="$(which zsh)"

      # /etc/shells に zsh が登録されているか確認（Linux）
      if [ -f /etc/shells ] && ! grep -q "^$ZSH_PATH$" /etc/shells; then
        echo "zsh を /etc/shells に追加します（sudo 権限が必要です）"
        echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
      fi

      echo "デフォルトシェルを zsh に変更します（パスワードの入力が必要な場合があります）"
      chsh -s "$ZSH_PATH"

      echo ""
      echo "✓ デフォルトシェルを zsh に変更しました"
      echo "注意: 変更を有効にするには、一度ログアウトして再ログインしてください"
      echo ""
    else
      echo ""
      echo "注意: デフォルトシェルは変更されませんでした"
      echo "zsh を使用するには、手動で 'zsh' コマンドを実行してください"
      echo ""
    fi
  fi

  echo ""
}
