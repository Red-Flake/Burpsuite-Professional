#!/usr/bin/env bash

# Update flake.lock to newest nixpkgs nixos-unstable hash
echo "Updating flake.lock ..."
nix flake update

# Commit changes
git add *
git commit -am "updated nixpkgs flake input"

# Push changes
git push
