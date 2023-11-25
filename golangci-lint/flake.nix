{
  description = "golangci-lint built with go 1.21";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    rec {
      packages.golangci-lint = pkgs.golangci-lint.override { buildGoModule = pkgs.buildGo121Module; };
      packages.default = packages.golangci-lint;

      apps.golangci-lint = flake-utils.lib.mkApp {
        drv = packages.golangci-lint;
      };
      apps.default = apps.golangci-lint;
    });
}
