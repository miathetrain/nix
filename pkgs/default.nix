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
