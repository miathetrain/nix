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
    ./graphics.nix
  ];

  boot = {
    extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xFFF7FFFF
    '';

    kernelParams = [
      "amd_pstate=active"
    ];
  };

  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "dreamhouse";

  services.gaming.enable = true;
  # services.gaming.vr.enable = true;

  services.secureboot.enable = true;
  services.gnome.sushi.enable = true;

  environment.systemPackages = with pkgs; [
    lact
  ];

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = ["multi-user.target"];
  };
}
