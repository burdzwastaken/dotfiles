{ stdenv, fetchFromGitHub, nodejs, pnpm, makeWrapper, ... }:

let
  codexRepo = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = "8a6c6cee880436a2055a7afb2ebabd15d4921e4c";
    sha256 = "sha256-fXvOuv51oaiMMy1ORlFEDa9hhz8lG8LeYRjKwF/o06w=";
    # sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codex-cli";
  version = "0.1.0";
  src = codexRepo;
  sourceRoot = finalAttrs.src.name;
  nativeBuildInputs = [
    nodejs
    pnpm
    pnpm.configHook
    makeWrapper
  ];
  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-SyKP++eeOyoVBFscYi+Q7IxCphcEeYgpuAj70+aCdNA=";
    # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  buildPhase = ''
    cd codex-cli
    pnpm install --frozen-lockfile
    pnpm run build
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/lib

    install -Dm644 dist/cli.js $out/lib/cli.js

    install -Dm644 package.json $out/package.json

    if [ -d node_modules ]; then
      cp -r node_modules $out/node_modules
    fi

    makeWrapper ${nodejs}/bin/node $out/bin/codex \
      --add-flags "$out/lib/cli.js" \
      --set NODE_PATH "$out/node_modules"

    runHook postInstall
  '';
})
