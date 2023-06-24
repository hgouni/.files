{ config, pkgs, ... }:

{
    programs.gpg = {
        # enable = true;

        homedir = "${config.xdg.configHome}/gnupg";
        
        settings = {
            auto-key-locate = "local,wkd,dane,cert";
            require-secmem = true;
            default-key = "B5FD4599E4CEAEFEAE93C44F5DBDC4A0CDC714EF";
            default-recipient-self = true;
        };
    };

    services.gpg-agent = {
      # enable = true;
      enableSshSupport = true;
      sshKeys = [ "7747E7EA1B99F47C47FC00964840347D9B3DB009" ];
    };

    home.packages = with pkgs; [ pinentry ];
}
