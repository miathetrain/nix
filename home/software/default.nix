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
  ];

  services.arrpc.enable = true;
  services.arrpc.package = inputs.self.packages.${pkgs.system}.arrpc;
}
