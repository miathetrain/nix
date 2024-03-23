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
    obinskit

    # misc
    pciutils
    nixos-icons
    colord
    ffmpegthumbnailer
    imagemagick
    xfce.tumbler
    xdotool
    cliphist
    rizin
    xcolor
    nodejs
    nodePackages.pnpm
    jq
    socat
    catimg
    bun
    libnotify

    # Temp
    sassc

    gnome-text-editor
    gnome.file-roller
    gnome.nautilus
    gthumb
    mpv

    # Minecraft
    openjdk17
    tmux

    wineWowPackages.stable
    btop

    qbittorrent
    yt-dlp
    xorg.xrandr
  ];

  services.arrpc.enable = true;
  services.arrpc.package = inputs.self.packages.${pkgs.system}.arrpc;
}
