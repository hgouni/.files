#!/bin/sh

rm "$HOME/.bash_profile"
rm "$HOME/.bash_login"

chmod 600 "$HOME/.ssh"
chmod 600 "$HOME/.config/gnupg"

for file in $(git --git-dir="$HOME/.files/" --work-tree="$HOME" ls-tree -r master --name-only); do
    chmod go-rwx "$file"
done
