{ config, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        # interactive only
        initExtra = ''
          if [ "$(tty)" = "/dev/tty1" ]; then
              exec sway
          fi

          set -o vi

          alias d='pushd'
          alias b='popd'
          alias c='clear'
          alias f='ls'

          PROMPT_DIRTRIM=2

          PS1="\e[1;32m\j \w\e[m "
        '';
    };
}
