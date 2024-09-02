let
  desktop = [
    ./core
    ./network
    ./misc

    # ./services/ananicy.nix
    # ./services/gnome-services.nix
    # ./services/greetd.nix
    ./services/pipewire.nix

    # Hardware
    ./hardware/bluetooth.nix
    ./hardware/opentablet.nix

    # Desktop Environments
    # ./desktop-environments/look-and-feel
    ./desktop-environments/hyprland.nix
    ./desktop-environments/plasma.nix
    #./desktop-environments/cosmic.nix
  ];
in {
  inherit desktop;
}
