{
  pkgs,
  config,
  ron-pkgs,
  dotfiles,
  ...
}:

let
  configs = {
    mpv = "mpv";
    fastfetch = "fastfetch";
    tiny = "tiny";
    tmux = "tmux";
    # zellij = "zellij";
    #beets = "beets";
    #mpd = "mpd";
    bspwm = "bspwm";
    sxhkd = "sxhkd";
    dunst = "dunst";
    nix = "nix";
    git = "git";
    nvim = "nvim";
    session_ch = "session_ch";
  };

  githubPkgs = import ./gh-pkgs.nix { inherit pkgs; };
in

{
  imports = [
    ./modules/fish.nix
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
      # Github Packages
      githubPkgs.bin-bin
      githubPkgs.st-flexipatch
      # ron-pkgs repo
      ron-pkgs.packages.${pkgs.system}.barli
      ron-pkgs.packages.${pkgs.system}.minipm
      # nil
      # nixfmt-rfc-style
      # yaml-language-server
      lua-language-server
      papirus-icon-theme

      # python312Packages.angr
      # frida-tools
      gdb
      radare2

      xclip
      xcolor
      xorg.xprop

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

      tmux
      trayer
      cbatticon
      feh
      ddgr
      udiskie
      scrot
      obsidian
      zoxide
      neovim
      github-cli
      eza
      yazi
      fzf
      jq
      ripgrep
      fd
      cargo
      dmenu
      btop
      fastfetch
      wget
      mpv
      bat
      pinta
      bashmount
      trash-cli
      redshift
      duf
      dufs
    ];

    file = {
      #".vimrc".source = ./.vimrc;
      # ".config/stalonetrayrc".source = ./config/stalonetrayrc;
      ".config/redshift/redshift".source = ./config/redshift/redshift.conf;
      ".config/barli.conf".source = ./config/barli.conf;
      #".xbindkeysrc".source = ./.xbindkeysrc;
      #".conkyrc".source = ./config/conky/conkyrc;
      # ".xinitrc".source = ./xorg/.xinitrc;
      ".xprofile".source = ./xorg/.xprofile;
      ".profile".source = ./xorg/.profile;
      ".Xresources".source = ./xorg/.Xresources;

      # ".config/nvim" = {
      #   source = ./config/nvim_old;
      #   recursive = true;
      # };

      ## Scripts
      ".scripts" = {
        source = ./scripts;
        recursive = true;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
