{ config, pkgs, ... }:

let

  repl = pkgs.vimUtils.buildVimPlugin {
    name = "repl.vim";
    src = pkgs.fetchFromGitHub {
      owner = "hemantgouni";
      repo = "repl.vim";
      rev = "883a112f61d68848f58ebfc36bd61d53cac700ff";
      sha256 = "12y7dc1n3hfmbnsb5g0p6mkxy3jn0pv5n38gc1smq7n7ilm449kr";
    };
  };

in {

  programs.neovim = {

    package = pkgs.myNeovim;

    enable = true; 

    plugins = [
      repl
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
    ];

    withPython3 = true;

    extraConfig = builtins.readFile ./files/nvim/init.vim;
  };

  home.packages = [ pkgs.fennel ];
}
