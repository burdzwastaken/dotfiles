#!/usr/bin/env bash

./scripts/fmt.sh
sudo nix-channel --update
nix flake update
sudo nixos-rebuild switch --flake .#kernelpanic
