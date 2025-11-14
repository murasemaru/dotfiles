# dotfiles

個人用の設定ファイル管理リポジトリ

Rails開発を中心としたDockerベースの開発環境で、統一されたEmacs風キーバインドを提供します。

## 目次

- [管理している設定ファイル](#管理している設定ファイル)
- [セットアップ方法](#セットアップ方法)
- [環境の特徴](#環境の特徴)
- [シェル環境（Zsh）](#シェル環境zsh)
- [エディタ設定](#エディタ設定)
- [tmux設定](#tmux設定)
- [プロジェクト管理](#プロジェクト管理)
- [メモ管理](#メモ管理)
- [開発ツール](#開発ツール)
- [構造](#構造)

## 管理している設定ファイル

- `.zshrc` - Zsh設定（Powerlevel10k、Oh My Zsh、Vi-mode + Emacs風キーバインド）
- `.tmux.conf` - tmux設定（プレフィックス：Ctrl+O、Emacs準拠）
- `.vimrc` - Vim設定
- `nvim/` - Neovim設定（~/.config/nvim/）
  - `init.vim` - Emacs風キーバインド、自動補完、IME制御
- `vscode/` - VSCode設定（~/Library/Application Support/Code/User/）
  - `settings.json` - エディタ設定、Ruby開発環境
  - `keybindings.json` - キーバインド設定（Emacs風カーソル移動）
- `.gitconfig` - Git設定（SSH署名有効化）
- `.default-gems` - rbenvのデフォルトgem（tmuxinator、bundler）

## セットアップ方法

### 新しいマシンでのセットアップ

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

## 構造

```
~/dotfiles/
├── .gitignore          # Git除外設定
├── README.md           # このファイル
├── install.sh          # セットアップスクリプト
├── .zshrc             # Zsh設定
├── .tmux.conf         # tmux設定
├── .vimrc             # Vim設定
├── nvim/              # Neovim設定ディレクトリ
│   └── init.vim       # Neovim初期化ファイル
├── vscode/            # VSCode設定ディレクトリ
│   ├── settings.json  # VSCode設定
│   └── keybindings.json # キーバインド（Emacs風）
├── .gitconfig         # Git設定
└── .default-gems      # rbenv default gems
```

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

# SSH
sshneptune      # autossh経由でNeptuneサーバーへ接続
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

**Ruby開発環境:**
- Solargraphによるコード補完・フォーマット
- 保存時の自動フォーマット
- Vimプラグイン統合

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

### ワークスペース設定

```bash
# プロジェクトディレクトリ
$CHW_DIR        # ~/workspace/CHWorkforce
$CHC_DIR        # ~/workspace/CHCentral
```

### プロジェクト移動

```bash
chc             # CHCentralに移動
chw             # CHWorkforceに移動
```

### Docker Compose操作

```bash
dc              # docker compose
dcud            # docker compose up -d
dcdu            # docker compose down && up -d
```

### Rails開発（Docker経由）

```bash
dap             # pumaコンテナにアタッチ
dr              # docker compose exec puma bundle exec rails
dmb             # マイグレーション（本番＆テスト両方）
bers            # RSpec実行（ドキュメント形式）
```

### プロジェクト一括操作

**CHWorkforce起動:**
```bash
chuw            # tmux終了 -> CHWorkforce起動 -> tmuxinator起動
```

**CHCentral + CHWorkforce起動:**
```bash
chuc            # tmux終了 -> CHCentral起動 -> CHWorkforce起動 -> 両方のtmuxinator起動
```

**プロジェクト停止:**
```bash
chdw            # CHWorkforce停止
chdc            # CHCentral + CHWorkforce停止
```

### その他のプロジェクト

```bash
keen            # KeenDemoプロジェクト起動
```

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

### Ruby管理（rbenv）

- rbenvによるバージョン管理
- 新しいRubyインストール時に自動インストールされるgem:
  - `tmuxinator` - tmuxセッション管理
  - `bundler` - gem依存関係管理

### Node.js管理（nodebrew）

- nodebrew経由でNode.jsバージョン管理
- `~/.nodebrew/current/bin` にパスが通っています

### Git設定

- SSH鍵によるコミット署名（GPG代替）
- `~/.ssh/id_ed25519.bastion` を使用

### AWS

```bash
bedrock         # AWS SSO認証（bedrockプロファイル）
```

### iTerm2統合

シェル統合機能が有効化されており、以下が利用可能:
- コマンド履歴のマーキング
- シェルプロンプトジャンプ
- ディレクトリ履歴

## 注意事項

- 機密情報（SSH鍵、AWSクレデンシャルなど）は `.gitignore` で除外されています
- 機密情報を含む設定ファイルは別途管理してください
- このリポジトリをプライベートリポジトリとして管理することを推奨します

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
