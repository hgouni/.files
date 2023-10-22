{ config, pkgs, ... }:

{
  home.sessionVariables = {
    VISUAL = "nvim"; # see scripts.nix
    EDITOR = "${config.home.sessionVariables.VISUAL}";
    MANPAGER = "nvim +Man!";
    FZF_DEFAULT_COMMAND = "rg --files --hidden --follow";
    FZF_DEFAULT_OPTS = "--bind alt-j:down,alt-k:up";
  };

  programs.neovim = {

    enable = true;

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
        plugins.bash
        plugins.c
        plugins.css
        plugins.fennel
        plugins.gleam
        plugins.haskell
        plugins.html
        plugins.latex
        plugins.lua
        plugins.markdown
        plugins.nix
        plugins.ocaml
        plugins.python
        plugins.racket
        plugins.rust
      ]))
      pkgs.vimPlugins.conjure
      pkgs.vimPlugins.Coqtail
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.lean-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.parinfer-rust
      pkgs.vimPlugins.supertab
      pkgs.vimPlugins.undotree
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vim-fugitive
      # Would rather use nvim-treesitter for language-aware structure edits of
      # this sort
      # pkgs.vimPlugins.vim-repeat
      # pkgs.vimPlugins.vim-surround
    ];

    extraPackages = [
      pkgs.fzf
      pkgs.shellcheck
      pkgs.texlab
    ];

    withPython3 = true;
  };

  home.packages = [
    pkgs.myFennel
    pkgs.fnlfmt
    pkgs.myAntifennel
  ];
}
