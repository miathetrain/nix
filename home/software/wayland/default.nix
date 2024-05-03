{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./wlogout.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    wl-screenrec
    hyprpicker
    wlsunset
  ];
}
