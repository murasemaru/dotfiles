#!/bin/bash

# ソフトウェア存在チェック機能
# dotfilesで使用するソフトウェアが存在するかチェックし、
# 不足している場合はインストールを提案する

# 必須ソフトウェアリスト（全OS共通）
REQUIRED_SOFTWARE=(
  "git:Git version control"
  "tmux:Terminal multiplexer"
  "nvim:Neovim editor"
)

# 推奨ソフトウェアリスト（全OS共通）
RECOMMENDED_SOFTWARE=(
  "fzf:Fuzzy finder"
  "bat:Cat with syntax highlighting"
)

# ソフトウェアの存在チェック
check_software() {
  local software_list=("$@")
  local missing_software=()

  for item in "${software_list[@]}"; do
    local cmd="${item%%:*}"
    local desc="${item#*:}"

    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing_software+=("$cmd:$desc")
    fi
  done

  echo "${missing_software[@]}"
}

# 不足ソフトウェアの表示とインストール提案
prompt_install_missing_software() {
  echo ""
  echo "=========================================="
  echo "  ソフトウェア依存関係チェック"
  echo "=========================================="
  echo ""

  # 必須ソフトウェアのチェック
  local missing_required=($(check_software "${REQUIRED_SOFTWARE[@]}"))

  if [ ${#missing_required[@]} -gt 0 ]; then
    echo "⚠️  以下の必須ソフトウェアがインストールされていません:"
    echo ""
    for item in "${missing_required[@]}"; do
      local cmd="${item%%:*}"
      local desc="${item#*:}"
      echo "  - ${cmd} (${desc})"
    done
    echo ""
  fi

  # 推奨ソフトウェアのチェック
  local missing_recommended=($(check_software "${RECOMMENDED_SOFTWARE[@]}"))

  if [ ${#missing_recommended[@]} -gt 0 ]; then
    echo "💡 以下の推奨ソフトウェアがインストールされていません:"
    echo ""
    for item in "${missing_recommended[@]}"; do
      local cmd="${item%%:*}"
      local desc="${item#*:}"
      echo "  - ${cmd} (${desc})"
    done
    echo ""
  fi

  # インストール提案
  if [ ${#missing_required[@]} -gt 0 ] || [ ${#missing_recommended[@]} -gt 0 ]; then
    echo "これらのソフトウェアは dotfiles の設定で使用されます。"
    echo ""

    # --packages フラグの確認
    if [ "$INSTALL_PACKAGES" = true ]; then
      echo "パッケージインストールが有効になっています。"
      echo "不足しているソフトウェアは自動的にインストールされます。"
    else
      echo "インストールするには以下のコマンドを実行してください:"
      echo -e "  ${BLUE}./install.sh --packages${NC}"
      echo ""
      echo "または、手動でインストールする場合:"
      echo "  packages/ ディレクトリを参照してください"
    fi

    echo ""
    return 1
  else
    echo "✓ すべての必須ソフトウェアがインストールされています"
    echo ""
    return 0
  fi
}

# Oh My Zsh のチェック
check_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    echo "⚠️  Oh My Zsh がインストールされていません"
    echo ""
    read -p "Oh My Zsh をインストールしますか？ (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "Oh My Zsh をインストールしています..."
      git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

      # Powerlevel10k のインストール
      if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        echo "Powerlevel10k をインストールしています..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
          "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
      fi

      # プラグインのインストール
      if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo "zsh-autosuggestions をインストールしています..."
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
          "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
      fi

      if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        echo "zsh-syntax-highlighting をインストールしています..."
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
          "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
      fi

      echo "✓ Oh My Zsh のインストールが完了しました"
    else
      echo "Oh My Zsh のインストールをスキップしました"
      echo "注意: .zshrc の一部機能が動作しない可能性があります"
    fi
    echo ""
  fi
}

# fzf のチェック
check_fzf() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo ""
    echo "💡 fzf (Fuzzy finder) がインストールされていません"
    echo ""
    read -p "fzf をインストールしますか？ (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      if [ -d "$HOME/.fzf" ]; then
        echo "fzf ディレクトリは既に存在します"
      else
        echo "fzf をインストールしています..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all --no-bash --no-fish
        echo "✓ fzf のインストールが完了しました"
      fi
    else
      echo "fzf のインストールをスキップしました"
    fi
    echo ""
  fi
}
