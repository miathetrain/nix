{pkgs ? (import ../nixpkgs.nix) {}}: {
  arrpc = pkgs.callPackage ./arrpc {};
  ags-wrap = pkgs.callPackage ./ags-wrap {};
  wivrn = pkgs.callPackage ./wivrn {};
  discover-overlay = pkgs.callPackage ./discover-overlay {};
}
