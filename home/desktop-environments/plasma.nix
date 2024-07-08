{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.plasma-manager.homeManagerModules.plasma-manager];

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "open";
    };

    shortcuts = {
      "kwin"."Window Close" = "Meta+Q";
      "kwin"."Kill Window" = "Meta+Shift+Q";

      "kwin"."Switch to Desktop 1" = "Ctrl+F1";
    };

    configFile = {
      "kdeglobals"."KFileDialog Settings"."Preview Width" = 455;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = true;

      "plasmanotifyrc"."Notifications"."NormalAlwaysOnTop" = true;

      "kcminputrc"."Mouse"."cursorTheme" = "GoogleDot-Blue";

      "kwinrc"."NightColor"."Active" = true;
      "kwinrc"."Plugins"."shakecursorEnabled" = false;
    };
  };
}
