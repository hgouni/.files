#!/bin/sh

if command -v nix > /dev/null 2>&1; then
	curl -L https://nixos.org/nix/install | sh
fi

if command -v home-manager > /dev/null 2>&1; then
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-"$(nixos-version | cut -c -5)".tar.gz home-manager
    nix-channel --update
fi
