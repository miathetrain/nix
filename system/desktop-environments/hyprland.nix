{
  specialisation."hyprland".configuration = {
    environment.etc."specialisation".text = "hyprland";

    services.xserver.displayManager.gdm.enable = true;
    programs.hyprland = {
      enable = true;
    };

    # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
