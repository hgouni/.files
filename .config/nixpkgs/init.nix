{ config, pkgs, ... }:

{
  home.file.".shrc".text = ''
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK

    case "$-" in *i*)
        if [ "$(tty)" = "/dev/tty1" ]; then
            exec sway
        # figure out how to make this work with nix-shells
        # elif test -z $VIM; then
        #   exec nvim
        fi
        ;;
    esac
  '';
}
