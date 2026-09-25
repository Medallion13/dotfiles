# os/wsl.zsh - specific for WSL

alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

# Open URLs in windows
command -v wslview >/dev/null && export BROWSER=wslview

# Windows alias
alias c='clip.exe'
alias o='explorer.exe .'

# SSH agent
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add ~/.ssh/id_rsa 2>/dev/null
fi
