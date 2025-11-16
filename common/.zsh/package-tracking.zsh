# パッケージトラッキング
# パッケージをインストールした際に、dotfiles/packagesに自動記録する機能

# dotfilesのパスを取得
if [ -z "$DOTFILES_DIR" ]; then
  DOTFILES_DIR="${HOME}/dotfiles"
fi

# Homebrewコマンドのラッパー
brew() {
  # 実際のbrewコマンドを実行
  command brew "$@"
  local exit_code=$?

  # インストールが成功した場合のみ処理
  if [ $exit_code -eq 0 ]; then
    local brewfile="${DOTFILES_DIR}/packages/macos.brewfile"

    # brew install を検出
    if [[ "$1" == "install" ]]; then
      local is_cask=false
      local packages=()

      # 引数を解析
      shift  # "install" をスキップ
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --cask)
            is_cask=true
            shift
            ;;
          --*)
            # その他のオプションはスキップ
            shift
            ;;
          *)
            # パッケージ名を追加
            packages+=("$1")
            shift
            ;;
        esac
      done

      # 各パッケージについて確認
      for package in "${packages[@]}"; do
        if [ -f "$brewfile" ]; then
          # すでに存在するかチェック
          if [ "$is_cask" = true ]; then
            if grep -q "^cask \"${package}\"" "$brewfile"; then
              echo "✓ ${package} はすでに ${brewfile} に記録されています"
              continue
            fi
          else
            if grep -q "^brew \"${package}\"" "$brewfile"; then
              echo "✓ ${package} はすでに ${brewfile} に記録されています"
              continue
            fi
          fi
        fi

        # ユーザーに確認
        echo ""
        read -q "REPLY?${package} を dotfiles/packages に追加しますか？ (y/N): "
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          # Brewfileに追記
          if [ "$is_cask" = true ]; then
            echo "cask \"${package}\"" >> "$brewfile"
            echo "✓ cask \"${package}\" を ${brewfile} に追加しました"
          else
            echo "brew \"${package}\"" >> "$brewfile"
            echo "✓ brew \"${package}\" を ${brewfile} に追加しました"
          fi
        fi
      done
    fi
  fi

  return $exit_code
}

# APTパッケージ記録の共通処理
_track_apt_packages() {
  local aptfile="${DOTFILES_DIR}/packages/deb-apt.txt"
  local packages=("$@")

  for package in "${packages[@]}"; do
    if [ -f "$aptfile" ]; then
      # すでに存在するかチェック
      if grep -q "^${package}$" "$aptfile"; then
        echo "✓ ${package} はすでに ${aptfile} に記録されています"
        continue
      fi
    fi

    # ユーザーに確認
    echo ""
    read -q "REPLY?${package} を dotfiles/packages に追加しますか？ (y/N): "
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      # apt.txtに追記
      echo "${package}" >> "$aptfile"
      echo "✓ ${package} を ${aptfile} に追加しました"
    fi
  done
}

# apt コマンドのラッパー（Debian/Ubuntu）
if command -v apt >/dev/null 2>&1; then
  apt() {
    # 実際のaptコマンドを実行
    command apt "$@"
    local exit_code=$?

    # インストールが成功した場合のみ処理
    if [ $exit_code -eq 0 ]; then
      # apt install を検出
      if [[ "$1" == "install" ]]; then
        local packages=()

        # 引数を解析
        shift  # "install" をスキップ
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -*)
              # オプションはスキップ
              shift
              ;;
            *)
              # パッケージ名を追加
              packages+=("$1")
              shift
              ;;
          esac
        done

        # 各パッケージについて確認
        _track_apt_packages "${packages[@]}"
      fi
    fi

    return $exit_code
  }
fi

# apt-getコマンドのラッパー（Debian/Ubuntu）
if command -v apt-get >/dev/null 2>&1; then
  apt-get() {
    # 実際のapt-getコマンドを実行
    command apt-get "$@"
    local exit_code=$?

    # インストールが成功した場合のみ処理
    if [ $exit_code -eq 0 ]; then
      # apt-get install を検出
      if [[ "$1" == "install" ]]; then
        local packages=()

        # 引数を解析
        shift  # "install" をスキップ
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -*)
              # オプションはスキップ
              shift
              ;;
            *)
              # パッケージ名を追加
              packages+=("$1")
              shift
              ;;
          esac
        done

        # 各パッケージについて確認
        _track_apt_packages "${packages[@]}"
      fi
    fi

    return $exit_code
  }
fi

# sudoコマンドのラッパー（apt/apt-get install をキャプチャ）
if command -v sudo >/dev/null 2>&1; then
  sudo() {
    # 実際のsudoコマンドを実行
    command sudo "$@"
    local exit_code=$?

    # インストールが成功した場合のみ処理
    if [ $exit_code -eq 0 ]; then
      # sudo apt install または sudo apt-get install を検出
      if [[ ("$1" == "apt" || "$1" == "apt-get") && "$2" == "install" ]]; then
        local packages=()

        # 引数を解析（apt/apt-get install の後から）
        shift 2  # "apt/apt-get install" をスキップ
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -*)
              # オプションはスキップ
              shift
              ;;
            *)
              # パッケージ名を追加
              packages+=("$1")
              shift
              ;;
          esac
        done

        # 各パッケージについて確認
        if [ ${#packages[@]} -gt 0 ]; then
          _track_apt_packages "${packages[@]}"
        fi
      fi
    fi

    return $exit_code
  }
fi

# Chocolateyコマンドのラッパー（Windows）
if command -v choco >/dev/null 2>&1; then
  choco() {
    # 実際のchocoコマンドを実行
    command choco "$@"
    local exit_code=$?

    # インストールが成功した場合のみ処理
    if [ $exit_code -eq 0 ]; then
      local chocofile="${DOTFILES_DIR}/packages/win-choco.txt"

      # choco install を検出
      if [[ "$1" == "install" ]]; then
        local packages=()

        # 引数を解析
        shift  # "install" をスキップ
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -*)
              # オプションはスキップ
              shift
              ;;
            *)
              # パッケージ名を追加
              packages+=("$1")
              shift
              ;;
          esac
        done

        # 各パッケージについて確認
        for package in "${packages[@]}"; do
          if [ -f "$chocofile" ]; then
            # すでに存在するかチェック
            if grep -q "^${package}$" "$chocofile"; then
              echo "✓ ${package} はすでに ${chocofile} に記録されています"
              continue
            fi
          fi

          # ユーザーに確認
          echo ""
          read -q "REPLY?${package} を dotfiles/packages に追加しますか？ (y/N): "
          echo ""
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            # choco.txtに追記
            echo "${package}" >> "$chocofile"
            echo "✓ ${package} を ${chocofile} に追加しました"
          fi
        done
      fi
    fi

    return $exit_code
  }
fi
