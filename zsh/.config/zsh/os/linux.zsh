# os/linux.zsh - for native linux systems

alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

command -v xclip >/dev/null && alias c="xclip -selection clipboard"
alias o='xdg-open .'

if [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add 2>/dev/null
fi
