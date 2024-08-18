{ homeDirectory
, stateVersion
, pkgs
, system
, username
, secrets }:

{
  imports = [
    ./modules/fish.nix
    ./modules/zellij.nix
  ];

  fonts.fontconfig.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    inherit homeDirectory username stateVersion;

    packages = with pkgs; [
      obsidian
      wget
      btop
      #strawberry
      #nerdfetch
      neofetch
      #pfetch
      #audacious
      #sublime4
      bat
      fd
      eza
      fzf
      zoxide
      trash-cli
      ripgrep
      bashmount
      jq
      lua-language-server
      nb
      git-crypt

      scrot
      feh
      xclip
      xcolor
      xorg.xprop

      (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })

      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
    file = {
      ".mpdasrc".text = ''
          username = ${secrets.lastfm.user}
          password = ${secrets.lastfm.pass}
          runas = ${username}
          debug = 1
      '';

      ".vimrc".source = ./.vimrc;
      #".xbindkeysrc".source = ./.xbindkeysrc;
      #".conkyrc".source = ./conkyrc;
      ".xinitrc".source = ./xorg/.xinitrc;
      ".xprofile".source = ./xorg/.xprofile;
      ".profile".source = ./xorg/.profile;
      ".Xresources".source = ./xorg/.Xresources;
      ".radios.ry".source = ./config/radio_aliases/.radios.ry;

      ## BSPWM
      ".config/bspwm/bspwmrc".source = ./config/bspwm/bspwmrc;
      ".config/sxhkd/sxhkdrc".source = ./config/sxhkd/sxhkdrc;
      ".config/rofi/dracula.rasi".source = ./config/rofi/dracula.rasi;
      ".config/thonkbar" = {
        source = ./config/thonkbar;
        recursive = true;
      };
      #".config/polybar" = {
      #  source = ./config/polybar;
      #  recursive = true;
      #};

      ## Scripts
      ".scripts" = {
        source = ./scripts;
        recursive = true;
      };

      ## Config files
      ".config/dunst".source = ./config/dunst;
      #".config/mpd".source = ./config/mpd;
      ".config/nix/nix.conf".source = ./config/nix/nix.conf;
      ".config/mpv/mpv.conf".source = ./config/mpv/mpv.conf;

      ".config/lf" = {
        source = ./config/lf;
        recursive = true;
      };

      ".config/mpv/scripts" = {
        source = ./config/mpv/scripts;
        recursive = true;
      };

      ".config/nvim" = {
        source = ./config/nvim;
        recursive = true;
      };

      ".config/sublime-text/Packages/User" = {
        source = ./config/sublime-text/Packages/User;
        recursive = true;
      };

      ".config/git" = {
        source = ./config/git;
        recursive = true;
      };

      ".config/" = {
        source = ./config/konversation;
        recursive = true;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
      #PATH = "$PATH /usr/local/bin /opt/bin $HOME/.scripts $HOME/.local/bin $HOME/.cargo/bin";
    };
  };
}
