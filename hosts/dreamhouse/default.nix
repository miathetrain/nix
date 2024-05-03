{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
    ./backlight.nix
  ];

  boot = {
    kernelParams = [
      "amd_pstate=active"
    ];
  };

  networking.hostName = "dreamhouse";

  services.gaming.enable = true;
  services.secureboot.enable = true;
}
