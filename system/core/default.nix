{
  lib,
  inputs,
  ...
}:
with lib; {
  imports = [
    inputs.chaotic.nixosModules.default

    ./security.nix
    ./boot.nix
    ./users.nix
    ../nix
  ];

  system.stateVersion = mkDefault "23.11";

  time.timeZone = mkDefault "America/Detroit";
  location.provider = "geoclue2";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };

  programs.light.enable = true;
  services.clight.enable = true;

  chaotic.mesa-git = {
    enable = true;
    fallbackSpecialisation = false;
  };

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
