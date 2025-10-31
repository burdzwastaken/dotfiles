{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.53.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-sDL7gpq73RyyTgi97sxWDq6mhqQiYLyvSN76H8Pp3Uk=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-EXDvcCY1l2C/IVJLQtou11Lmcsrn8SBGCo8DexEjpbg=";

  nativeBuildInputs = with unstable; [
    installShellFiles
    pkg-config
  ];

  buildInputs = with unstable; [
    openssl
  ];

  doCheck = false;

  meta = with unstable.lib; {
    description = "OpenAI Codex CLI";
    homepage = "https://github.com/openai/codex";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
