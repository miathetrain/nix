{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-kde
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
          "kde"
        ];

        # "org.freedesktop.impl.portal.Secret" = [
        #   "kwallet"
        # ];
      };
    };
  };
}
