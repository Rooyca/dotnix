{
  pkgs,
  config,
  ron-pkgs,
  dotfiles,
  ...
}:

let
  configs = {
    bspwm = "bspwm";
    dunst = "dunst";
    fastfetch = "fastfetch";
    git = "git";
    mpv = "mpv";
    nix = "nix";
    nvim = "nvim";
    session_ch = "session_ch";
    sxhkd = "sxhkd";
    tiny = "tiny";
    tmux = "tmux";
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
    "gtk-3.0" = "gtk-3.0";

  };

  githubPkgs = import ./gh-pkgs.nix { inherit pkgs; };
in

{
  imports = [
    ./modules/fish.nix
    ./config/bin/config.nix
  ];

  fonts.fontconfig.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home = {
    packages = with pkgs; [
      # == Github Packages ==
      githubPkgs.bin-bin
      githubPkgs.st-flexipatch
      githubPkgs.dwm-flexipatch
      # == ron-pkgs repo ==
      ron-pkgs.packages.${pkgs.system}.barli.musl
      ron-pkgs.packages.${pkgs.system}.minipm
      nil
      # nixfmt-rfc-style
      # yaml-language-server
      lua-language-server

      # python312Packages.angr
      # frida-tools
      gdb
      radare2

      xclip
      xorg.xrandr
      xcolor
      xorg.xprop

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      tmux
      trayer
      cbatticon
      feh
      ddgr
      scrot
      obsidian
      zoxide
      github-cli
      eza
      yazi
      fzf
      jq
      ripgrep
      fd
      dmenu
      btop
      fastfetch
      wget
      bat
      pinta
      trash-cli
      redshift
      duf
      dufs
    ];

    file = {
      ".config/redshift/redshift".source = ./config/redshift/redshift.conf;
      ".config/barli.conf".source = ./config/barli.conf;
      ".xprofile".source = ./xorg/.xprofile;
      ".profile".source = ./xorg/.profile;

      ".scripts" = {
        source = config.lib.file.mkOutOfStoreSymlink ./scripts;
        recursive = true;
      };

      ".xinit" = {
        source = config.lib.file.mkOutOfStoreSymlink ./xorg/xinitrc;
        recursive = true;
      };

      ".xinitrc".text = ''
        #!/usr/bin/env bash

        XORG_DIR="$HOME/.xinit"

        if [ "$SESSION" = "x11" ]; then
          case "$USE_THIS_WM" in
            dwm)   source "$XORG_DIR/.xinitrc.dwm" ;;
            bspwm) source "$XORG_DIR/.xinitrc.bspwm" ;;
            *)     echo "[-] Unknown WM: $USE_THIS_WM" >&2; exit 1 ;;
          esac
        else
          echo "[-] Your variable SESSION=$SESSION is not x11" >&2
          exit 1
        fi
      '';
      ".xinitrc".executable = true;
    };
  };
}

