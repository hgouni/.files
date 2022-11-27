{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lawabidingcactus";
  home.homeDirectory = "/home/lawabidingcactus";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  imports = [
    ./bash.nix
    ./chez.nix
    ./cmus.nix
    ./dc.nix
    ./direnv.nix
    # ./emacs.nix
    ./environment.nix
    ./firefox.nix
    ./fish.nix
    ./fldigi.nix
    ./fonts.nix
    ./foot.nix
    ./gammastep.nix
    ./git.nix
    ./gnuradio.nix
    ./gpg.nix
    ./htop.nix
    ./icons.nix
    ./jq.nix
    ./keepassxc.nix
    # ./kitty.nix
    ./lsof.nix
    ./man.nix
    ./mosh.nix
    ./mpv.nix
    ./nitrokey.nix
    ./nvim.nix
    ./pandoc.nix
    ./pass.nix
    ./rash.nix
    ./readline.nix
    ./ripgrep.nix
    # ./rofi.nix
    ./ssh.nix
    ./sway.nix
    ./texlive.nix
    ./tmux.nix
    ./trash-cli.nix
    ./tree.nix
    ./virt-manager.nix
    ./wget.nix
    ./xdg-utils.nix
    ./zip.nix
  ];
}
