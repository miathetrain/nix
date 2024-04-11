{
  inputs,
  pkgs ? (import ../nixpkgs.nix) {},
}: {
  arrpc = pkgs.callPackage ./arrpc {};
  ags-wrap = pkgs.callPackage ./ags-wrap {inherit inputs;};
  wivrn = pkgs.callPackage ./wivrn {};
  discover-overlay = pkgs.python3Packages.callPackage ./discover-overlay {};
}
