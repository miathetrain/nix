let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix
    ./hardware/opentablet.nix
    ./hardware/bluetooth.nix

    ./network/default.nix

    ./programs

    ./services/greetd.nix
    ./services/pipewire.nix
    ./services/ananicy.nix
    ./services/gnome-services.nix
  ];
in {
  inherit desktop;
}
