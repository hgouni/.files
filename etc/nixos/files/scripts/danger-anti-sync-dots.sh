#!/bin/bash

printf 'Replacing /etc/nixos\n'

sudo rsync --info=NAME --archive --delete \
      --exclude 'hardware-configuration.nix' \
      "$HOME/.files/etc/nixos/" '/etc/nixos'

sudo chown -R root:root '/etc/nixos'

printf 'Replacing %s/.config/nvim\n' "$HOME"

sudo rsync --info=NAME --archive --delete \
      "$HOME/.files/.config/nvim/" "$HOME/.config/nvim"

compile-nvim-conf
