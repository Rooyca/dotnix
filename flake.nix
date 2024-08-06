{
  description = "Home Manager configuration of ryc";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."ryc" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ 
        ./homeX.nix   # Xorg conf
        #./homeWL.nix # Wayland conf
        ];
      };
    };
}
