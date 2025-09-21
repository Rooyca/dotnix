{
  pkgs,
  config,
  ron-pkgs,
  dotfiles,
  ...
}:

let
  configs = {
    # helix = "helix";
    mpv = "mpv";
    tiny = "tiny";
    i3blocks = "i3blocks";
    tmux = "tmux";
    beets = "beets";
    dunst = "dunst";
    foot = "foot";
    sway = "sway";
    mpd = "mpd";
    # river = "river";
    # waybar = "waybar";
    # i3blocks = "i3blocks";
    # bspwm = "bspwm";
    # sxhkd = "sxhkd";
    # dunst = "dunst";
    nix = "nix";
    nvim = "nvim";
    git = "git";
    session_ch = "session_ch";
  };
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
      # ron-pkgs.packages.${pkgs.system}.barli
      # ron-pkgs.packages.${pkgs.system}.minipm
      # obsidian
      # nil
      # nixfmt-rfc-style
      # yaml-language-server
      # wget
      # btop
      # pinta
      # ani-cli
      #strawberry
      # pfetch
      bat
      fd
      #lf
      # eza
      # fzf
      # zoxide
      trash-cli
      # ripgrep
      bashmount
      jq
      lua-language-server
      # nb
      #mcomix
      # git-crypt
      papirus-icon-theme
      # speedtest-cli
      #brave

      # Reverse Engineering
      # ida-free
      #python312Packages.angr
      #frida-tools

      # emacs
      # scrot
      # feh
      # xclip
      # xcolor
      # xorg.xprop

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      #spotify

      wl-clipboard
      hyprpicker
      slurp
      nwg-look
      # imv
      i3blocks
      # wmenu

      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    file = {
      #".vimrc".source = ./.vimrc;
      # ".config/stalonetrayrc".source = ./config/stalonetrayrc;
      # ".config/redshift/redshift".source = ./config/redshift/redshift.conf;
      #".xbindkeysrc".source = ./.xbindkeysrc;
      #".conkyrc".source = ./config/conky/conkyrc;
      # ".xinitrc".source = ./xorg/.xinitrc;
      # ".xprofile".source = ./xorg/.xprofile;
      ".profile".source = ./xorg/.profile;
      # ".Xresources".source = ./xorg/.Xresources;

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
