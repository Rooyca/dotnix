# Author: rooyca
# Updated: 2024-02-08

# --- ZSH CONFIG --- #
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- ALIASES --- #
source $HOME/.aliases

# --- PROMPT --- #
source $HOME/.prompt

# --- CASE INSENSITIVE TAB COMPLETION --- #
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# --- FZF --- #
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# --- ZSH PLUGINS --- #
source "$HOME/.zsh_plug/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh_plug/zsh-autosuggestions/zsh-autosuggestions.zsh"

# --- ZOXIDE --- #
eval "$(zoxide init zsh)"

# --- STARTX --- #
if [[ "$(tty)" = "/dev/tty1" ]]; then
    pgrep dwm || startx
fi

# --- PNPM --- #
export PNPM_HOME="/home/rooyca/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- FLYCTL --- #
export FLYCTL_INSTALL="/home/rooyca/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/rooyca/.bun/_bun" ] && source "/home/rooyca/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
