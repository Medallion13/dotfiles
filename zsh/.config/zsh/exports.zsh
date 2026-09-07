# Env variables for every system

# editors
export EDITOR='nvim'
export VISUAL='nvim'

# Historial
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS # no duplicates
setopt HIST_FIND_NO_DUPS # Search without repeate the dups
setopt HIST_REDUCE_BLANKS # Clean empty spaces
setopt SHARE_HISTORY # Share history between terminals

# User path (pipx and personal bins)
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"


# plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
export YSU_MESSAGE_POSITION="after"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# less
export LESS='-R -F -X'
