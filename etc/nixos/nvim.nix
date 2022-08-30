{ config, pkgs, ... }:

{

  programs.neovim = {

    package = pkgs.myNeovim;

    enable = true; 

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-fennel
      ]))
      pkgs.vimPlugins.vim-surround
      pkgs.vimPlugins.vim-sneak
      pkgs.vimPlugins.vim-repeat
      pkgs.vimPlugins.vim-racket
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-fish
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.undotree
      pkgs.vimPlugins.supertab
      pkgs.vimPlugins.slimv
      pkgs.vimPlugins.rust-vim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.idris-vim
      pkgs.vimPlugins.gruvbox
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.Coqtail
      pkgs.vimPlugins.conjure
    ];

    extraPackages = [
      pkgs.fzf
      pkgs.shellcheck
      pkgs.texlab
      pkgs.tectonic
    ];

    withPython3 = true;

    extraConfig = builtins.readFile ./files/nvim/init.vim;
  };

  home.packages = [ pkgs.fennel ];
}
