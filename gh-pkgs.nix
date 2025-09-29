{ pkgs }:

# nix store prefetch-file --hash-type <link> 
# nix-prefetch-git <link>
{
  # marcosnils/bin 
  bin-bin = pkgs.stdenv.mkDerivation {
    pname = "bin";
    version = "0.16.0";

    src = pkgs.fetchurl {
      url = "https://github.com/marcosnils/bin/releases/download/v0.23.1/bin_0.23.1_linux_amd64";
      sha256 = "sha256-PaZlyzDhKdSB7nm4fgG3Z0zs37IwFxEWrJhVaU0JS+w=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      install -m755 $src $out/bin/bin
    '';
  };

  st-flexipatch = pkgs.stdenv.mkDerivation rec {
    pname = "st-flexipatch";
    version = "git-2025-09-29"; 

    src = pkgs.fetchFromGitHub {
      owner = "rooyca"; 
      repo = "st-flexipatch";
      rev = "master"; 
      sha256 = "sha256-E7Fa28GaTU1fvzdDG1Vi9anIzlUb9u/CNjjku/ih4Rk="; 
    };

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.xorg.libX11 pkgs.xorg.libXft pkgs.imlib2 ];

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 st $out/bin/st
    '';
  };
}

