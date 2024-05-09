{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "arrpc";
  version = "git";

  src = fetchFromGitHub {
    owner = "Barbie-Dreamhouse";
    repo = "arrpc";
    # Release commits are not tagged
    # release: 3.3.0
    rev = "49439860f0ce1b6f230f9de42d89cc20ec839dc4";
    hash = "sha256-J+2Rh/wLppU4AVPEXxkzri09OAgm7Ih1XCBFfgXE4J0=";
  };

  npmDepsHash = "sha256-S9cIyTXqCp8++Yj3VjBbcStOjzjgd0Cq7KL7NNzZFpY=";

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
