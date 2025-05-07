{
  description = "Beyond Squared HID Interface";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = rec {
          beyond_squared_hid = pkgs.callPackage ./default.nix { };
          default = beyond_squared_hid;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rustup
            pkg-config
            libudev-zero
            wayland
            libxkbcommon
            wayland-protocols
            libGL
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
          ];
          
          LD_LIBRARY_PATH = flake-utils.lib.makeLibraryPath [
            pkgs.vulkan-loader
            pkgs.wayland
            pkgs.libGL
          ];
        };
      }
    );
}