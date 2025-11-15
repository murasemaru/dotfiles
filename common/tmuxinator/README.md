# Tmuxinator設定

プロジェクト固有のtmuxセッション設定を管理します。

## 使い方

### 新しいプロジェクト設定を作成

```bash
# sample.ymlをコピーして編集
cp ~/.config/tmuxinator/sample.yml ~/.config/tmuxinator/myproject.yml
vim ~/.config/tmuxinator/myproject.yml
```

### セッションの起動

```bash
# プロジェクトセッションを起動
tmuxinator start myproject

# または省略形
mux start myproject
```

### 設定ファイルの一覧

```bash
tmuxinator list
```

### 設定ファイルの編集

```bash
tmuxinator edit myproject
```

## 会社固有の設定

会社固有のプロジェクト設定（CHWorkforce、CHCentralなど）は `dotfiles-th` リポジトリで管理されています。
