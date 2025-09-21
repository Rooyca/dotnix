#if status is-interactive
#    set --export ZELLIJ_AUTO_ATTACH true
#    eval (zellij setup --generate-auto-start fish | string collect)
#end

fish_prompt

# Start X at login
#if status is-login
#  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#    export QT_QPA_PLATFORMTHEME="qt6ct"
#    #exec startx /usr/bin/bspwm -- -keeptty
#    exec startx -- -keeptty
#  end
#end

set -e fish_key_bindings
set -g fish_greeting

set -x PATH $PATH /usr/local/bin $HOME/go/bin /opt/bin $HOME/.scripts $HOME/.local/bin $HOME/.cargo/bin $HOME/.local/share/flatpak/exports/bin

set -x XDG_CONFIG_HOME "$HOME/.config"

# For Ghidra to work
set -x _JAVA_AWT_WM_NONREPARENTING 1

# Music Player
#set -Ux MUSIC_PLAYER cantata

# Prompt
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

        # Check if the repository is dirty
        if not git diff --quiet --ignore-submodules HEAD 2>/dev/null
            echo -n (set_color --bold ff0000)"•"
        end

        echo -n (set_color --bold 4338ca)")"
        set_color normal
    end

    echo -n " "
    echo -n (set_color --bold 14b8a6)"→"
    echo -n " "

    set_color normal
end

# Remove paths
function fish_rm_path --argument path
    set path (path resolve $path)
    set path_index (contains -i $path $fish_user_paths)
    if test $status -ne 0
        echo $path not in fish_user_paths
        return 1
    end
    echo Removing $path at index $path_index from fish_user_paths
    set -e fish_user_paths[$path_index]
end

# set editor
set -x EDITOR hx

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

# --- ABB --- #
abbr -a c clear
abbr -a t btop
abbr -a v nvim

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

# Alpine
alias add="doas apk add"
alias del="doas apk del"

# Clipboard
#alias copy="xclip -selection clipboard"
# Remind
## Remind - Frontend
#alias sc="remindcal $REMINDER_DIR/primary.rem"
## Add Reminder
#alias er="$HOME/.scripts/add_rem.sh $REMINDER_DIR"
## Show monthly reminds
#alias mr="remind -s $REMINDER_DIR/primary.rem"
## Add reminder with notify
#alias nr="python $HOME/.scripts/remind.py"

# Updater
#alias up="sudo pacman -Syu && sudo pacman -Sc"

# LS replace
alias ls="exa -a --icons --group-directories-first"
alias ll="exa -la --icons --group-directories-first"

# ping
#alias pin="gping google.com"

# ip color
#alias ip="ip --color=auto"

# vim
alias vim="nvim"

# Network traffic
#alias red="sudo iftop -i wlan0"

# Zellij
#alias zm="zellij attach main"
#alias zl="zellij ls"
#alias zks="zellij kill-session"
#alias zka="zellij kill-all-sessions"
#alias zdn="zellij delete-session"
#alias zda="zellij delete-all-sessions"

# Tmux
alias ta="tmux attach-session"
alias tn="tmux new-session"
alias tl="tmux list-sessions"

# Editor
alias e="$EDITOR"

# GitHub Copilot CLI
alias sug="gh copilot suggest"
alias exp="gh copilot explain"

# NB
#alias nb="python $HOME/share/Python/notes/save_notes_to_nb.py; nb"
#alias nbtags="python $HOME/.scripts/nb_show_all_tags.py"

# DEEMIX
#alias deemix="$HOME/Documents/deemix-linux-x64-latest.AppImage"

# SONIXD
#alias sonixd="$HOME/Documents/Sonixd-0.15.5-linux-x86_64.AppImage"

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
#alias nfu="cd ~/Documents/dotnix && nix flake update && cd -"
#alias hm="home-manager"
#alias hmsf="home-manager switch --flake ~/Documents/dotnix#$USER"
#alias hme="nvim ~/Documents/dotnix/home.nix"

zoxide init fish | source

#fish_rm_path $HOME/.opencode/bin
#fish_rm_path $HOME/.dotnet/tools
