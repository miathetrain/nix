{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      arrpc = pkgs.callPackage ./arrpc {};
      asztal = pkgs.callPackage ./ags {};
    };
  };
}
