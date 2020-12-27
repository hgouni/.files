{ config, pkgs, ... }:

{ 
    programs.htop = {
        enable = true; 
        delay = 5;
        treeView = true;
        vimMode = true;
    };
}
