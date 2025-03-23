{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rustfmt" "clippy" ];
        };
      in
      {
        devShell = pkgs.mkShell {
          packages = [ rustToolchain ];
          RUST_SRC_PATH = rustToolchain.packages.rust-src;
        };

        packages = {
          desktop-controls = pkgs.rustPlatform.buildRustPackage {
            pname = "desktop-controls";
            version = "0.1.0"; # Replace with your version
            src = ./.; # Assumes your Cargo.toml is in the same directory as flake.nix
            cargoLock = {
                lockFile = ./Cargo.lock;
            };
          };
          default = self.packages.${system}.desktop-controls;
        };
      });
}