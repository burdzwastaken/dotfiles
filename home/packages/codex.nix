{ unstable }:

unstable.rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.47.0";

  src = unstable.fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-5AyatNXgHuia656OuSDozQzQv80bNHncgLN1X23bfM4=";
  };

  sourceRoot = "${src.name}/codex-rs";
  cargoHash = "sha256-PQ1NxwNBaI48gQ4GGoricA/j7vpsnaLlL6st5P+CTHk=";

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
