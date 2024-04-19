{pkgs, ...}: {
  home.packages = [pkgs.gopass];
  xdg.configFile."gopass/config".text = ''
     [mounts]
    path = /home/mia/.local/share/gopass/stores/root

     [generate]
     generator = memorable
     length = 30
     symbols = true
     autoclip = true

     [show]
     autoclip = true
  '';
}
