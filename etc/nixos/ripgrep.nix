{ config, pkgs, ... }:

{
  home.packages = [ pkgs.ripgrep ];

  home.sessionVariables.RIPGREP_CONFIG_PATH = "${config.home.homeDirectory}/.config/ripgrep/.ripgreprc";

  home.file.".config/ripgrep/.ripgreprc".text = ''
    --glob=!.cache
    --glob=!.files
    --glob=!.local
    --glob=!.nix-defexpr
    --glob=!Trash
  '';
}
