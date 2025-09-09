{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.31.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-BGrSArFU/wl47Xad7dzOCL8aNgvISwF5gXUNTpKDBMY=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-54eCWW+XJIiMbChvJ06o7SlFq7ZZVgovw2lUXUJem18=";

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
