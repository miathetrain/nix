{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./anyrun
    ./browsers/firefox.nix
    ./gtk.nix
    ./media

    # inputs.lemonake.homeManagerModules.steamvr
  ];

  home.packages = with pkgs; [
    vesktop
    krita
    mpv
    qbittorrent
    yt-dlp
    inputs.self.packages.${pkgs.system}.discover-overlay

    # Minecraft
    openjdk17
    tmux
    # xorg.xrandr
  ];

  # services = {
  #   steamvr = {
  #     runtimeOverride = {
  #       enable = true;
  #       path = "${inputs.nixpkgs-xr.packages.${pkgs.system}.opencomposite}/lib/opencomposite";
  #     };
  #     activeRuntimeOverride = {
  #       enable = true;
  #       path = "${inputs.self.packages.${pkgs.system}.wivrn}/share/openxr/1/openxr_wivrn.json";
  #     };
  #   };
  # };

  services.arrpc.enable = true;
  services.arrpc.package = inputs.self.packages.${pkgs.system}.arrpc;

  services.easyeffects.enable = true;
}
