{
  pkgs,
  config,
  ron-pkgs,
  dotfiles,
  ...
}:

let
  configs = {
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
    ./modules/dunst.nix
    ./config/bin/config.nix
  ];

  home.username = "ryc";
  home.homeDirectory = "/home/ryc";
  home.stateVersion = "25.05";
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
      lua-language-server

      gef
      radare2
      binaryninja-free
      ida-free

      xclip
      xcolor

      tmux
      tiny
      feh
      ddgr
      dmenu
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
      brightnessctl
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
