{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "arrpc";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "cannibalmaid";
    repo = "arrpc";
    # Release commits are not tagged
    # release: 3.3.0
    rev = "ab90c75f11a921e884932c89d3c8808478905d1a";
    hash = "sha256-cscjRLRv0u2iIPldtQqpA1zgmP/3WjOEl7+F02SgQco=";
  };

  npmDepsHash = "sha256-BqX/+f5CCdaDAfazIPj6AKtecVEG+wnPGpegusExGR0=";

  dontNpmBuild = true;

  meta = {
    # ideally we would do blob/${version}/changelog.md here
    # upstream does not tag releases
    changelog = "https://github.com/OpenAsar/arrpc/blob/${src.rev}/changelog.md";
    description = "Open Discord RPC server for atypical setups";
    homepage = "https://arrpc.openasar.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [anomalocaris NotAShelf];
    mainProgram = "arrpc";
  };
}
