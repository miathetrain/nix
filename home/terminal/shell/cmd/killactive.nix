{pkgs, ...}: let
  killactive = pkgs.writeShellScriptBin "killactive" ''
    if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Kodi" ]; then
      killall -s SIGKILL kodi-x11
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
