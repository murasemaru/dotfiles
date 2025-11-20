#!/bin/bash

# パッケージインストーラー
# 各OSに応じてパッケージをインストールする

# パッケージインストールのメイン関数
install_packages() {
  local os_type="$1"
  local packages_dir="$DOTFILES_DIR/packages"

  echo ""
  echo "========================================"
  echo "  パッケージのインストール"
  echo "========================================"
  echo ""
  echo "⚠️  注意: パッケージマネージャーが無い場合は先にインストールしてください"
  echo "詳細: packages/manual.md を参照"
  echo ""

  read -p "パッケージをインストールしますか？ (y/N): " response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "パッケージインストールをスキップしました"
    return 0
  fi

  # Gitリポジトリのクローン（全OS共通）
  install_git_repos "$packages_dir/git-repos.txt"

  case "$os_type" in
    macos)
      install_macos_packages "$packages_dir"
      ;;
    debian|ubuntu)
      install_debian_packages "$packages_dir"
      ;;
    wsl)
      echo "WSL環境を検出しました"
      install_debian_packages "$packages_dir"
      ;;
    *)
      echo "このOSでは自動インストールをサポートしていません"
      echo "packages/ ディレクトリのファイルを参照して手動でインストールしてください"
      ;;
  esac
  }

# macOS用パッケージインストール
install_macos_packages() {
  local packages_dir="$1"

  if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Homebrewがインストールされていません"
    echo ""
    read -p "Homebrewをインストールしますか？ (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "Homebrewをインストールしています..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      # Apple Siliconの場合、PATHを設定
      if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    else
      echo "Homebrewのインストールをスキップしました"
      echo "手動でインストールする場合: packages/manual.md を参照"
      return 1
    fi
  fi

  echo ""
  echo "Homebrewでパッケージをインストールしています..."

  # Brewfileを解析して逐次確認しながらインストール
  while IFS= read -r line; do
    # コメント行と空行をスキップ
    [[ "$line" =~ ^# ]] && continue
    [[ -z "$line" ]] && continue

    # brew/caskを抽出
    if [[ "$line" =~ ^brew[[:space:]]+\"([^\"]+)\" ]]; then
      local package="${BASH_REMATCH[1]}"

      # すでにインストール済みか確認
      if brew list --formula | grep -q "^${package}$"; then
        echo "✓ $package はすでにインストール済みです（スキップ）"
      else
        read -p "brew install $package を実行しますか？ (y/N): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          brew install "$package"
        else
          echo "  → $package をスキップしました"
        fi
      fi
    elif [[ "$line" =~ ^cask[[:space:]]+\"([^\"]+)\" ]]; then
      local cask="${BASH_REMATCH[1]}"

      # すでにインストール済みか確認
      if brew list --cask | grep -q "^${cask}$"; then
        echo "✓ $cask はすでにインストール済みです（スキップ）"
      else
        read -p "brew install --cask $cask を実行しますか？ (y/N): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
          brew install --cask "$cask"
        else
          echo "  → $cask をスキップしました"
        fi
      fi
    fi
  done < "$packages_dir/macos.brewfile"
}

# Debian/Ubuntu用パッケージインストール
install_debian_packages() {
  local packages_dir="$1"

  echo ""
  echo "aptでパッケージをインストールしています..."
  echo "sudoパスワードの入力が必要です"

  # パッケージリストを更新
  read -p "apt-get update を実行しますか？ (y/N): " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    sudo apt-get update
  fi

  # パッケージをインストール
  while IFS= read -r package; do
    # コメント行と空行をスキップ
    [[ "$package" =~ ^# ]] && continue
    [[ -z "$package" ]] && continue

    # すでにインストール済みか確認
    if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
      echo "✓ $package はすでにインストール済みです（スキップ）"
    else
      read -p "apt-get install $package を実行しますか？ (y/N): " response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        sudo apt-get install -y "$package"
      else
        echo "  → $package をスキップしました"
      fi
    fi
  done < "$packages_dir/deb-apt.txt"
}

# Gitリポジトリのクローン
install_git_repos() {
  local repos_file="$1"

  echo ""
  echo "Gitリポジトリをクローンしています..."

  while IFS=' ' read -r repo dest; do
    # コメント行と空行をスキップ
    [[ "$repo" =~ ^# ]] && continue
    [[ -z "$repo" ]] && continue

    # ~を展開
    dest=$(eval echo "$dest")

    if [ -d "$dest" ]; then
      echo "✓ すでに存在: $dest"
    else
      echo ""
      echo "リポジトリ: $repo"
      echo "インストール先: $dest"
      read -p "クローンしますか？ (y/N): " response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        git clone --depth=1 "$repo" "$dest" 2>/dev/null || {
          echo "  ❌ クローンに失敗しました"
          continue
        }
        echo "  ✓ 完了"
      else
        echo "  → スキップしました"
      fi
    fi
  done < "$repos_file"

  echo ""
  echo "✓ Gitリポジトリの処理が完了しました"
}
