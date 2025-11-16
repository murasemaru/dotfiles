#!/bin/bash

# ソフトウェア存在チェック機能
# パッケージファイルに記載されているソフトウェアが存在するかチェックし、
# 不足している場合はインストールを提案する

# macOS: Brewfileから不足パッケージを検出
check_missing_macos_packages() {
  local brewfile="$DOTFILES_DIR/packages/macos.brewfile"
  local missing=()

  if [ ! -f "$brewfile" ]; then
    return 0
  fi

  # Homebrewがインストールされているかチェック
  if ! command -v brew >/dev/null 2>&1; then
    echo "⚠️  Homebrewがインストールされていません"
    return 1
  fi

  # Brewfileを解析
  while IFS= read -r line; do
    # コメント行と空行をスキップ
    [[ "$line" =~ ^# ]] && continue
    [[ -z "$line" ]] && continue

    # brew/caskを抽出
    if [[ "$line" =~ ^brew[[:space:]]+\"([^\"]+)\" ]]; then
      local package="${BASH_REMATCH[1]}"
      if ! brew list --formula | grep -q "^${package}$"; then
        missing+=("brew:$package")
      fi
    elif [[ "$line" =~ ^cask[[:space:]]+\"([^\"]+)\" ]]; then
      local cask="${BASH_REMATCH[1]}"
      if ! brew list --cask | grep -q "^${cask}$"; then
        missing+=("cask:$cask")
      fi
    fi
  done < "$brewfile"

  echo "${missing[@]}"
}

# Linux: apt パッケージリストから不足パッケージを検出
check_missing_apt_packages() {
  local aptfile="$DOTFILES_DIR/packages/deb-apt.txt"
  local missing=()

  if [ ! -f "$aptfile" ]; then
    return 0
  fi

  # aptがインストールされているかチェック
  if ! command -v apt >/dev/null 2>&1 && ! command -v apt-get >/dev/null 2>&1; then
    return 0
  fi

  while IFS= read -r package; do
    # コメント行と空行をスキップ
    [[ "$package" =~ ^# ]] && continue
    [[ -z "$package" ]] && continue

    if ! dpkg -l | grep -q "^ii  ${package} "; then
      missing+=("$package")
    fi
  done < "$aptfile"

  echo "${missing[@]}"
}

# 不足ソフトウェアの表示とインストール提案
prompt_install_missing_software() {
  local os_type="$1"

  echo ""
  echo "=========================================="
  echo "  ソフトウェア依存関係チェック"
  echo "=========================================="
  echo ""

  local missing_packages=()

  case "$os_type" in
    macos)
      missing_packages=($(check_missing_macos_packages))
      ;;
    debian|ubuntu|linux)
      missing_packages=($(check_missing_apt_packages))
      ;;
    *)
      echo "このOSでは自動チェックをサポートしていません"
      echo ""
      return 0
      ;;
  esac

  if [ ${#missing_packages[@]} -eq 0 ]; then
    echo "✓ パッケージファイルに記載されているソフトウェアはすべてインストールされています"
    echo ""
    return 0
  fi

  echo "⚠️  以下のソフトウェアがインストールされていません:"
  echo ""
  for item in "${missing_packages[@]}"; do
    if [[ "$item" =~ ^brew: ]]; then
      echo "  - ${item#brew:} (Homebrew formula)"
    elif [[ "$item" =~ ^cask: ]]; then
      echo "  - ${item#cask:} (Homebrew cask)"
    else
      echo "  - $item"
    fi
  done
  echo ""

  # --packages フラグの確認
  if [ "$INSTALL_PACKAGES" = true ]; then
    echo "パッケージインストールが有効になっています。"
    echo "これらのソフトウェアは後ほどインストール処理で確認されます。"
  else
    echo "これらのソフトウェアは dotfiles の設定で使用されます。"
    echo ""
    read -p "今すぐインストールしますか？ (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      # INSTALL_PACKAGES フラグを有効にして再実行を促す
      echo ""
      echo "インストールを開始します..."
      INSTALL_PACKAGES=true
      source "$DOTFILES_DIR/lib/package_installer.sh"
      install_packages "$os_type"
    else
      echo ""
      echo "後でインストールする場合は以下のコマンドを実行してください:"
      echo -e "  ${BLUE}./install.sh --packages${NC}"
    fi
  fi

  echo ""
  return 1
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
