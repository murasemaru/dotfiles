# dotfiles

個人用の設定ファイル管理リポジトリ

## 管理している設定ファイル

- `.zshrc` - Zsh設定
- `.tmux.conf` - tmux設定
- `.vimrc` - Vim設定
- `nvim/` - Neovim設定（~/.config/nvim/）
- `vscode/` - VSCode設定（~/Library/Application Support/Code/User/）
  - `settings.json` - エディタ設定
  - `keybindings.json` - キーバインド設定（Emacs風カーソル移動）
- `.gitconfig` - Git設定
- `.default-gems` - rbenvのデフォルトgem

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

## エディタ設定の特徴

### Neovim
- インサートモードでEmacs風カーソル移動（C-p/C-n/C-f/C-b）
- 2文字入力で自動補完表示
- Tab/Shift-Tabで補完候補選択

### VSCode
- インサートモードでEmacs風カーソル移動（C-p/C-n/C-f/C-b）
- 文字入力時に即座に補完表示（遅延なし）
- Tab/Shift-Tabで補完候補選択
- Vimプラグイン使用時もEmacs風カーソル移動が機能

**共通のキーバインド:**
- `C-p` : 上に移動
- `C-n` : 下に移動
- `C-f` : 右に移動
- `C-b` : 左に移動
- `Tab` : 補完候補の次へ
- `Shift-Tab` : 補完候補の前へ
- `Enter` : 補完確定

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
