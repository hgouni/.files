{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "update"
    ''
      set -euo pipefail

      reboot='no'

      while test "$#" -gt 0
      do
          case "$1" in
              '-h' | '--help')
                  printf '%s\n%s\n%s\t%s\n' \
                      'Usage: update [-r]' \
                      'Update nixos and reboot.' \
                      '-r, --reboot' 'Reboot without prompting.'
                  exit
                  ;;
              '-r' | '--reboot')
                  reboot='yes'
                  ;;
              *)
                  printf 'Invalid options passed: %s\n' "$1"
                  exit
                  ;;
          esac
          shift
      done

      sudo nix flake update /etc/nixos

      sudo nixos-rebuild boot

      if test "$reboot" = 'yes'
      then
          reboot
          exit
      fi

      read -rp 'Reboot now? [y/n] ' answer

      case "$answer" in
          'y' | 'Y')
              reboot
              ;;
          *)
              printf 'Exiting.\n'
              ;;
      esac
    '')
  ];
}
