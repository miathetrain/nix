# {
#   inputs,
#   pkgs ? (import ../nixpkgs.nix) {},
# }: {
#   arrpc = pkgs.callPackage ./arrpc {};
#   ags-wrap = pkgs.callPackage ./ags-wrap {inherit inputs;};
#   sgdboop = pkgs.callPackage ./sgdboop {};
#   t2fanrd = pkgs.callPackage ./t2fanrd {};
# }
{
  flake,
  system,
  inputs,
  ...
}: self: super: {
  t2fanrd = self.callPackage ./t2fanrd {};
  arrpc = self.callPackage ./arrpc {};
  ags-wrap = self.callPackage ./ags-wrap {inherit inputs;};
  sgdboop = self.callPackage ./sgdboop {};
}
