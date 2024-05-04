{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
    inputs.nixos-hardware.nixosModules.apple-macbook-air-6
  ];

  hardware.apple-t2.enableAppleSetOsLoader = true;
  systemd.services.tiny-dfr.enable = false;

  services.upower.enable = true;

  chaotic.scx = {
    enable = lib.mkForce false;
  };
}
