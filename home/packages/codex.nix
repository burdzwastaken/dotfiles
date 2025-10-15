{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.46.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-o898VjjPKevr1VRlRhJUNWsrHEGEn7jkdzWBj+DpbCs=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-Qp5zezXjVdOp8OylLgUZRLc0HQlgII6nOZodnOrok6U=";

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
