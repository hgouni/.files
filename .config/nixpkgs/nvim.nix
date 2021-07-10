{ config, pkgs, ... }:

let

  slimv = pkgs.vimUtils.buildVimPlugin {
    name = "slimv";
    src = pkgs.fetchFromGitHub {
      owner = "kovisoft";
      repo = "slimv";
      rev = "de657dd6e124189143589a725ae85113c09eb053";
      sha256 = "18dg626m5iy5w2zz60qxvw06fxx7ridn8ibcy6k9yyqa01w1ybxs";
    };
  };

  nvim-metals = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-metals";
    src = pkgs.fetchFromGitHub {
      owner = "scalameta";
      repo = "nvim-metals";
      rev = "6773f9e8f7c8a105fc1abaa8979e5fd2ad5e6b27";
      sha256 = "0pch8c8psnly7pvpn8jd599p9zmxd5pa03fkghnzs3zggyilmxfv";
    };

    dontBuild = true;
};

in { 
    programs.neovim = {

        enable = true; 

        plugins = with pkgs.vimPlugins; [
            idris-vim
            vim-sneak
            gruvbox
            vim-airline
            supertab
            undotree
            fzf-vim
            vim-commentary
            vim-surround
            vim-repeat
            vim-fish
            vimwiki
            tagbar
            vim-fugitive
            rust-vim
            haskell-vim
            vim-nix
            nvim-lspconfig
            Coqtail
            vim-racket
            slimv
            nvim-metals
        ];

        extraPackages = with pkgs; [ fzf ctags shellcheck ];

        withPython3 = true;

        extraConfig = builtins.readFile ./files/nvim/init.vim;
    };
}
