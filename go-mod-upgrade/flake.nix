{
  description = "Update outdated Go dependencies interactively";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      releaseVersion = "0.9.1";
      releaseBinaries = {
        "x86_64-linux" = {
          fileName = "go-mod-upgrade_${releaseVersion}_Linux_x86_64.tar.gz";
          sha256 = "38b7f36b275fa08bedf0e4c7fb1eaf256fa632a7489abe7c40a1d2b87a688b01";
        };
        "x86_64-darwin" = {
          fileName = "go-mod-upgrade_${releaseVersion}_Darwin_x86_64.tar.gz";
          sha256 = "e1e0294040cfadde0f119590f37fbff73654abc482ac60c1e3ca60b867326713";
        };
        "aarch64-darwin" = {
          fileName = "go-mod-upgrade_${releaseVersion}_Darwin_arm64.tar.gz";
          sha256 = "15027f435a85f31346fd0796977180c43c737b7fe7bbb4fc3bcc5f4b8f32804c";
        };
      };
      supportedSystems = builtins.attrNames releaseBinaries;
    in
    flake-utils.lib.eachSystem supportedSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      releaseBinary = releaseBinaries.${system};
    in
    rec {
      packages.go-mod-upgrade = pkgs.stdenv.mkDerivation {
        pname = "go-mod-upgrade";
        version = releaseVersion;

        src = pkgs.fetchurl {
          url = "https://github.com/oligot/go-mod-upgrade/releases/download/v${releaseVersion}/${releaseBinary.fileName}";
          sha256 = releaseBinary.sha256;
        };

        sourceRoot = ".";

        installPhase = ''
          install -m755 -D go-mod-upgrade $out/bin/go-mod-upgrade
        '';
      };
    });
}
