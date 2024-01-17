{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.age
    pkgs.bc
    pkgs.bind
    pkgs.chez
    # pkgs.cubicsdr
    pkgs.fish
    # pkgs.fldigi
    pkgs.gnome.gnome-calculator
    pkgs.gnupg
    pkgs.hyperfine
    pkgs.imagemagick
    pkgs.inetutils
    pkgs.jq
    pkgs.keepassxc
    pkgs.krita
    pkgs.lm_sensors
    pkgs.lsof
    pkgs.mosh
    pkgs.mpv
    pkgs.nixos-generators
    pkgs.nmap
    pkgs.nushell
    pkgs.openssl
    pkgs.pandoc
    pkgs.pciutils
    pkgs.pdftk
    pkgs.psmisc
    pkgs.racket
    # pkgs.sdrangel
    pkgs.smartmontools
    pkgs.speechd
    pkgs.trash-cli
    pkgs.tree
    pkgs.unzip
    pkgs.usbutils
    pkgs.virt-manager
    pkgs.wget
    pkgs.xdg-utils
    pkgs.xournalpp
    pkgs.zbar
    pkgs.zip
  ];
}
