{
  pkgs,
  config,
  ron-pkgs,
  dotfiles,
  ...
}:

let
  configs = {
    dunst = "dunst";
    fastfetch = "fastfetch";
    git = "git";
    mpv = "mpv";
    nvim = "nvim";
    session_ch = "session_ch";
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

  # Add these Home Manager specific settings
  home.username = "ryc";
  home.homeDirectory = "/home/ryc";
  home.stateVersion = "25.05";

  fonts.fontconfig.enable = true;
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
      ron-pkgs.packages.${pkgs.system}.barli.default
      ron-pkgs.packages.${pkgs.system}.minipm
      nil
      lua-language-server

      gdb
      radare2
      binaryninja-free

      xclip
      xcolor

      tmux
      tiny
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
    };
  };
}
