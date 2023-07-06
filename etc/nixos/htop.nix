{ config, pkgs, ... }:

{
  programs.htop = {
    enable = true;
    settings = {
      delay = 5;
      tree_view = true;
      vim_mode = true;
    };
  };
}
