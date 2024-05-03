{inputs, lib, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
  ];

  services.upower.enable = true;

  chaotic.scx = {
    enable = lib.mkForce false;
  };
}
