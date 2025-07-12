{ stdenv, fetchFromGitHub, nodejs, pnpm, makeWrapper, ... }:

let
  codexRepo = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = "bfeb8c92a591e8f20ecabb2a1b5a22e1574e7951";
    sha256 = "sha256-kdKZrxlN3ueSPkB+lbwx+QiOj5emz5aNohkH/C/EbzY=";
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
