{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      rust-app = pkgs.rustPlatform.buildRustPackage {
        pname = "desktop-controls";
        version = "0.1.0";
        src = ./.;
        cargoLock = {
            lockFile = ./Cargo.lock;
        };
        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ ];
      };
    in
    {
      defaultPackage.${system} = rust-app;
      devShell.${system} = pkgs.mkShell {
        inputsFrom = [rust-app];
        packages = [ pkgs.rustc pkgs.cargo pkgs.pkg-config ];
      };
    };
}