# dotfiles

個人用の設定ファイル管理リポジトリ

## 管理している設定ファイル

- `.zshrc` - Zsh設定
- `.tmux.conf` - tmux設定
- `.vimrc` - Vim設定
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
├── .gitconfig         # Git設定
└── .default-gems      # rbenv default gems
```

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
