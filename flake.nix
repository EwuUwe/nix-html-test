{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix-filter,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        with pkgs; {
          formatter = pkgs.alejandra;
          packages.default = stdenv.mkDerivation {
            name = "html-nix";
            src = nix-filter {
              root = ./.;
              exclude = [
                (nix-filter.lib.matchExt "nix")
                ./flake.lock
              ];
            };
            installPhase = ''
              mkdir -p $out
              cp -r * $out
            '';
          };
        }
    );
}
