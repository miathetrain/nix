{pkgs, ...}: let
  killactive = pkgs.writeShellScriptBin "killactive" ''
    if [ "$(hyprctl activewindow -j | jq -r ".class")" = "steam" ] || [ "$(hyprctl activewindow -j | jq -r ".class")" = "Kodi" ]; then
      xdotool getactivewindow windowunmap
    else
      hyprctl dispatch killactive ""
    fi
  '';
in {
  home.packages = with pkgs; [
    killactive
    xdotool
  ];
}
