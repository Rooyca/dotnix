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

  services.xserver = {
    enable = true;
    displayManager = { 
      sessionCommands = "barli &";
    };
    xkb.layout = "es";
    windowManager.dwm.enable = true;
  };

  users.users.ryc = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    vim
    neovim
    dunst
    git
    github-cli
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
