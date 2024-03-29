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

    gnome-text-editor
    gnome.file-roller
    gnome.nautilus
    gthumb
    mpv
    tagger
    qt5.qtwayland

    # Minecraft
    openjdk17
    tmux

    btop

    qbittorrent
    yt-dlp
    xorg.xrandr

    inputs.dimmer.packages.${pkgs.system}.default

    ddcutil
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
}
