{pkgs, ...}: {
  # services.flatpak.enable = true;
  # programs.light.enable = true;

  environment.systemPackages = with pkgs; [
    wget
  ];

  chaotic.mesa-git = {
    # TODO: Move to Gaming.
    enable = true;
    fallbackSpecialisation = false;
  };
}
