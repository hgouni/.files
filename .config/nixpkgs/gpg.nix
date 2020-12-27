{ config, pkgs, ... }:

{
    programs.gpg = {
        enable = true;
        
        settings = {
            auto-key-locate = "local,wkd,dane,cert";
            require-secmem = true;
            default-key = "09396E67CCFD945008A4C4B491403AC0BF58F1C6";
            default-recipient-self = true;
        };
    };

    home.packages = with pkgs; [ pinentry ];
}
