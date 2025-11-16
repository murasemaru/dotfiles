# ========================================
# .zshrc 管理ユーティリティ（fzf版）
# ========================================

# ez コマンド：fzf で設定ファイルを選択して編集
function ez() {
  # 編集可能なファイルリストを生成
  local files=(
    ~/.zshrc
    ~/.zsh/*.zsh(N)  # (N) は該当ファイルがなくてもエラーにしない
  )

  # fzf で選択
  local selected=$(printf '%s\n' "${files[@]}" | \
    fzf --height 60% \
        --reverse \
        --prompt="編集するファイル: " \
        --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat -n {}' \
        --preview-window=right:60%:wrap \
        --header='Enter: 編集 | Esc: キャンセル'
  )

  if [ -n "$selected" ]; then
    $EDITOR "$selected"
  fi
}

# よく使うファイルへの個別エイリアス
alias ezm='$EDITOR ~/.zshrc'                    # main
alias eza='$EDITOR ~/.zsh/aliases.zsh'          # aliases
alias ezd='$EDITOR ~/.zsh/docker.zsh'           # docker
alias ezv='$EDITOR ~/.zsh/vim-mode.zsh'         # vim-mode
alias ezf='$EDITOR ~/.zsh/functions.zsh'        # functions
alias ezu='$EDITOR ~/.zsh/zshrc-utils.zsh'      # utils
alias ezp='$EDITOR ~/.zsh/package-tracking.zsh' # package tracking
alias ezall='$EDITOR ~/.zshrc ~/.zsh/*.zsh'     # 全て開く

# rz コマンド：.zshrc をリロード
alias rz='source ~/.zshrc'
