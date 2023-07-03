{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "update" (builtins.readFile ./files/scripts/update.sh))
    (pkgs.writeShellScriptBin "compile-nvim-conf" (builtins.readFile ./files/scripts/compile-nvim-conf.sh))
    (pkgs.writeShellScriptBin "sync-dots" (builtins.readFile ./files/scripts/sync-dots.sh))
  ];
}
