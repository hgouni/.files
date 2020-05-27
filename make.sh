#!/bin/sh

chmod 700 "$HOME/.ssh"
chmod 700 "$HOME/.config/gnupg"

for i in $(git --git-dir="$HOME/.files/" --work-tree="$HOME" ls-tree -r master --name-only); do
    chmod go-rwx "$i"
done

if [ -z "$ENV" ]; then
    printf '%s\n' "ENV=$HOME/.shrc; export ENV" >> "$HOME/.profile"
    ENV="$HOME/.shrc"
fi

if [ -z "$TMUX" ]; then
    printf '%s\n' 'case "$-" in *i*) if [ -z "$TMUX" ]; then if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then SHELL=$(command -v fish) exec tmux new-session -As init; else SHELL=$(command -v fish) exec tmux; fi; fi;; esac' >> "$ENV"
    printf '%s\n' "source $ENV" >> "$HOME/.bashrc"
fi

case :$PATH: in
    *:$HOME/.local/bin:*)
        mkdir -p "$HOME/.local/bin"
        ;;
    *)
        mkdir -p "$HOME/.local/bin"
        printf '%s\n' 'PATH='"$HOME"'/.local/bin:$PATH; export PATH' >> "$HOME/.profile"
        ;;
esac

if ! [ "$TERMINAL" = 'st' ]; then
    printf '%s\n' 'TERMINAL=st; export TERMINAL' >> "$HOME/.profile"
fi
