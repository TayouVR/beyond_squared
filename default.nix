{
  lib,
  rustPlatform,
  pkg-config,
  libudev-zero,
  wayland,
  libxkbcommon,
  wayland-protocols,
  libGL,
  vulkan-loader,
}:
rustPlatform.buildRustPackage {
  pname = "beyond_squared_hid";
  version = "0.1.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
    wayland-protocols
  ];

  buildInputs = [
    libudev-zero
    wayland
    libxkbcommon
    libGL
    vulkan-loader
  ];

  postFixup = ''
    patchelf --add-rpath ${vulkan-loader}/lib $out/bin/*
    patchelf --add-rpath ${libxkbcommon}/lib $out/bin/*
  '';

  # Install udev rules
  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp ${./nix/99-beyond-squared.rules} $out/lib/udev/rules.d/99-beyond-squared.rules
  '';

  meta = with lib; {
    description = "HID interface for Beyond Squared";
    homepage = "https://github.com/yourusername/beyond_squared";
    license = licenses.mit;
    maintainers = [];
  };
}
