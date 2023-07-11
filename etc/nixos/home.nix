{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hemant";
  home.homeDirectory = "/home/hemant";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  imports = [
    ./alacritty.nix
    ./bash.nix
    ./direnv.nix
    # ./emacs.nix
    ./extrautils.nix
    ./firefox.nix
    ./fish.nix
    ./foot.nix
    ./fuzzel.nix
    ./gammastep.nix
    ./git.nix
    ./gnuradio.nix
    # ./gpg.nix
    ./htop.nix
    ./icons.nix
    ./man.nix
    ./nvim.nix
    ./pass.nix
    ./readline.nix
    ./rg.nix
    ./scripts.nix
    ./ssh.nix
    ./sway.nix
    ./texlive.nix
    ./tmux.nix
  ];
}
