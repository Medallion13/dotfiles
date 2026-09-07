# .zshrc - base multiplatform configuration
# Uses GNU Stow. Personal and secrets go to ~/.zshrc.local

# 1. SO detection

case "$OSTYPE" in
    darwin*) export DOTFILES_OS="macos" ;;
  linux*)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      export DOTFILES_OS="wsl"
    else
      export DOTFILES_OS="linux"
    fi
    ;;
  *) export DOTFILES_OS="unknown" ;;
esac

# Homebrew
if [[ "$DOTFILES_OS" == "macos" ]]; then
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
  [[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"         # Intel
else
  [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Oh my Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="typewritten"

export TYPEWRITTEN_PROMPT_LAYOUT="singleline"
export TYPEWRITTEN_RELATIVE_PATH="adaptive"
export TYPEWRITTEN_COLOR_MAPPINGS="primary:cyan"

fpath+=${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions

# tmux autostart
if [[ "$TERM_PROGRAM" != "vscode" && -z "$VSCODE_INJECTION" ]]; then
  export ZSH_TMUX_AUTOSTART=false
  export ZSH_TMUX_AUTOCONNECT=true
  export ZSH_TMUX_AUTOQUIT=false
  export ZSH_TMUX_DEFAULT_SESSION_NAME="main"
fi

# plugins
plugins=(
  git
  tmux
  aws
  docker
  zsh-autosuggestions
  you-should-use
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Personal fragments
ZSH_FRAGMENTS="$HOME/.config/zsh"

for fragment in exports aliases functions versions; do
  [[ -f "$ZSH_FRAGMENTS/$fragment.zsh" ]] && source "$ZSH_FRAGMENTS/$fragment.zsh"
done

# Fragmento del SO detectado
[[ -f "$ZSH_FRAGMENTS/os/$DOTFILES_OS.zsh" ]] && source "$ZSH_FRAGMENTS/os/$DOTFILES_OS.zsh"

# Local configuration
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
