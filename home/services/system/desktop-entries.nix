{
  xdg.desktopEntries = {
    "Helix" = {
      name = "Helix";
      exec = "kitty hx %F";
      icon = "helix";
    };

    # "org.gnome.Nautilus" = {
    #   name = "Files";
    #   exec = "nautilus --new-window %U";
    #   noDisplay = true;
    # };

    "fish" = {
      name = "fish";
      exec = "fish";
      noDisplay = true;
    };

    "mpv" = {
      name = "kitty";
      exec = "kitty";
      noDisplay = true;
    };

    "btop" = {
      name = "kitty";
      exec = "kitty";
      noDisplay = true;
    };
  };

  xdg.userDirs = {
    enable = true;

    desktop = "";
    publicShare = "";
    templates = "";

    pictures = "/home/mia/Nextcloud/Pictures";
  };
}
