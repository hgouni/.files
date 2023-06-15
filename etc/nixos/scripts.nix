{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "update"
    ''
      set -euo pipefail

      sudo nix flake update /etc/nixos

      sudo nixos-rebuild boot

      if test "$#" -gt 0
      then
          case "$1" in
              -r)
                  reboot
                  exit
                  ;;
          esac
      fi

      read -rp 'Reboot now? [y/n] ' answer

      case "$answer" in
          y | Y)
              reboot
              ;;
          *)
              printf 'Exiting.\n'
              ;;
      esac
    '')
  ];
}
