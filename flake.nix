{
  description = "Useful flakes for golang and Kubernetes projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mindthegap-flake = {
      url = "./mindthegap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    golangci-lint-flake = {
      url = "./golangci-lint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    go-mod-upgrade-flake = {
      url = "./go-mod-upgrade";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    mindthegap-flake,
    golangci-lint-flake,
    go-mod-upgrade-flake,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = rec {
        mindthegap = mindthegap-flake.packages.${system}.mindthegap;
        golangci-lint = golangci-lint-flake.packages.${system}.golangci-lint;
        go-mod-upgrade = go-mod-upgrade-flake.packages.${system}.go-mod-upgrade;
      };
    });
}
