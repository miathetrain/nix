{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.aagl.nixosModules.default
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    # inputs.lemonake.nixosModules.wivrn
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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
    steamtinkerlaunch
    prismlauncher
    protonup-qt
    ryujinx

    ## VR
    # sidequest
    # wlx-overlay-s
    # opencomposite
    # xrgears
  ];

  # services = {
  #   wivrn = {
  #     enable = true;
  #     package = inputs.self.packages.${pkgs.system}.wivrn;
  #     openFirewall = true;
  #     highPriority = true;
  #     defaultRuntime = true;
  #   };
  # };

  programs.gamemode.enable = true;

  programs.anime-borb-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
}
