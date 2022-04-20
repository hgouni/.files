{ config, pkgs, ... }:

{
  home.file.".shrc".text = ''
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK

    case "$-" in *i*)
        if [ "$(tty)" = "/dev/tty1" ]; then
            exec sway
        else
            exec fish
        fi
        ;;
    esac
  '';
}
