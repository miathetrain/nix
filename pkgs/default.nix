{
  inputs,
  pkgs ? (import ../nixpkgs.nix) {},
}: {
  arrpc = pkgs.callPackage ./arrpc {};
  ags-wrap = pkgs.callPackage ./ags-wrap {inherit inputs;};
  obinskit = pkgs.callPackage ./obinskit {};
}
