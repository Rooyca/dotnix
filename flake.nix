{
  description = "ryc's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    ron-pkgs = { 
      url = "github:rooyca/ron-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ron-pkgs }:
    let
      username = "ryc";
      system = "x86_64-linux";
      stateVersion = "24.05";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # permittedInsecurePackages = [ "openssl-1.1.1w" ];
        };
      };

      homeDirPrefix = "/home";
      homeDirectory = "${homeDirPrefix}/${username}";
      # secrets = builtins.fromJSON (builtins.readFile "${toString ./scrts/general.json}");
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ config, ... }: {
            # Pass custom arguments using _module.args
            _module.args = {
              inherit ron-pkgs; # secrets ?
              dotfiles = "${homeDirectory}/Documents/dotnix/config";
            };

            home.username = username;
            home.homeDirectory = homeDirectory;
            home.stateVersion = stateVersion;
          })
          # ./homeWL.nix 
          ./homeX.nix
        ];
      };
    };
}
