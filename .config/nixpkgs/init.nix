{ config, pkgs, ... }:

{
  home.file.".shrc".text = ''
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK

    case "$-" in *i*)
        if [ "$(tty)" = "/dev/tty1" ]; then
            exec sway
        elif [ -z "$TMUX" ]; then
            if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then
                SHELL=rash exec tmux new-session -As init
            else
                SHELL=rash exec tmux
            fi
        fi
        ;;
    esac
  '';
}
