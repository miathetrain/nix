{
  inputs,
  pkgs ? (import ../nixpkgs.nix) {},
}: {
  arrpc = pkgs.callPackage ./arrpc {};
  ags-wrap = pkgs.callPackage ./ags-wrap {inherit inputs;};
  sgdboop = pkgs.callPackage ./sgdboop {};
  t2fanrd = pkgs.callPackage ./t2fanrd {};
}
