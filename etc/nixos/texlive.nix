{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.texlive.combined.scheme-full
  ];

  # pdf_mode = 4 sets lualatex as the default latex implementation
  home.file.".latexmkrc".text = ''
    $pdf_mode = 4;
  '';
}
