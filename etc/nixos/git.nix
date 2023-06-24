{ config, pkgs, ... }:

{ 
    programs.git = {
        enable = true; 
        userEmail = "me@hgouni.com";
        userName = "Hemant Sai Gouni";

        # signing = {
            # key = "${config.programs.gpg.settings.default-key}";
            # signByDefault = true;
        # };

        extraConfig = {
            core.untrackedCache = true;
            gpg.format = "ssh";
            user.signingkey = "/home/lawabidingcactus/.ssh/id_ed25519_sk.pub";
        };
    };
}
