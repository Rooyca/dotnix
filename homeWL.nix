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
    foot = "foot";
    river = "river";
    mako = "mako";
    git = "git";
    mpv = "mpv";
    nix = "nix";
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
      nil
      lua-language-server

      gdb
      gef
      radare2
      binaryninja-free

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      
      wl-clipboard
      hyprpicker
      slurp
      nwg-look
      wlsunset
      # gammastep

      tmux
      ddgr
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
      trash-cli
      duf
      dufs
    ];

    file = {
      ".profile".source = ./xorg/.profile;
      ".vimrc".source = ./.vimrc;

      ".scripts" = {
        source = config.lib.file.mkOutOfStoreSymlink ./scripts;
        recursive = true;
      };
    };
  };
}

