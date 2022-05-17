{ config, pkgs, ... }:

{

  home.packages = [
    (pkgs.writeShellScriptBin "rash" ''
      racket -l rash/repl
    '')
    pkgs.racket
    ];

  }
