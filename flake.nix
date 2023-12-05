{
  description = "Useful flakes for golang and Kubernetes projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system}; rec {
        packages = rec {
          golangci-lint = golangci-lint.override { buildGoModule = buildGo121Module; };
          go-apidiff = buildGo121Module {
            name = "go-apidiff";
            src = fetchFromGitHub {
              owner = "joelanford";
              repo = "go-apidiff";
              rev = "v0.7.0";
              hash = "sha256-vuub9PJ68I5MOYv73NaZTiewPr+4MRdFKQGdfvMi+Dg=";
            };
            doCheck = false;
            subPackages = [ "." ];
            vendorHash = "sha256-GF8mxSVFjaijE8ul9YgMZKaTMTSR5DkwCNY7FZCwiAU=";
          };
        };
        formatter = alejandra;
      }
    );
}
