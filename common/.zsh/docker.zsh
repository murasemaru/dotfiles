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
