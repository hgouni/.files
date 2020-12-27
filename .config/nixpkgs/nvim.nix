{ config, pkgs, ... }:

{ 
    programs.neovim = {

        enable = true; 

        plugins = with pkgs.vimPlugins; [
            idris-vim
            vim-sneak
            gruvbox
            ale
            vim-airline
            supertab
            undotree
            fzf-vim
            vim-commentary
            vim-surround
            vim-repeat
            vim-fish
            vimwiki
            rainbow_parentheses-vim
            vim-gitgutter
            tagbar
            vim-fugitive
            rust-vim
            haskell-vim
            vim-nix
            # Coqtail
            # vim-racket
        ];

        extraPackages = with pkgs; [ fzf ctags shellcheck ];

        withPython3 = true;

        extraConfig = builtins.readFile ./files/nvim/init.vim;
    };
}
