{ config, pkgs, ... }:

{ 
    programs.git = {
        enable = true; 
        userEmail = "lawabidingcactus@lawabidingcactus.com";
        userName = "LawAbidingCactus";

        signing = {
            key = "${config.programs.gpg.settings.default-key}";
            signByDefault = true;
        };

        extraConfig.core.untrackedCache = true;
    };
}
