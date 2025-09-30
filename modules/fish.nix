{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellInit = ''
      if test -f ~/.config/session_ch/session.fish
        source ~/.config/session_ch/session.fish
      end

      set -g fish_greeting
      fish_prompt
      set -x PATH $PATH /usr/local/bin $HOME/go/bin /opt/bin $HOME/.scripts $HOME/.cargo/bin /sbin /usr/bin /usr/sbin /bin $HOME/.local/bin
      set -x XDG_CONFIG_HOME "$HOME/.config"
      set -x EDITOR "nvim"
      source ~/.dzr

      # PNPM
      export PNPM_HOME="$HOME/.local/share/pnpm"
      set -gx PATH $PNPM_HOME $PATH

      # Radio Aliases
      # eval "$(radioalias.py)"

      # For Ghidra to work
      set -x _JAVA_AWT_WM_NONREPARENTING 1
    '';

    shellInitLast = ''
      zoxide init fish | source
    '';

    shellAliases = {
      "ls" = "exa -a --icons --group-directories-first";
      "ll" = "exa -la --icons --group-directories-first";
      "nfu" = "cd ~/Documents/dotnix && nix flake update";
      "hmsf" = "home-manager switch --flake ~/Documents/dotnix#$USER";
      "hme" = "nvim ~/Documents/dotnix/home.nix";
      "gdb" = "gdb -q";
    };

    shellAbbrs = {
      # git abbreviations
      g = "git";
      gaa = "git add -A";
      ga = "git add";
      gbd = "git branch --delete";
      gb = "git branch";
      gc = "git commit";
      gcm = "git commit -m";
      gcob = "git checkout -b";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
      gpom = "git push origin main";
      gs = "git status";
      gst = "git stash";
      gstp = "git stash pop";

      # nix abbreviations
      ncg = "nix-collect-garbage";
      hm = "home-manager";

      # tmux
      ta = "tmux attach-session";
      tn = "tmux new-session";

      # others
      c = "clear";
      e = "$EDITOR";
      t = "btop";
      up = "xi -Syu";
      v = "nvim";
      hx = "nvim";
      mt = "mpc toggle";
      mc = "mpc clear";
      ma = "mpc add";
    };

    functions = {
     fish_prompt = ''
          function fish_prompt
            set_color --bold 4086ef     # path
            echo -n (basename (pwd))

            # Git branch (if inside repo)
            if git rev-parse --is-inside-work-tree >/dev/null 2>&1
                echo -n " "
                echo -n (set_color --bold 4338ca)"("   # purple parens
                set_color f0abfc
                echo -n (git branch --show-current)

                if not git diff --quiet --ignore-submodules HEAD 2>/dev/null
                    echo -n (set_color --bold ff0000)"•"  # red dot if dirty
                end

                echo -n (set_color --bold 4338ca)")"   # close parens
            end

            echo -n (set_color --bold 14b8a6)" → "     
            set_color normal
        end
      '';

      timer = ''
        function timer
            if test (count $argv) -lt 2
                echo "Usage: timer <seconds> <message>"
                return 1
            end

            set seconds $argv[1]
            set message (string join ' ' $argv[2..-1])

            echo "Timer set for $seconds seconds..."
            sleep $seconds
            notify-send "$message"
        end
      '';
    };

    plugins = [
      {
        name = "fisher";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "fisher";
          rev = "2efd33ccd0777ece3f58895a093f32932bd377b6";
          sha256 = "sha256-e8gIaVbuUzTwKtuMPNXBT5STeddYqQegduWBtURLT3M=";
        };
      }

      {
        name = "done";
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
          sha256 = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
        };
      }

      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "patrickf1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }

      {
        name = "loadenv.fish";
        src = pkgs.fetchFromGitHub {
          owner = "berk-karaal";
          repo = "loadenv.fish";
          rev = "e5ad1b3e8cf779bd897a5fa4c0dc55a920b01ed7";
          sha256 = "sha256-RyGjJ8NxTqEr9MW7hnrTlry6fW+IF4el1IPUh7WIwxU=";
        };
      }

      {
        name = "nix.fish";
        src = pkgs.fetchFromGitHub {
          owner = "kidonng";
          repo = "nix.fish";
          rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
          sha256 = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
        };
      }
    ];
  };
}
