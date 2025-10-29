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
    tiny = "tiny";
    tmux = "tmux";
  };

  githubPkgs = import ./gh-pkgs.nix { inherit pkgs; };
  packages = import ./modules/packages.nix { inherit pkgs; };
in

{
  imports = [
    ./modules/fish.nix
    ./modules/dunst.nix
    ./modules/nvim.nix
    ./config/bin/config.nix
  ];

  home.username = "ryc";
  home.homeDirectory = "/home/ryc";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  # services.udiskie = {
  #     enable = true;
  #     settings = {
  #         program_options = {
  #             file_manager = "${pkgs.pcmanfm}/bin/pcmanfm";
  #         };
  #     };
  # };

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
  };

  dconf.enable = false;

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "breeze"; 
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["pcmanfm.desktop"]; # Directories
        };
      };
    };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home = {
    packages = packages ++ [
      # == Github Packages ==
      githubPkgs.bin-bin
      githubPkgs.st-flexipatch
      githubPkgs.dwm-flexipatch
      githubPkgs.raccoon-scanner
      # == ron-pkgs repo ==
      ron-pkgs.packages.${pkgs.system}.barli.default
      ron-pkgs.packages.${pkgs.system}.minipm
    ];

    file = {
      ".config/redshift/redshift".source = ./config/redshift/redshift.conf;
      ".config/barli.conf".source = ./config/barli.conf;

      ".scripts" = {
        source = config.lib.file.mkOutOfStoreSymlink ./scripts;
        recursive = true;
      };
    };
    sessionVariables = {
      EDITOR = "nvim";
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
