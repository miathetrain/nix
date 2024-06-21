{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  imports = [
    inputs.chaotic.nixosModules.default

    ./security.nix
    ./boot.nix
    ./users.nix
    ./packages.nix
    ../nix
  ];

  system.stateVersion = mkDefault "24.05";

  time.timeZone = mkDefault "America/Detroit";
  location.provider = "geoclue2";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };

  home-manager.backupFileExtension = "backup";

  # environment.sessionVariables = {
  #   DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
  # };

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
