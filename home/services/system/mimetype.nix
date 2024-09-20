{
  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "org.gnome.Nautilus.desktop";
    "image/webp" = "org.gnome.gThumb.desktop";
    "image/png" = "org.gnome.gThumb.desktop";
    "image/jpeg" = "org.gnome.gThumb.desktop";
    "text/plain" = "org.gnome.TextEditor.desktop";
  };

  xdg.mimeApps.associations.added = {
    "image/webp" = "org.gnome.gThumb.desktop";
    "image/png" = "org.gnome.gThumb.desktop";
    "image/jpeg" = "org.gnome.gThumb.desktop";
    "x-scheme-handler/r2" = "reloaded-ii-url.desktop";
    "x-scheme-handler/http" = "firefox-beta.desktop;";
    "x-scheme-handler/https" = "firefox-beta.desktop;";
    "x-scheme-handler/chrome" = "firefox-beta.desktop;";
  };
}
