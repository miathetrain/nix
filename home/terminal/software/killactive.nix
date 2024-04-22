{pkgs, ...}: let
  killactive = pkgs.writeShellScriptBin "killactive" ''
    if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Kodi" ]; then
      pkill kodi-x11
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
