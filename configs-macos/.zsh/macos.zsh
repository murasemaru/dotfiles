# ========================================
# macOS専用設定
# ========================================

# Homebrew PATH
if [ -d "/opt/homebrew/bin" ]; then
  path=(/opt/homebrew/bin $path)
fi

# nodebrew (Node.js version management)
if [ -d "$HOME/.nodebrew/current/bin" ]; then
  path=($HOME/.nodebrew/current/bin $path)
fi

# iTerm2 Integration
if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Docker CLI completions (Docker Desktop)
if [ -d "$HOME/.docker/completions" ]; then
  fpath=($HOME/.docker/completions $fpath)
fi
