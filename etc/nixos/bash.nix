{ config, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        bashrcExtra = ''
          SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
          export SSH_AUTH_SOCK
        '';
        initExtra = ''
          if [ "$(tty)" = "/dev/tty1" ]; then
              exec sway
          fi

          set -o vi
        '';
    };
}
