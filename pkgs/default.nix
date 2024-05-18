{inputs, ...}: self: super: {
  t2fanrd = super.callPackage ./t2fanrd {};
  arrpc = super.callPackage ./arrpc {};
  hyprshade = super.python3Packages.callPackage ./hyprshade {};
}
