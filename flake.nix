{
  description = "Beyond Squared HID Interface";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [rust-overlay.overlays.default];
        };
      in {
        packages = rec {
          beyond_squared_hid = pkgs.callPackage ./default.nix {};
          default = beyond_squared_hid;
        };

        devShells.default = pkgs.mkShell rec {
          nativeBuildInputs = with pkgs; [
            rust-bin.stable.latest.default
            pkg-config
            libudev-zero
            wayland
            libxkbcommon
            libGL
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath nativeBuildInputs;
        };
      }
    );
}
