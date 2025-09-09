#!/usr/bin/env bash
set -euo pipefail

LATEST_TAG=$(curl -s https://api.github.com/repos/openai/codex/tags | jq -r '.[0].name')
echo "$LATEST_TAG"

# nix-build -E "with import <nixpkgs> {}; callPackage ./home/packages/codex-cli.nix {}"
