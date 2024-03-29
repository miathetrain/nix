{
  systems = ["x86_64-linux"];

  perSystem = {
    config,
    self',
    inputs',
    pkgs,
    system,
    ...
  }: {
    packages = {
      arrpc = pkgs.callPackage ./arrpc {};
      ags-wrap = pkgs.callPackage ./ags-wrap {inherit inputs';};
      wivrn = pkgs.callPackage ./wivrn {};
    };
  };
}
