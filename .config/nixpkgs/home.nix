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
    ./environment.nix
    ./direnv.nix
    ./firefox.nix
    ./fish.nix
    ./fldigi.nix
    ./fonts.nix
    ./git.nix
    ./gpg.nix
    ./htop.nix
    ./init.nix
    ./keepassxc.nix
    ./kitty.nix
    ./mosh.nix
    ./nvim.nix
    ./ripgrep.nix
    ./ssh.nix
    ./st.nix
    ./sway.nix
    ./texlive.nix
    ./tmux.nix
    ./trash-cli.nix
    ./virt-manager.nix
    ./wget.nix
    ./xdg-utils.nix
    ./zip.nix
  ];
}
