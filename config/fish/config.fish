#if status is-interactive
#    set --export ZELLIJ_AUTO_ATTACH true
#    eval (zellij setup --generate-auto-start fish | string collect)
#end

# remove greeting
set -g fish_greeting

# indicator for vi
function fish_mode_prompt
  switch "$fish_bind_mode"
    case "default"
      echo -n (set_color --bold f43f5e)"N"
    case "insert"
      echo -n (set_color --bold 84cc16)"I"
    case "visual"
      echo -n (set_color --bold 8b5cf6)"V"
    case "*"
      echo -n (set_color --bold)"?"
   end

  echo -n " "
end

# custom prompt
function fish_prompt
  set_color --bold 4086ef

  set transformed_pwd (prompt_pwd | string replace -r "^~" (set_color --bold 06b6d4)"~"(set_color --bold 3b82f6))

  echo -n $transformed_pwd

  # git branch  
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1
    #space
    echo -n " "

    echo -n (set_color --bold 4338ca)"("

    set_color f0abfc
    echo -n (git branch --show-current)

    echo -n (set_color --bold 4338ca)")"
    set_color normal
  end

  # space
  echo -n " "

  # arrows
  # echo -n (set_color --bold efcf40)"❱"
  # echo -n (set_color --bold ef9540)"❱"
  # echo -n (set_color --bold ea3838)"❱"
  
  echo -n (set_color --bold 14b8a6)"→"
  
  #space
  echo -n " "

  set_color normal
end

# set environment variables
set -x PATH $PATH /usr/local/bin /opt/bin $HOME/.scripts $HOME/.local/bin $HOME/.cargo/bin

# set editor
set -x EDITOR "nvim"

# TokyoNight Color Palette from https://github.com/folke/tokyonight.nvim/blob/main/extras/fish/tokyonight_storm.fish
set -l foreground c0caf5
# changed from default
set -l selection 6366f1
# changed from default
set -l comment 737373
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

# bun
#set --export BUN_INSTALL "$HOME/.bun"
#set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
#set -gx PNPM_HOME "/home/mh/.local/share/pnpm"
#if not string match -q -- $PNPM_HOME $PATH
#  set -gx PATH "$PNPM_HOME" $PATH
#end

# --- ALIAS --- #
# Git
alias g="git"
alias gs="git status"
alias ga='git add'
alias gp='git push'
alias gpo='git push origin'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias gr='git branch -r'
alias gplo='git pull origin'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout '
alias gl='git log'
alias gr='git remote'
alias grs='git remote show'
alias glo='git log --pretty="oneline"'
alias glol='git log --graph --oneline --decorate'

# Remind
## Remind - Frontend
#alias sc="remindcal $REMINDER_DIR/primary.rem"
## Add Reminder
#alias er="$HOME/.scripts/add_rem.sh $REMINDER_DIR"
## Show monthly reminds
#alias mr="remind -s $REMINDER_DIR/primary.rem"
## Add reminder with notify
alias nr="python $HOME/.scripts/remind.py"

# Updater
#alias up="sudo pacman -Syu && sudo pacman -Sc"

# LS replace
alias ls="exa -a --icons --group-directories-first"
alias ll="exa -la --icons --group-directories-first"

# disk
alias disk="duf"

# ping
#alias pin="gping google.com"

# ip color
alias ip="ip --color=auto"

# Network traffic
#alias red="sudo iftop -i wlan0"

# Zellij
alias zm="zellij attach main"
alias zl="zellij ls"
alias zks="zellij kill-session"
alias zka="zellij kill-all-sessions"
alias zdn="zellij delete-session"
alias zda="zellij delete-all-sessions"

# Editor
alias e="$EDITOR"

# GitHub Copilot CLI
alias sug="gh copilot suggest"
alias exp="gh copilot explain"

# NB
#alias nb="python $HOME/share/Python/notes/save_notes_to_nb.py; nb"
alias nbtags="python $HOME/.scripts/nb_show_all_tags.py"

# DEEMIX
alias deemix="$HOME/Documents/deemix-linux-x64-latest.AppImage"

# SONIXD
alias sonixd="$HOME/Documents/Sonixd-0.15.5-linux-x86_64.AppImage"

# ARBTT-STATS
#alias xt="arbtt-stats" 

# Subl (voidlinux)
#alias subl="subl4"

# Obsidian
#alias obsidian="$HOME/Downloads/Obsidian-1.6.5.AppImage"

# Start X at login
#if status is-login
#    if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
#        exec sway
#    end
#end

# NIXPKGS
alias nfu="cd ~/Documents/dotfiles/HOME/.config/home-manager && nix flake update && cd -"
alias hm="home-manager"
alias hmsf="home-manager switch --flake ~/Documents/dotfiles/HOME/.config/home-manager#$USER"
alias hme="nvim ~/Documents/dotfiles/HOME/.config/home-manager/home.nix"

zoxide init fish | source
