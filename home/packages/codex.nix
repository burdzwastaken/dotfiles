{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.66.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-CWISGlSpS0A2yuXNC11L+5iT5Z9heHqkcIGQDJoUWFE=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-S6KCJ/b2fY8ydCoR+BfhEV4bbcgwQ6V0xHA9Mbl87jo=";

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
