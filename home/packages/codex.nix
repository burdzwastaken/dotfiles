{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.57.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-Mjn2SesclOTBLiE7hQRtdyI/TpIM5lw2uswYyCMhyGY=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-ijXcYBMP63VzeHqVTEebJ83cYQtQgHU62kWklA1NHEA=";

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
