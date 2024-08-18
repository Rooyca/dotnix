{
  description = "ryc's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      username = "ryc"; # $USER
      system = "x86_64-linux";
      stateVersion = "24.05";

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
          #permittedInsecurePackages = [ "openssl-1.1.1w" ]; # for Sublime-Text4
        };
      };

      homeDirPrefix = "/home";
      homeDirectory = "/${homeDirPrefix}/${username}";
      secrets = builtins.fromJSON (builtins.readFile "${toString ./scrts/general.json}");

      home = (import ./homeX.nix {
        inherit homeDirectory stateVersion pkgs system username secrets;
      });
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          home
        ];
      };
    };
}