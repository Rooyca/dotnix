{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellInit = ''
      # Start X at login
      if status is-login
          if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
              export QT_QPA_PLATFORMTHEME="qt6ct"
              #exec startx /usr/bin/bspwm -- -keeptty
              exec startx -- -keeptty
          end
      end

      set -g fish_greeting
      fish_prompt
      set -x PATH $PATH /usr/local/bin /opt/bin $HOME/.scripts $HOME/.local/bin $HOME/.cargo/bin
      set -x XDG_CONFIG_HOME "$HOME/.config"
      
      # Radio Aliases
      eval "$(radioalias.py)"
      
      # For Ghidra to work
      set -x _JAVA_AWT_WM_NONREPARENTING 1
    '';

    shellInitLast = ''
      zoxide init fish | source
    '';

    shellAliases = {
      "ip" = "ip --color=auto";
      "nr" = "python $HOME/.scripts/remind.py";
      "ls" = "exa -a --icons --group-directories-first";
      "ll" = "exa -la --icons --group-directories-first";
      "nbtags" = "python $HOME/.scripts/nb_show_all_tags.py";
      "deemix" = "$HOME/Documents/deemix-linux-x64-latest.AppImage";
      "nfu" = "cd ~/Documents/dotnix && nix flake update && cd -";
      "hmsf" = "home-manager switch --flake ~/Documents/dotnix#$USER";
      "hme" ="nvim ~/Documents/dotnix/home.nix";
      "subl" = "subl4"; # Sublime-text4 (on Voidlinux)
      "gdb" = "gdb -q";
    };

    shellAbbrs = {
      # git abbreviations
      gaa  = "git add -A";
      ga   = "git add";
      gbd  = "git branch --delete";
      gb   = "git branch";
      gc   = "git commit";
      gcm  = "git commit -m";
      gcob = "git checkout -b";
      gco  = "git checkout";
      gd   = "git diff";
      gl   = "git log";
      gp   = "git push";
      gpom = "git push origin main";
      gs   = "git status";
      gst  = "git stash";
      gstp =  "git stash pop";

      # gh
      sug = "gh copilot suggest";
      exp = "gh copilot explain";

      # nix abbreviations
      ncg = "nix-collect-garbage";
      hm = "home-manager";

      # others
      c = "clear";
      e = "$EDITOR";
      t = "btop";
    };

    functions = {
      fish_prompt = ''
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