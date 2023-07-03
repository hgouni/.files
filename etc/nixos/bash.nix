{ config, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        # login only
        profileExtra = ''
          if [[ "$-" == *i* && "$(tty)" == '/dev/tty1' ]]; then
              exec sway
          fi
        '';
        # interactive only
        initExtra = ''
          set -o vi

          alias d='pushd'
          alias b='popd'
          alias c='clear'
          alias f='ls'

          PS1="\e[1;32m\j \w\e[m "
        '';
    };
}
