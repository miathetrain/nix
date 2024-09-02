{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-hyprland
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
        ];

        # "org.freedesktop.impl.portal.Secret" = [
        #   "kwallet"
        # ];
      };
    };
  };
}
