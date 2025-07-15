#!/usr/bin/env bash

nix fmt .

if ! git diff --quiet; then
    echo "❌ files are not formatted correctly"
    echo "run 'nix fmt .' to fix formatting"
    exit 1
else
    echo "✅ dotfiles are properly formatted"
fi
