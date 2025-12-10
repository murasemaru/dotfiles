# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================
# Oh My Zsh設定
# =========================================
if [ -d "$HOME/.oh-my-zsh" ]; then
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
    zsh-bat
    you-should-use
    copyfile
    copypath
  )

  source $ZSH/oh-my-zsh.sh
fi

# ========================================
# PATH設定
# ========================================
typeset -U path PATH

# ========================================
# dotfiles 設定
# ========================================
export DOTFILES_DIR="$HOME/dotfiles"

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
export EDITOR='nvim'

# Completion system
# ========================================
# Docker CLI completions を読み込む場合は fpath へ追加
if [ -d "$HOME/.docker/completions" ]; then
  fpath=($HOME/.docker/completions $fpath)
fi

autoload -Uz compinit
compinit

# ========================================
# fzf 設定
# ========================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf のデフォルトオプション
export FZF_DEFAULT_OPTS='
  --height 60%
  --reverse
  --border
  --inline-info
  --color=fg:#d0d0d0,bg:#121212,hl:#5f87af
  --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
  --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
  --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
'

# fzf でファイル検索時に bat を使う
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'
  --preview-window=right:60%:wrap
"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ========================================
# モジュール読み込み
# ========================================
# 各機能を分割したファイルを読み込む
for config_file in ~/.zsh/*.zsh(N); do
  source "$config_file"
done

# ========================================
# プライベート設定の読み込み（オプション）
# ========================================
# dotfiles-th (Techouse固有設定) が存在する場合のみ読み込む
if [ -d "$HOME/dotfiles-th/.zsh" ]; then
  for config_file in $HOME/dotfiles-th/.zsh/*.zsh(N); do
    source "$config_file"
  done
fi

. "$HOME/.local/bin/env"
