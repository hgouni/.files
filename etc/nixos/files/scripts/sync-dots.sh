#!/bin/sh

printf 'Syncing /etc/nixos\n'

# --prune-empty-dirs:
# prevent empty directories from being created at the destination (as a result
# of exclusions)
#
# --exclude 'secure':
# exclude files that should not be uploaded to git, like private keys for VPN
# configs
# 
# (this comment can't go in the rsync command itself, gets parsed wrong)
rsync --info=NAME --archive --delete --prune-empty-dirs \
      --exclude 'secure' \
      --exclude 'hardware-configuration.nix' \
      '/etc/nixos/' "$HOME/.files/etc/nixos"

printf "Syncing $HOME/.config/nvim\n"

# exclude everything but .fnl files in any directory in the
# nvim one. do not include empty directories
rsync --info=NAME --archive --delete --prune-empty-dirs \
      --include '*.fnl' \
      --include 'syntax/*.vim' \
      --include "*/" \
      --exclude "*" \
      "$HOME/.config/nvim/" "$HOME/.files/.config/nvim"
