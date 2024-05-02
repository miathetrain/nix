let
  desktop = [
    ./core
    ./hardware
    ./network
    ./misc
    ./services

    ./services
    ./services/ananicy.nix
    ./services/gnome-services.nix
    # ./services/greetd.nix
    ./services/pipewire.nix
  ];
in {
  inherit desktop;
}
