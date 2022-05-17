{ config, pkgs, ... }:

{
  programs.foot.enable = true;

  programs.foot.settings = {

    main = {
      font = "Liberation Mono:size=7";
      pad = "0x0";
    };

    mouse.hide-when-typing = "yes";

    colors = {

      foreground = "ebdbb2";
      background = "282828";

      regular0 = "282828";
      regular1 = "cc241d";
      regular2 = "98971a";
      regular3 = "d7991a";
      regular4 = "458588";
      regular5 = "b16286";
      regular6 = "698d6a";
      regular7 = "a89984";

      bright0 = "928374";
      bright1 = "fb4934";
      bright2 = "b8bb26";
      bright3 = "fabd2f";
      bright4 = "83a598";
      bright5 = "d3869b";
      bright6 = "8ec07c";
      bright7 = "ebdbb2";
    };
  };

}

