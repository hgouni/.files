{ pkgs, ... }:

let
  writeFennelScriptBin = binary-name: script-path:
    (pkgs.stdenv.mkDerivation {
      name = binary-name;
      # since we don't define a source attribute, we're just directly
      # getting files as input
      #
      # will get an error otherwise
      dontUnpack = true;
      nativeBuildInputs = [
        pkgs.fennel
      ];
      buildInputs = [
        pkgs.luajit
      ];
      installPhase = ''
        printf '#!/usr/bin/env lua\n' > tmp.lua
        fennel --compile ${script-path} >> tmp.lua
        chmod +x tmp.lua
        mkdir -p $out/bin
        mv tmp.lua $out/bin/${binary-name}
      '';
    });
in
{
  home.packages = [
    (pkgs.writeShellScriptBin
      "update"
      (builtins.readFile ./files/scripts/update.sh))
    (pkgs.writeShellScriptBin
      "compile-nvim-conf"
      (builtins.readFile ./files/scripts/compile-nvim-conf.sh))
    (pkgs.writeShellScriptBin
      "sync-dots"
      (builtins.readFile ./files/scripts/sync-dots.sh))
    (writeFennelScriptBin "nvimr" ./files/scripts/nvim-remote.fnl)
  ];
}
