let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix
    ./hardware/opentablet.nix
    ./hardware/bluetooth.nix

    ./network/default.nix

    ./programs

    ./services
    ./services/greetd.nix
    ./services/pipewire.nix
  ];
in {
  inherit desktop;
}
