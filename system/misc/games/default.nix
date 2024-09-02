{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.gaming;
in {
  imports = [
    inputs.aagl.nixosModules.default
  ];

  options = {
    services.gaming.enable = mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable all gaming related options";
    };

    services.gaming.vr.enable = mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable all VR gaming related options";
    };
  };

  config = {
    programs = lib.mkIf cfg.enable {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };

      gamescope = {
        enable = true;
        capSysNice = true;
      };

      alvr = mkIf cfg.vr.enable {
        enable = true;
        openFirewall = true;
      };

      gamemode.enable = true;

      anime-borb-launcher.enable = true;
      honkers-railway-launcher.enable = true;
      sleepy-launcher.enable = true;
    };

    nix.settings = inputs.aagl.nixConfig;

    hardware.steam-hardware.enable = cfg.enable;

    environment.systemPackages = with pkgs;
      mkMerge [
        (mkIf (cfg.enable) [
          lutris
          heroic
          steamtinkerlaunch
          prismlauncher
          ryujinx
          xivlauncher
          # wineWowPackages.staging
          lunar-client
        ])

        (mkIf (cfg.vr.enable) [
          xrgears
          inputs.envision.packages.${pkgs.system}.envision
        ])
      ];

    chaotic = mkIf cfg.enable {
      steam.extraCompatPackages = with pkgs; [
        proton-ge-custom
      ];
    };

    boot = mkIf cfg.enable {
      kernelParams = [
        "clearcpuid=514" # Fixes Hogwarts Legacy
      ];
    };

    # services.wivrn = {
    #   enable = true;
    #   package = inputs.lemonake.packages.${pkgs.system}.wivrn; # Until WiVRn gets merged.
    #   openFirewall = true;
    #   highPriority = true;
    #   defaultRuntime = true;
    #   monadoEnvironment = {
    #     XRT_COMPOSITOR_LOG = "debug";
    #     XRT_PRINT_OPTIONS = "on";
    #     IPC_EXIT_ON_DISCONNECT = "off";
    #   };
    # };
  };
}
