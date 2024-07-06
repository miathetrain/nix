{
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
    inputs.nixos-hardware.nixosModules.apple-macbook-air-6
  ];

  # hardware.firmware = [
  #   (stdenvNoCC.mkDerivation (final: {
  #     name = "brcm-firmware";
  #     src = ./firmware;
  #     installPhase = ''
  #       mkdir -p $out/lib/firmware/
  #       cp -r ${final.src}/brcm "$out/lib/firmware/"
  #     '';
  #   }))
  # ];

  environment.systemPackages = with pkgs; [poweralertd];

  systemd.services.tiny-dfr.enable = mkForce false;

  services.upower.enable = true;

  chaotic.scx = {
    enable = lib.mkForce false;
  };
}
