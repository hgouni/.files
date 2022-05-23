#!/bin/sh

# exclude files that should not be uploaded to git
# like private keys for VPN configs
rsync -av --delete --exclude 'secure' /etc/nixos/ ./etc/nixos

# exclude everything but .fnl files in any directory in the
# nvim one. do not include empty directories
rsync -av --delete --prune-empty-dirs \
      --include '*.fnl' \
      --include "*/" \
      --exclude "*" \
      "$HOME/.config/nvim/" '.config/nvim'
