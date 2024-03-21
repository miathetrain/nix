{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.aagl.nixosModules.default
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  environment.systemPackages = with pkgs; [
    lutris
    heroic
    itch
    steamtinkerlaunch
    prismlauncher
    protonup-qt
    alvr
    ryujinx
    wlx-overlay-s
    opencomposite
  ];

  programs.gamemode.enable = true;

  programs.anime-borb-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
}
