let
  desktop = [
    ./core
    ./network
    ./misc

    ./services
    # ./services/ananicy.nix
    ./services/gnome-services.nix
    ./services/greetd.nix
    ./services/pipewire.nix

    # Hardware
    ./hardware/bluetooth.nix
    ./hardware/graphics.nix
    # ./hardware/opentablet.nix
  ];
in {
  inherit desktop;
}
