{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "update-and-reboot"
    ''
      set -euo pipefail

      sudo nix flake update /etc/nixos

      sudo nixos-rebuild boot

      if test "$#" -gt 0
      then
          case "$1" in
              -r)
                  reboot
                  ;;
          esac
      fi

      read -rp 'Reboot now? [y/n] ' answer

      case "$answer" in
          y | Y)
              reboot
              ;;
          *)
              printf 'Aborting.\n'
              ;;
      esac
    '')
  ];
}
