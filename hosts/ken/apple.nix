{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
  ];

  services.upower.enable = true;

  chaotic.scx = {
    enable = false;
  };
}
