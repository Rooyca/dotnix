# --- REMIND --- #
export REMINDER_DIR="$HOME/.reminders"

# --- EDITOR --- # 
export EDITOR="nvim"
export VISUAL="nvim"

# --- ZSH VARIABLES ---#
export HISTSIZE=10000
export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTDUP=erase
export HIST_IGNORE="ls:cd:cd -:pwd:exit:clear:echo:z:zm"

# --- FZF --- #
## SIMPLER FZF CONFIG
# export FZF_DEFAULT_COMMAND="fd --hidden"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

## COMPLETE FZF CONFIG
# export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# FZF_COLORS="bg+:-1,\
# fg:gray,\
# fg+:white,\
# border:black,\
# spinner:0,\
# hl:yellow,\
# header:blue,\
# info:green,\
# pointer:red,\
# marker:blue,\
# prompt:gray,\
# hl+:red"

# export FZF_DEFAULT_OPTS="--height 60% \
# --border sharp \
# --layout reverse \
# --color '$FZF_COLORS' \
# --prompt '∷ ' \
# --pointer ▶ \
# --marker ⇒"
# export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
# export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"

# --- LOCAL PATH --- #
export PATH="$HOME/.local/bin:$PATH"

# --- GOPATH --- #
export PATH=$PATH:"$HOME/go/bin"

# --- RUST --- #
. "$HOME/.cargo/env"

# --- NB --- #
export NB_AUTO_SYNC="0"
