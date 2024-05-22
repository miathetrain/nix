{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelParams = [
      "amd_pstate=active"
    ];
  };

  networking.hostName = "blossom";

  services.gaming.enable = true;

  services.gnome.sushi.enable = true;
}
