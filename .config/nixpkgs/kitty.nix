{ config, pkgs, ... }:

{
    programs.kitty = {
        enable = true;
        settings = {
            disable_ligatures = "cursor";
            cursor_blink_interval = 0;
            scrollback_lines = 0;
            mouse_hide_wait = -1;
            input_delay = 1;
            enable_audio_bell = false;
            detect_urls = false;
            allow_hyperlinks = false;
            placement_strategy = "top-left";
            update_check_interval = 0;
            box_drawing_scale = "0.0005, 0.5, 0.75, 1";

            cursor = "#ebdbb2";
            foreground = "#ebdbb2";
            background = "#282828";
            selection_foreground = "#282828";
            selection_background = "#ebdbb2";
			
			color0 = "#282828";
            color1 = "#cc241d";
            color2 = "#98971a";
            color3 = "#d79921";
            color4 = "#458588";
            color5 = "#b16286";
            color6 = "#689d6a";
            color7 = "#a89984";
            color8  = "#928374";
            color9  = "#fb4934";
            color10 = "#b8bb26";
            color11 = "#fabd2f";
            color12 = "#83a598";
            color13 = "#d3869b";
            color14 = "#8ec07c";
            color15 = "#ebdbb2";
        };
    };
}
