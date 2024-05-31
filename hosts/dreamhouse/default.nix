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

  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "dreamhouse";

  services.gaming.enable = true;
  services.gaming.vr.enable = true;

  services.secureboot.enable = true;
  services.gnome.sushi.enable = true;
}
