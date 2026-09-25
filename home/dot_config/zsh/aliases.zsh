# --- Navegación ---
alias ..='cd ..'
alias ...='cd ../..'

# --- Git ---
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'

# --- Docker ---
alias dps='docker ps'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# --- tmux ---
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tn='tmux new -s'

# --- Editor ---
alias v='nvim'

# --- Dotfiles ---
alias dotfiles='cd ~/.local/share/chezmoi'
alias zshreload='source ~/.zshrc'
