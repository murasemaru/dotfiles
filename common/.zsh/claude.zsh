# ========================================
# Claude Code + Tmux + fzf 設定
# ========================================

# tmux-claude コマンド：tmux セッション内で Claude Code を起動
function tmux-claude() {
  local session_name="claude-${1:-$(date +%Y%m%d-%H%M%S)}"

  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "セッション '$session_name' は既に存在します。"
    echo "接続するには: tmux attach -t $session_name"
    return 1
  fi

  # 新しい tmux セッションを作成して Claude Code を起動
  tmux new-session -s "$session_name" -d
  tmux send-keys -t "$session_name" "claude" C-m
  tmux attach -t "$session_name"
}

# エイリアス
alias tc='tmux-claude'

# claude-attach コマンド：既存の Claude Code セッションを選択して接続（fzf版）
function claude-attach() {
  # claude- で始まる tmux セッションを検索
  local sessions=($(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^claude-'))

  if [ ${#sessions[@]} -eq 0 ]; then
    echo "Claude Code の tmux セッションが見つかりませんでした。"
    echo "'claude' コマンドで新しいセッションを作成できます。"
    return 1
  fi

  if [ ${#sessions[@]} -eq 1 ]; then
    # セッションが1つだけの場合は自動的に接続
    echo "セッション '${sessions[1]}' に接続します..."
    tmux attach -t "${sessions[1]}"
    return 0
  fi

  # 複数のセッションがある場合は fzf で選択
  local selected=$(printf '%s\n' "${sessions[@]}" | \
    fzf --height 50% \
        --reverse \
        --prompt="接続するセッション: " \
        --preview 'tmux capture-pane -ep -t {} 2>/dev/null | tail -50' \
        --preview-window=down:70%:wrap \
        --header='Enter: 接続 | Esc: キャンセル'
  )

  if [ -n "$selected" ]; then
    echo "セッション '$selected' に接続します..."
    tmux attach -t "$selected"
  fi
}

# エイリアス
alias ca='claude-attach'
alias cls='tmux list-sessions 2>/dev/null | grep "^claude-"'  # Claude セッション一覧
