{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-patch.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  imports = [
    inputs.aagl.nixosModules.default
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    inputs.lemonake.nixosModules.wivrn
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    };

    alvr = {
      enable = true;
      openFirewall = true;
    };

    adb.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lutris
    heroic
    # itch
    gamescope
    mangohud
    steamtinkerlaunch
    prismlauncher
    protonup-qt
    ryujinx

    ## VR
    # sidequest
    wlx-overlay-s
    # opencomposite
    xrgears

    inputs.envision.packages.${pkgs.system}.envision
  ];

  chaotic.mesa-git.enable = true;

  boot.extraModulePackages = [
    (amdgpu-kernel-module.overrideAttrs (prev: {
      patches = (prev.patches or []) ++ [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch];
    }))
  ];

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

  programs.anime-borb-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
}
