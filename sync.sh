#!/bin/sh

rsync -av --delete --exclude 'secure' /etc/nixos/ ./etc/nixos
rsync -av --delete --prune-empty-dirs \
      --include '*.fnl' \
      --include "*/" \
      --exclude "*" \
      "$HOME/.config/nvim" '.config/nvim'
