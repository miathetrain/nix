rustPlatform.buildRustPackage rec {
  pname = "T2FanRD";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "GnomedDev";
    repo = pname;
    rev = "85027878e4d7fa0170fea1213d6f8dd972d60e83";
    sha256 = "";
  };

  cargoSha256 = "";

  meta = with stdenv.lib; {
    description = "Simple Fan Daemon for T2 Macs, rewritten from the original Python version.";
    homepage = "https://github.com/GnomedDev/T2FanRD";
    license = licenses.gpl3Only;
  };
}
