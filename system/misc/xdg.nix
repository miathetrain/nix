{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    # extraPortals = [
    #   pkgs.xdg-desktop-portal-gtk
    # ];

    # configPackages = [
    #     pkgs.xdg-desktop-portal-gtk
    #   ];
  };
}
