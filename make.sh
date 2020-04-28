#!/bin/sh

if [ -z "$ENV" ]; then
    printf '%s\n' "ENV=$HOME/.shrc; export ENV" >> "$HOME/.profile"
    ENV="$HOME/.shrc"
fi

if [ -z "$TMUX" ]; then
    printf '%s\n' 'case "$-" in *i*) if [ -z "$TMUX" ]; then if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then SHELL=$(command -v fish) exec tmux new-session -As init; else SHELL=$(command -v fish) exec tmux; fi; fi;; esac' >> "$ENV"
    printf '%s\n' "source $ENV" >> "$HOME/.bashrc"
fi

case :$PATH: in
    *:/home/.local/bin:*)
        mkdir -p "$HOME/.local/bin"
        ;;
    *)
        mkdir -p "$HOME/.local/bin"
        printf '%s\n' 'PATH='"$HOME"'/.local/bin:$PATH; export PATH' >> "$HOME/.profile"
        ;;
esac

if ! [ -x "$(command -v pw_prompt_gui)" ]; then
    printf '%s\n%s\n' '#!/bin/sh' 'zenity --password --title=auth' > "$HOME/.local/bin/pw_prompt_gui"
    chmod 700 "$HOME/.local/bin/pw_prompt_gui"
fi

if ! [ "$TERMINAL" = 'st' ]; then
    printf '%s\n' 'TERMINAL=st; export TERMINAL' >> "$HOME/.profile"
fi
