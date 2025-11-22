{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.61.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-1DmnrRgwWNTkjG9DODUfLbz4ZYydhTapnv4yv9qOEmU=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-9zZZG00TzovQBwhidWt2p84dkj8jU35+lSmNIPmDOZY=";

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
