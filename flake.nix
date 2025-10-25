{
  description = "ryc's NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      stateVersion = "25.05";
      hostname = "doom";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      homeDirPrefix = "/home";
      homeDirectory = "${homeDirPrefix}/${username}";
    in {
      # NixOS system configuration
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          
          # Integrate Home Manager as a NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./homeX.nix;
            
            # Pass extra arguments to Home Manager modules
            home-manager.extraSpecialArgs = {
              inherit ron-pkgs;
              dotfiles = "${homeDirectory}/Documents/dotnix/config";
            };
          }
        ];
      };
    };
}
