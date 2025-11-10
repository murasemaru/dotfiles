# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================
# Oh My Zsh設定
# =========================================
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k" 

plugins=(
  git
  docker
  docker-compose
  rails
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
)

source $ZSH/oh-my-zsh.sh
# ========================================
# ディレクトリ定義
# ========================================
export CHW_DIR="$HOME/workspace/CHWorkforce"
export CHC_DIR="$HOME/workspace/CHCentral"

# ========================================
# PATH設定
# ========================================
typeset -U path PATH
path=(
/opt/homebrew/bin(N-/)
$HOME/.nodebrew/current/bin
$path
)

# ========================================
# 機密情報（別ファイルから読み込み）
# ========================================
if [ -f ~/.secrets.env ]; then
source ~/.secrets.env
fi

# ========================================
# プロンプト設定
# ========================================
PROMPT="%K{red}%F{black}%n ($(arch)):%~"$'\n'"%# %f%k"

# ========================================
# エディタ設定
# ========================================
export EDITOR='vim'

# ========================================
# SSH
# ========================================
alias sshneptune='autossh -M 0 chw-int-neptune'

# ========================================
# ディレクトリ移動
# ========================================
alias chc='cd "$CHC_DIR"'
alias chw='cd "$CHW_DIR"'

# ========================================
# Docker Compose
# ========================================
alias dc='docker compose'
alias dcud='docker compose up -d'
alias dcdu='docker compose down ; docker compose up -d'

# ========================================
# Rails（Docker経由）
# ========================================
alias dap='docker attach chworkforce-puma-1'
alias dr='docker compose exec puma bundle exec rails'
alias dmb='dr db:migrate && drt db:migrate'
alias bers='docker compose exec puma bundle exec rspec --format documentation'

# ========================================
# プロジェクト起動・停止
# ========================================
alias chuw='tmux kill-server ; echo "$CHW_DIR" ; cd "$CHW_DIR" && make up-all && tmuxinator chw'
alias chuc='tmux kill-server ; cd "$CHC_DIR" && dcdu && tmuxinator chc && cd "$CHW_DIR" && make up-all && tmuxinator chw'
alias chdw='tmux kill-server ; cd "$CHW_DIR" && make down'
alias chdc='tmux kill-server ; cd "$CHW_DIR" && make down ; cd "$CHC_DIR" && dc down'

# ========================================
# その他
# ========================================
alias keen="cd ~/workspace/KeenDemo && docker compose up -d && cd ~/workspace/CHWorkforce"
alias rz='source ~/.zshrc'
alias ez='vim ~/.zshrc'

# ========================================
# rbenv
# ========================================
eval "$(rbenv init - zsh)"

# ========================================
# iTerm2 Integration
# ========================================
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias vim='nvim'
alias vi='nvim'
alias bedrock='aws sso login --profile bedrock'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================
# Vi-mode設定
# ============================================

# vi-modeを有効化
bindkey -v

# Escキーの遅延を短縮（0.01秒）
export KEYTIMEOUT=1

# カーソル形状を変更（モードによって変える）
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'  # ブロックカーソル（ノーマルモード）
  else
    echo -ne '\e[5 q'  # バーカーソル（インサートモード）
  fi
}
function zle-line-init {
  echo -ne '\e[5 q'  # 起動時はインサートモード
}
function zle-line-finish {
  echo -ne '\e[5 q'  # コマンド実行後
}
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

# インサートモードでもEmacs風のキーバインドを併用
bindkey '^A' beginning-of-line      # Ctrl+A: 行頭
bindkey '^E' end-of-line            # Ctrl+E: 行末
bindkey '^K' kill-line              # Ctrl+K: カーソルから行末まで削除
bindkey '^W' backward-kill-word     # Ctrl+W: 単語削除
bindkey '^U' backward-kill-line     # Ctrl+U: カーソルから行頭まで削除
bindkey '^R' history-incremental-search-backward  # Ctrl+R: 履歴検索
bindkey '^S' history-incremental-search-forward   # Ctrl+S: 前方履歴検索
bindkey '^P' up-line-or-history     # Ctrl+P: 前のコマンド
bindkey '^N' down-line-or-history   # Ctrl+N: 次のコマンド

# ノーマルモードでの追加操作
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history

# 現在のモードを右プロンプトに表示（オプション）
# function vi_mode_prompt_info() {
#   echo "${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/[INSERT]}"
# }
# RPROMPT='$(vi_mode_prompt_info)'  # コメント解除で有効化
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/muraseshuji/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
