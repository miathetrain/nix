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
    rev = "32a0424d1961c9ac5b8fbd3ff2799e23e2990698";
    hash = "sha256-T4NEE4fKVEWCQeuhdT3MwZaJZk+stB70644EhQONniM=";
  };

  npmDepsHash = "sha256-YlSUGncpY0MyTiCfZcPsfcNx3fR+SCtkOFWbjOPLUzk=";

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
