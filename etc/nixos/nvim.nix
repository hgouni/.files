{ config, pkgs, ... }:

{

  programs.neovim = {

    enable = true; 

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-fennel
        plugins.tree-sitter-gleam
        plugins.tree-sitter-haskell
        plugins.tree-sitter-latex
        plugins.tree-sitter-markdown
        plugins.tree-sitter-python
        plugins.tree-sitter-racket
        plugins.tree-sitter-rust
      ]))
      pkgs.vimPlugins.conjure
      pkgs.vimPlugins.Coqtail
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.lean-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.parinfer-rust
      pkgs.vimPlugins.slimv
      pkgs.vimPlugins.supertab
      pkgs.vimPlugins.undotree
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vim-fish
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-racket
      pkgs.vimPlugins.vim-repeat
      pkgs.vimPlugins.vim-surround
    ];

    extraPackages = [
      pkgs.fzf
      pkgs.shellcheck
      pkgs.texlab
      pkgs.tectonic
    ];

    withPython3 = true;

    extraLuaConfig = ''vim.cmd.source("$HOME/.config/nvim/config.lua")'';
  };

  home.packages = [ pkgs.luajitPackages.fennel pkgs.fnlfmt pkgs.myAntifennel ];
}
