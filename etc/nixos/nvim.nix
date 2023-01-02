{ config, pkgs, ... }:

{

  programs.neovim = {

    package = pkgs.myNeovim;

    enable = true; 

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-fennel
        plugins.tree-sitter-gleam
        plugins.tree-sitter-haskell
        plugins.tree-sitter-latex
        plugins.tree-sitter-rust
        plugins.tree-sitter-racket
        plugins.tree-sitter-python
      ]))
      pkgs.vimPlugins.conjure
      pkgs.vimPlugins.Coqtail
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.lean-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.parinfer-rust
      pkgs.vimPlugins.rust-vim
      pkgs.vimPlugins.slimv
      pkgs.vimPlugins.supertab
      pkgs.vimPlugins.undotree
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vim-fish
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-racket
      pkgs.vimPlugins.vim-repeat
      pkgs.vimPlugins.vim-sneak
      pkgs.vimPlugins.vim-surround
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

  home.packages = [ pkgs.fennel pkgs.fnlfmt ];
}
