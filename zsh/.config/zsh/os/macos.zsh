# os/macos.zsh = for MacOS systems

# alias for ls
alias ls='ls -G'
alias ll='ls -lahG'

# native clipboard
alias c='pbcopy'
alias p='pbpaste'
alias o='open .'

# SSH agent with keychain
# one time: ssh-add --apple-use-keychain ~/.ssh/id...
[[ -z "$SSH_AUTH_SOCK" ]] && eval "$(ssh-agent -s)" >/dev/null
ssh-add --apple-load-keychain 2>/dev/null

alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
