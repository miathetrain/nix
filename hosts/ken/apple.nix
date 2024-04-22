{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
  ];

  services.poweralertd.enable = true;
}
