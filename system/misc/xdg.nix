{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [
          "kde"
        ];

        "org.freedesktop.impl.portal.Secret" = [
          "kwallet"
        ];
      };

      kde = {
        default = [
          "kde"
        ];

        "org.freedesktop.impl.portal.Secret" = [
          "kwallet"
        ];
      };

      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];

        # "org.freedesktop.impl.portal.Secret" = [
        #   "kwallet"
        # ];
      };
    };
  };
}
