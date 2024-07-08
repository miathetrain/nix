{pkgs, ...}: {
  imports = [inputs.plasma-manager.homeManagerModules.plasma-manager];

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
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
    };
  };
}
