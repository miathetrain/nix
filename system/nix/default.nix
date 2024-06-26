{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./nh.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  # we need git for flakes
  environment.systemPackages = [pkgs.git];

  # Disable the NixOS Manual
  documentation.nixos.enable = false;

  # Remove xterm
  services.xserver.excludePackages = with pkgs; [xterm];

  nix = {
    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    optimise.automatic = true;

    settings = {
      warn-dirty = false;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

       auto-optimise-store = true;

      # for direnv GC roots
      # keep-derivations = true;
      # keep-outputs = true;

      trusted-users = ["root" "@wheel" "nixremote"];
    };
  };
}
