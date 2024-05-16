{inputs, ...}: self: super: {
  t2fanrd = super.callPackage ./t2fanrd {};
  arrpc = super.callPackage ./arrpc {};
  ags-wrap = super.callPackage ./ags-wrap {inherit inputs;};
  hyprshade = super.python3Packages.callPackage ./hyprshade {};
}
