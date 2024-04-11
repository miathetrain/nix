{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "pulseshitter";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Enitoni";
    repo = "pulseshitter";
    rev = "v${version}";
    hash = "sha256-4ovC7GYkCb1BkCA1EO8SKWDdEnjteRX2/daV6tWohQE=";
  };

  cargoHash = "sha256-EFwW3xwYcLyfu+rEeDRXTg/FFqcZAJLulIWm4WR+KkY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "An overengineered workaround to Discord not supporting audio when screensharing on Linux";
    homepage = "https://github.com/Enitoni/pulseshitter";
    license = licenses.mpl20;
    maintainers = with maintainers; [];
    mainProgram = "pulseshitter";
  };
}
