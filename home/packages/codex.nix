{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.58.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-CY9ai6Ia6bixACEIIWc85DqFDUf31zMnVJTqkVQArDs=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-FqGgHzq9JhegpRQEpOGtTmdnfypOeIlE43SdWs1/ddM=";

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
