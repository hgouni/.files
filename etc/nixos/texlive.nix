{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.texlive.combined.scheme-full
  ];

  home.file.".latexmkrc".text = ''
    $pdf_mode = 4;
  '';
}
