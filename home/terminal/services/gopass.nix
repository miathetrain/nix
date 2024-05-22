{pkgs, ...}: {
  home.packages = [pkgs.gopass];

  xdg.configFile."gopass/config".text = ''
    [mounts]
    path = ~/.local/share/gopass/stores/root

    [generate]
    generator = memorable
    length = 30
    symbols = true
    autoclip = true

    [show]
    autoclip = true

    [recipients]
    hash = 8815ae5d460506d6fa6002ade57b567a72ea6e67b582b569a4ba4080d9d8d05b
  '';
}
