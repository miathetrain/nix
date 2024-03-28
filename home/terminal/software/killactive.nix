{pkgs, ...}: let
  killactive = pkgs.writeShellScriptBin "killactive" ''
    if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ] || [ "$(hyprctl activewindow -j | jq -r ".class")" = "kodi" ]; then
      xdotool getactivewindow windowunmap
    else
      hyprctl dispatch killactive ""
    fi
  '';
in {
  home.packages = [killactive];
}
