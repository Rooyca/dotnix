{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "doom";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bogota";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  }; 

  services.xserver = {
    enable = true;
    displayManager = { 
      sessionCommands = "barli &";
      lightdm = {
        enable = true;
        background = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/w8/wallhaven-w8j16x.jpg";
        sha256 = "sha256-uhhmKKlCUooFgpxq8tSmxWtqTVYCtDZZKmXH+oUEDwg=";
        };
      };
    };
    xkb.layout = "es";
    windowManager.dwm.enable = true;
  };

  users.users.ryc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "network" ];
    shell = pkgs.fish;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
  ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFirefoxScreenshots = true;
      DisplayBookmarksToolbar = "never";
      SearchBar = "unified";
      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2;
        "cookiebanners.service.mode" = 2; 
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/video-downloadhelper/latest.xpi";
          installation_mode = "force_installed";
        };
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
  environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";

  programs.fish.enable = true;
  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    nodejs
    python314 # I know
    vim
    neovim
    udiskie
    git
    github-cli
    unzip
    libnotify
    pavucontrol
    cargo
    man-pages
    man-pages-posix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    terminus_font
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

}
