{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      arrpc = pkgs.callPackage ./arrpc {};
      ags-wrap = pkgs.callPackage ./ags-wrap {};
    };
  };
}
