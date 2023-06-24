{ config, pkgs, ... }:

{ 
    programs.git = {
        enable = true; 
        userEmail = "me@hgouni.com";
        userName = "Hemant Sai Gouni";

        extraConfig = {
            core.untrackedCache = true;
            commit.gpgsign = true;
            tag.gpgsign = true;
            gpg.format = "ssh";
            user.signingkey = "/etc/nixos/files/ssh/id_ed25519_sk.pub";
        };
    };
}
