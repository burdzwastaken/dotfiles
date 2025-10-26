{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.50.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-8qNQ92VV0aog3USzeAMqWXws7kaQ//6/A/M85USTTXY=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-T6Zt5U2aCJWflwKzTbJXwK+BeE7L6IP4WAmISitrpRg=";

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
