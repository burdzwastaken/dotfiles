#!/usr/bin/env bash

sudo nix-channel --update
nix flake update
sudo nixos-rebuild switch --flake .#kernelpanic
