#!/bin/sh

rsync -av --delete --exclude 'secure' /etc/nixos/ ./etc/nixos
cp "$HOME"/.config/nvim/config.fnl ./.config/nvim/
