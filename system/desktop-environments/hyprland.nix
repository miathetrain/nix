{
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.displayManager.defaultSession = "Hyprland";
  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "Hyprland";
      start = ''Hyprland'';
    }
  ];

  # programs.hyprland = {
  #   enable = true;
  # };

  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
