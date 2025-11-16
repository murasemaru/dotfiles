# dotfiles

個人用の設定ファイル管理リポジトリ

**対応OS:** macOS, Linux (Debian, RedHat系), Windows (WSL)

## 目次

- [環境要件](#環境要件)
- [管理している設定ファイル](#管理している設定ファイル)
- [セットアップ方法](#セットアップ方法)
- [ディレクトリ構造](#ディレクトリ構造)
- [環境の特徴](#環境の特徴)
- [シェル環境（Zsh）](#シェル環境zsh)
- [エディタ設定](#エディタ設定)
- [tmux設定](#tmux設定)
- [プロジェクト管理](#プロジェクト管理)
- [メモ管理](#メモ管理)
- [開発ツール](#開発ツール)

## 環境要件

### 必須

**この dotfiles 環境は zsh を前提としています。**

- **zsh** - デフォルトシェルとして使用
  - macOS: `brew install zsh`（通常はプリインストール済み）
  - Debian/Ubuntu: `sudo apt-get install zsh`
  - RedHat/CentOS: `sudo yum install zsh`

インストールスクリプト（`install.sh`）は以下を自動で行います：
- zsh のインストール確認
- デフォルトシェルが zsh でない場合、切り替えを提案
- 必要に応じて `/etc/shells` への登録

### 推奨

以下のツールは設定で使用されていますが、なくても動作します：

- **Git** - バージョン管理
- **tmux** - ターミナルマルチプレクサ
- **Neovim** - モダンなVimエディタ
- **fzf** - ファジー検索ツール
- **bat** - catの代替（シンタックスハイライト付き）
- **Oh My Zsh** - Zshフレームワーク
- **Powerlevel10k** - Zshテーマ

**自動インストール:**
```bash
./install.sh --packages
```

手動インストールの詳細は `packages/` ディレクトリを参照してください。

## 管理している設定ファイル

- `.zshrc` - Zsh設定（Powerlevel10k、Oh My Zsh、Vi-mode + Emacs風キーバインド）
- `.tmux.conf` - tmux設定（プレフィックス：Ctrl+O、Emacs準拠）
- `.vimrc` - Vim設定
- `nvim/` - Neovim設定（~/.config/nvim/）
  - `init.vim` - Emacs風キーバインド、自動補完、IME制御
- `vscode/` - VSCode設定（~/Library/Application Support/Code/User/）
  - `settings.json` - エディタ設定
  - `keybindings.json` - キーバインド設定（Emacs風カーソル移動）
- `.gitconfig` - Git設定（SSH署名有効化）

## セットアップ方法

### 新しいマシンでのセットアップ

#### 基本セットアップ（シンボリックリンクのみ）

```bash
# リポジトリをクローン
cd ~
git clone <your-repo-url> dotfiles

# インストールスクリプトを実行
cd dotfiles
./install.sh

# 設定を反映
source ~/.zshrc
```

#### フルセットアップ（パッケージ込み）

```bash
# リポジトリをクローン
cd ~
git clone <your-repo-url> dotfiles

# パッケージもインストール
cd dotfiles
./install.sh --packages

# 設定を反映
source ~/.zshrc
```

**インストールスクリプトの機能:**
- **自動依存関係チェック**: 不足しているソフトウェアを検出し、インストールを提案
- **インタラクティブインストール**: Oh My Zsh、fzfなどの主要ツールをインストールするか確認
- `--packages` オプションでパッケージ管理ファイルからまとめてインストール
- パッケージマネージャー（Homebrew、apt、choco）が無い場合は先にインストールが必要
- 詳細は `packages/manual.md` を参照

**依存関係チェック例:**
```
⚠️  以下の必須ソフトウェアがインストールされていません:
  - tmux (Terminal multiplexer)
  - nvim (Neovim editor)

💡 以下の推奨ソフトウェアがインストールされていません:
  - fzf (Fuzzy finder)
  - bat (Cat with syntax highlighting)

インストールするには以下のコマンドを実行してください:
  ./install.sh --packages
```

### 既存マシンでの使用

設定ファイルは `~/dotfiles` で管理され、ホームディレクトリにシンボリックリンクが作成されます。

設定を変更する場合は：

```bash
# 設定ファイルを直接編集（シンボリックリンク経由）
vim ~/.zshrc

# または dotfiles ディレクトリで編集
cd ~/dotfiles
vim .zshrc

# 変更をコミット
git add .zshrc
git commit -m "Update zsh configuration"
git push
```

## ディレクトリ構造

```
~/dotfiles/
├── install.sh                    # メインセットアップスクリプト（OS自動検出）
├── README.md                     # このファイル
├── .gitignore                    # Git除外設定
│
├── lib/                          # 共通関数ライブラリ
│   └── functions.sh             # 各install.shから参照される共通関数
│
├── common/                       # 全OS共通設定
│   ├── install.sh               # 共通設定インストールスクリプト
│   ├── .zshrc                   # Zsh設定
│   ├── .tmux.conf               # tmux設定
│   ├── .vimrc                   # Vim設定
│   ├── .gitconfig               # Git設定
│   ├── .zsh/                    # Zsh設定モジュール（6ファイル）
│   │   ├── aliases.zsh          # 基本エイリアス
│   │   ├── docker.zsh           # Docker関連
│   │   ├── functions.zsh        # カスタム関数
│   │   ├── vim-mode.zsh         # Vi-mode設定
│   │   ├── zshrc-utils.zsh      # 設定管理
│   │   ├── package-tracking.zsh # パッケージ自動記録
│   │   └── README.md            # ドキュメント
│   ├── nvim/                    # Neovim設定
│   └── tmuxinator/              # tmux セッション定義
│
├── macos/                        # macOS専用設定
│   ├── install.sh               # macOS設定インストールスクリプト
│   ├── karabiner/               # Karabiner設定
│   └── vscode/                  # VSCode設定
│       ├── settings.json
│       └── keybindings.json
│
├── linux/                        # Linux専用設定
│   └── install.sh               # Linux設定インストールスクリプト
│
└── windows/                      # Windows専用設定（WSL想定）
    └── install.sh               # Windows設定インストールスクリプト
```

### クロスプラットフォーム対応

- **OS自動検出**: `install.sh`がOSを自動検出し、適切な設定のみをインストール
  - macOS: `Darwin`
  - Linux: Debian、RedHat系
  - Windows: WSL (Windows Subsystem for Linux)
  - Git Bash: MINGW/MSYS環境
- **分離された設定**:
  - `common/` - すべてのOSで共通する設定（Zsh、tmux、Vim、Neovim、Git）
  - `macos/` - macOS専用（Karabiner、VSCode）
  - `linux/` - Linux専用（今後追加予定）
  - `windows/` - Windows専用（WSL想定、今後追加予定）
- **保守性**: 各ディレクトリに独立した`install.sh`で管理が容易
- **共通関数**: `lib/functions.sh`に共通関数を集約（DRY原則）

## 環境の特徴

### 統一されたキーバインド

Zsh、Neovim、VSCode、tmuxの全てで**Emacs風キーバインド**を採用し、一貫した操作感を実現しています。

**共通のキーバインド:**
- `Ctrl+P` : 上に移動 / 前のコマンド
- `Ctrl+N` : 下に移動 / 次のコマンド
- `Ctrl+F` : 右に移動（1文字）
- `Ctrl+B` : 左に移動（1文字）
- `Ctrl+A` : 行頭に移動
- `Ctrl+E` : 行末に移動
- `Ctrl+R` : 履歴検索（逆順）
- `Ctrl+K` : カーソルから行末まで削除

### Docker中心のワークフロー

Railsアプリケーションは全てDocker Compose経由で実行し、複数のマイクロサービスを効率的に管理できます。

### 生産性重視の設計

- tmuxinatorによるプロジェクト環境の一括起動
- プロジェクト間の高速切り替え
- メモの即座な記録・管理

## シェル環境（Zsh）

### プロンプト・外観

- **Powerlevel10k** テーマによる高機能プロンプト
- **Oh My Zsh** フレームワーク使用
- 自動補完（zsh-autosuggestions）
- シンタックスハイライト（zsh-syntax-highlighting）

### キーバインド

**Vi-mode + Emacs風キーバインドのハイブリッド**

```bash
# モード切替
jj              # Insert -> Normal（Escの代わり）

# インサートモードでEmacs風操作
Ctrl+A          # 行頭
Ctrl+E          # 行末
Ctrl+F          # 右へ1文字
Ctrl+B          # 左へ1文字
Ctrl+D          # カーソル位置の文字を削除
Ctrl+K          # カーソルから行末まで削除
Ctrl+W          # 単語削除
Ctrl+U          # カーソルから行頭まで削除
Ctrl+R          # 履歴検索（逆順）
Ctrl+S          # 履歴検索（前方）
Ctrl+P          # 前のコマンド
Ctrl+N          # 次のコマンド
```

### プラグイン

- **git** - Gitエイリアスとステータス表示
- **docker** / **docker-compose** - Docker補完
- **rails** - Railsコマンド補完
- **z** - ディレクトリジャンプ（頻度ベース）

### 便利なエイリアス

```bash
# エディタ
vim, vi         # nvimにマップ
ez              # .zshrcを編集
rz              # .zshrcを再読み込み
```

## エディタ設定

### Neovim

**基本設定:**
- 行番号表示（相対行番号も有効）
- システムクリップボード統合
- タブ幅2スペース
- 検索時の大文字小文字の自動判別
- カーソル行ハイライト

**IME制御:**
- Insertモード終了時に自動的にIMEをオフ
- `Ctrl+C`でも確実にIMEオフ

**キーバインド:**
```vim
" Leaderキー
Space           " Leader

" インサートモードでEmacs風操作
Ctrl+P          " 上に移動
Ctrl+N          " 下に移動
Ctrl+F          " 右に移動
Ctrl+B          " 左に移動
Ctrl+A          " 行頭
Ctrl+E          " 行末
Ctrl+D          " 文字削除
jj              " Insert -> Normal

" ファイル操作
Space+w         " 保存
Space+q         " 終了
```

**自動補完:**
- 2文字入力で自動補完表示
- `Tab` / `Shift+Tab` で補完候補選択
- `Enter` で補完確定

### VSCode

**補完設定:**
- 文字入力時に即座に補完表示（遅延ゼロ）
- `Tab` / `Shift+Tab` で補完候補選択

**キーバインド:**
- Vimモード使用時もEmacs風カーソル移動が機能
- `Ctrl+P/N/F/B` でカーソル移動（VimのInsertモード中も有効）

## tmux設定

### プレフィックスキー

デフォルトの`Ctrl+B`から**`Ctrl+O`**に変更

```bash
Ctrl+O          # プレフィックスキー
Ctrl+O Ctrl+O   # Ctrl+Oをそのまま送信
```

### ペイン操作

```bash
Ctrl+O |        # 縦分割
Ctrl+O -        # 横分割
Ctrl+O r        # 設定ファイル再読み込み
```

### マウス操作

- ペイン選択
- ペインのサイズ変更
- スクロール

### Emacs準拠モード

tmuxの操作モード（コマンド、コピー）をEmacs準拠に設定し、`Ctrl+P/N/A/E/S/R`がシェルで正常に機能するように衝突を解除しています。

## プロジェクト管理

### Docker Compose操作

```bash
dc              # docker compose
dcud            # docker compose up -d
dcdu            # docker compose down && up -d
```

プロジェクト固有の設定は `dotfiles-th` リポジトリで管理しています。

## メモ管理

### メモ機能

```bash
memo            # nvimでメモディレクトリを開く
memo <name>     # 指定名のメモを開く（例：memo meeting）
memo -d         # 今日の日付でメモを開く（例：2025-11-14.txt）
memo --date     # -d と同じ

cd memo         # どこからでもメモディレクトリに移動可能
```

メモは `~/memo` ディレクトリに保存されます。

## 開発ツール

### Node.js管理（nodebrew）

- nodebrew経由でNode.jsバージョン管理
- `~/.nodebrew/current/bin` にパスが通っています

### iTerm2統合

シェル統合機能が有効化されており、以下が利用可能:
- コマンド履歴のマーキング
- シェルプロンプトジャンプ
- ディレクトリ履歴

### パッケージ自動記録

パッケージマネージャーでソフトウェアをインストールすると、自動的にdotfilesに記録するか確認されます：

```bash
# macOS
brew install ripgrep
# → ripgrep を packages/macos.brewfile に追加しますか？ (y/N):

brew install --cask notion
# → notion を packages/macos.brewfile に追加しますか？ (y/N):

# Linux
sudo apt install htop
# → htop を packages/deb-apt.txt に追加しますか？ (y/N):

# apt-get でも動作します
sudo apt-get install htop
# → htop を packages/deb-apt.txt に追加しますか？ (y/N):

# Windows
choco install nodejs
# → nodejs を packages/win-choco.txt に追加しますか？ (y/N):
```

**記録されるファイル:**
- `packages/macos.brewfile` - Homebrew パッケージ
- `packages/deb-apt.txt` - APT パッケージ
- `packages/win-choco.txt` - Chocolatey パッケージ

すでに記録済みのパッケージは自動でスキップされます。

## 設定ファイルの追加方法

新しい設定ファイルを管理に追加する場合：

```bash
# 1. ファイルを dotfiles に移動
mv ~/.newconfig ~/dotfiles/.newconfig

# 2. シンボリックリンクを作成
ln -s ~/dotfiles/.newconfig ~/.newconfig

# 3. install.sh にエントリを追加
# install.sh を編集して create_symlink 行を追加

# 4. Gitにコミット
cd ~/dotfiles
git add .newconfig install.sh
git commit -m "Add .newconfig"
git push
```
