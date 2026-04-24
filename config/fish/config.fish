set -g fish_greeting

set -x PATH $PATH /usr/local/bin $HOME/go/bin /opt/bin $HOME/.scripts $HOME/.local/bin $HOME/.cargo/bin $HOME/.local/share/flatpak/exports/bin
set -x XDG_CONFIG_HOME "$HOME/.config"

# For Ghidra to work
set -x _JAVA_AWT_WM_NONREPARENTING 1

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

# set editor
set -x EDITOR nvim

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
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gl='git log'
alias gr='git remote'

# LS replace
alias ls="exa -a --icons --group-directories-first"
alias l="exa -la --icons --group-directories-first"

# vim
alias vim="nvim"

# Tmux
alias ta="tmux attach-session"
alias tn="tmux new-session"
alias tl="tmux list-sessions"

# Editor
alias e="$EDITOR"

# GitHub Copilot CLI
alias sug="gh copilot suggest"
alias exp="gh copilot explain"

# rust
source "$HOME/.cargo/env.fish"

zoxide init fish | source
