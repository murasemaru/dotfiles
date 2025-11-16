# 手動インストールが必要なパッケージ

このファイルには、自動インストールが難しい、または手動での設定が推奨されるツールをリストします。

## fzf (追加設定)

fzfはパッケージマネージャーでインストール後、追加のセットアップが必要です。

### macOS (Homebrew)
```bash
brew install fzf
$(brew --prefix)/opt/fzf/install
```

### Linux
```bash
# git-repos.txtでクローン後
~/.fzf/install
```

## Docker Desktop

### macOS
https://www.docker.com/products/docker-desktop/ からダウンロードしてインストール

### Windows
https://www.docker.com/products/docker-desktop/ からダウンロードしてインストール

### Linux
各ディストリビューションの公式ドキュメントに従ってインストール：
- Ubuntu: https://docs.docker.com/engine/install/ubuntu/
- Debian: https://docs.docker.com/engine/install/debian/

## Homebrew (macOS)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Chocolatey (Windows)

管理者権限のPowerShellで実行：
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

## rbenv

### macOS
```bash
brew install rbenv
rbenv init
```

### Linux
```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

## VSCode 拡張機能

手動でインストールを推奨：
- Vim
- Ruby (Solargraph)
- Docker

## iTerm2 (macOS)

### シェル統合
```bash
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
```

## 注意事項

- パッケージマネージャーが無い場合は、まず `manual.md` の手順でインストールしてください
- セキュリティ上の理由から、スクリプトを実行する前に内容を確認してください
- 環境によってはsudoパスワードの入力が必要です
