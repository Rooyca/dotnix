{ config, pkgs, ... }:

{
  # nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["openssl-1.1.1w"];
  };

  home.username = "ryc";
  home.homeDirectory = "/home/ryc";

  home.stateVersion = "24.05"; # Please dont change if you are not sure what you are doing

  home.packages = with pkgs; [
    obsidian
    wget
    btop
    #strawberry
    nerdfetch
    pfetch
    audacious
    sublime4
    bat
    fd
    eza
    fzf
    zoxide
    trash-cli
    ripgrep
    bashmount
    jq
    #nb

    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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
    ".config/picom/picom.conf".source = ./config/picom/picom.conf;
    ".config/nix/nix.conf".source = ./config/nix/nix.conf;
    ".config/mpv/mpv.conf".source = ./config/mpv/mpv.conf;

    ".config/lf" = {
      source = ./config/lf;
      recursive = true;
    };

    ".config/fish" = {
      source = ./config/fish;
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

    ".config/zellij" = {
      source = ./config/zellij;
      recursive = true;
    };
  };

  home.sessionVariables = {
    #EDITOR = "vim";
  };

  programs.git = {
      enable = true;
      userName = "rooyca";
      userEmail = "rooyca@gmail.com";
      ignores = [ 
        ".env"
        "__pycache__"
        "id_rsa"
        "id_rsa_*"
        "id_dsa"
        "id_dsa_*"
        "id_ed25519"
        "id_ed25519_*"
        "*.key"
        "*.pem"
        "*.pk"
        "*.ppk"
      ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
