{ config, pkgs, ... }:

{
  programs.neovim = {

    enable = true; 

    plugins = with pkgs.vimPlugins; [
      idris-vim
      vim-sneak
      gruvbox
      supertab
      undotree
      fzf-vim
      vim-commentary
      vim-surround
      vim-repeat
      vim-fish
      vimwiki
      vim-fugitive
      rust-vim
      vim-nix
      nvim-lspconfig
      Coqtail
      vim-racket
      slimv
    ];

    extraPackages = with pkgs; [ fzf ctags shellcheck ];

    withPython3 = true;

    extraConfig = builtins.readFile ./files/nvim/init.vim;
  };
}
