{ config, pkgs, ... }:

{
    programs.gpg = {
        enable = true;

        homedir = "${config.xdg.configHome}/gnupg";
        
        settings = {
            auto-key-locate = "local,wkd,dane,cert";
            require-secmem = true;
            default-key = "8629B25BFA11A26204D26AA3E85A7E78DFFC7A6D";
            default-recipient-self = true;
        };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = [ "A27FCD00DCB492A1EEB17641C36BF732757A8185" ];
    };

    home.packages = with pkgs; [ pinentry ];
}
