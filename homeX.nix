{ config, pkgs, ... }:

{
  imports = [
    ./modules/fish.nix
    ./modules/zellij.nix
  ];

  # nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "openssl-1.1.1w" ]; # for Sublime-Text4
  };

  home.username = "ryc";
  home.homeDirectory = "/home/ryc";

  home.stateVersion = "24.05"; # Please dont change this if you are not sure what you are doing

  home.packages = with pkgs; [
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

  fonts.fontconfig.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
  home.file = {
    ".vimrc".source = ./.vimrc;
    ".xbindkeysrc".source = ./.xbindkeysrc;
    ".xinitrc".source = ./.xinitrc;
    ".xprofile".source = ./.xprofile;
    ".Xresources".source = ./.Xresources;

    ## Scripts
    ".scripts" = {
      source = ./scripts;
      recursive = true;
    };

    ## Config files
    ".config/dunst".source = ./config/dunst;
    #".config/mpd".source = ./config/mpd;
    #".config/picom/picom.conf".source = ./config/picom/picom.conf;
    ".config/nix/nix.conf".source = ./config/nix/nix.conf;
    ".config/mpv/mpv.conf".source = ./config/mpv/mpv.conf;

    ".config/lf" = {
      source = ./config/lf;
      recursive = true;
    };

    #".config/fish" = {
    #  source = ./config/fish;
    #  recursive = true;
    #};

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

    #".config/zellij" = {
    #  source = ./config/zellij;
    #  recursive = true;
    #};

    ".config/git" = {
      source = ./config/git;
      recursive = true;
    };

    ".config/" = {
      source = ./config/konversation;
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = "$PATH /usr/local/bin /opt/bin $HOME/.scripts $HOME/.local/bin $HOME/.cargo/bin";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
