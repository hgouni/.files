#!/usr/bin/env bash

set -e          # immediately exit on failure
set -u          # treat uninitialized variables as an error
set -o pipefail # pipes return error if any commands in them do

for file in $(find "$HOME/.config/nvim" -type f -name '*.fnl'); do
    fennel --compile "$file" | tee "$(printf '%s\n' $file | sed -e 's/fnl/lua/g')" > /dev/null
    printf '%s compiled\n' $file
done
