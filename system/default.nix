let
  desktop = [
    ./core
    ./network
    ./misc

    ./services/ananicy.nix
    ./services/gnome-services.nix
    ./services/greetd.nix
    ./services/pipewire.nix

    # Hardware
    ./hardware/bluetooth.nix
    ./hardware/opentablet.nix
  ];
in {
  inherit desktop;
}
