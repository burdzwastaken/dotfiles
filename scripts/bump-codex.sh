#!/usr/bin/env bash
LATEST_COMMIT=$(curl -s https://api.github.com/repos/openai/codex/commits/main | jq -r '.sha')
echo "latest > $LATEST_COMMIT"

# nix-build -E "with import <nixpkgs> {}; callPackage ./home/packages/codex-cli.nix {}"
