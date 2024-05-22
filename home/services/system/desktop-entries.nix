{
  xdg.desktopEntries = {
    "Envision" = {
      name = "Envision";
      exec = "envision %F";
      icon = "org.gabmus.envision";
    };

    "Helix" = {
      name = "Helix";
      exec = "kitty hx %F";
    };

    "org.gnome.Nautilus" = {
      name = "Files";
      exec = "nautilus --new-window %U";
      noDisplay = true;
    };

    "fish" = {
      name = "fish";
      exec = "fish";
      noDisplay = true;
    };
  };

  xdg.userDirs = {
    enable = true;

    desktop = "";
    publicShare = "";
    templates = "";
  };
}
