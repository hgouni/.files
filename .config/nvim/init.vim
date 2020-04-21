" autoinstall plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" dependencies:
" generic:
" - python for neovim? (pip3 install --user --upgrade pynvim)
" - universal-ctags (pull from git repo, build and install in $PATH)
" - ripgrep (sudo dnf install ripgrep)
" language-specific:
" rust:
" - rust (curl https://sh.rustup.rs -sSf | sh)
" - rls (rustup component add rls rust-analysis rust-src)
" - rustfmt (rustup component add rustfmt)
" racket/sicp:
" - download racket from racket-lang.org
" haskell:
" - hie
" - install stack then follow source install instructions on github
" - install hfmt and all of hfmt fixers

call plug#begin()

Plug 'idris-hackers/idris-vim'

Plug 'justinmk/vim-sneak'

Plug 'morhetz/gruvbox'

Plug 'dense-analysis/ale'

Plug 'vim-airline/vim-airline'

Plug 'ervandew/supertab'

Plug 'mbbill/undotree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-repeat'

Plug 'dag/vim-fish'

Plug 'vimwiki/vimwiki'

Plug 'junegunn/rainbow_parentheses.vim'

Plug 'wlangstroth/vim-racket'

Plug 'airblade/vim-gitgutter'

Plug 'majutsushi/tagbar'

Plug 'tpope/vim-fugitive'

Plug 'rust-lang/rust.vim'

Plug 'neovimhaskell/haskell-vim'

Plug 'https://framagit.org/tyreunom/coquille.git', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" note: there's no need to create an alternative escape-- alt+space will
" already do this (alt+char creates terminal escape code that executes
" <esc> + <char>)

" disable modelines (security)
set nomodeline

" leader key
let mapleader = " "

" localleader key; '\\' must be used because '\' functions as escape char
let maplocalleader = "\\"

" line numbers
set number

" scroll context (note that for set <var>=<mode>, there must be not be spaces on
" either side of the equal sign)
set scrolloff=5

" move preview window to bottom (less intrusive)
set splitbelow

" make cursor more visible
set cursorline

" less annoying write behavior (no more write errors on switching buffers,
" among others)
set autowriteall

" tab settings
set expandtab
set tabstop=4
set shiftwidth=4

" toggle paste mode
nnoremap <silent><leader>p :set paste!<CR>

" toggle highlighting for searches
nnoremap <silent><leader>/ :set hlsearch!<CR>

" special symbols
inoremap \forall ∀
inoremap \to →
inoremap \lambda λ
inoremap \Sigma Σ
inoremap \exists ∃
inoremap \equiv ≡

" esc returns to normal in terminal
" note: use alt + j or something similar to switch to normal mode in fish
tnoremap <Esc> <C-\><C-n>

" write files opened without sufficient permission
cnoremap w!! w !sudo tee > /dev/null %

" last position jump
au BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" toggle terminal
let s:term_buf = 0
let s:term_win = 0

function! Term_toggle(height)
    if win_gotoid(s:term_win)
        hide
    else
        new terminal
        exec "resize ".a:height
        try
            exec "buffer ".s:term_buf
            exec "bd terminal"
        catch
            call termopen($SHELL, {"detach": 0})
            let s:term_buf = bufnr("")
            setlocal nocursorline " signcolumn=no
        endtry
        startinsert!
        let s:term_win = win_getid()
    endif
endfunction

nnoremap <silent><M-t> :call Term_toggle(10)<CR>
inoremap <silent><M-t> <ESC>:call Term_toggle(10)<CR>
tnoremap <silent><M-t> <C-\><C-n>:call Term_toggle(10)<CR>

" make vim functions that depend on CursorHoldI extremely responsive
" without destroying ssd with writes
set updatetime=0
set directory=/dev/shm/nvim_swap//

" use async job control to sync swapfiles to non-volatile storage
function! Fs_sync(timer_fs_sync)
    call jobstart('rsync -aq --delete "/dev/shm/nvim_swap/" "'.$HOME.'/.local/share/nvim/swap"')
endfunction

let timer_fs_sync = timer_start(1000, 'Fs_sync', {'repeat': -1})

" theming
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox

" persistent undo and undo tree config (not necessary to specify undodir)
set undofile
set undolevels=100000
let g:undotree_WindowLayout = 3
let g:undotree_ShortIndicators = 1
let g:undotree_HighlightChangedText = 0
let g:undotree_HelpLine = 0
let g:undotree_SetFocusWhenToggle = 1
nnoremap <silent><leader>u :UndotreeToggle<CR>

" enable jumping to hints
let g:sneak#label = 1

" ALE config
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_linters = {
    \ 'rust': ['rls'],
    \ 'haskell': ['hie'],
    \ }
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'rust': ['rustfmt'],
    \ 'haskell': ['hfmt'],
    \ }
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_haskell_hie_executable = 'hie-wrapper'
nnoremap <silent><leader>d :ALEDetail<CR>

" fzf config
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
nnoremap <silent><leader>ff :Files<CR>
nnoremap <silent><leader>fb :BLines<CR>
nnoremap <silent><leader>fl :Lines<CR>
nnoremap <silent><leader>ft :BTags<CR>
nnoremap <silent><leader>fp :Tags<CR>
nnoremap <silent><leader>fm :Marks<CR>
nnoremap <silent><leader>fc :Commands<CR>
nnoremap <silent><leader>fo :Buffers<CR>

" airline configuration
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.notexists = '!'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab

" tagbar config
nnoremap <silent><leader>t :TagbarToggle<CR>
let g:rust_use_custom_ctags_defs = 1  " if using rust.vim
let g:tagbar_type_rust = {
  \ 'ctagsbin' : $HOME.'/.local/bin/ctags',
  \ 'ctagstype' : 'rust',
  \ 'kinds' : [
      \ 'n:modules',
      \ 's:structures:1',
      \ 'i:interfaces',
      \ 'c:implementations',
      \ 'f:functions:1',
      \ 'g:enumerations:1',
      \ 't:type aliases:1:0',
      \ 'v:constants:1:0',
      \ 'M:macros:1',
      \ 'm:fields:1:0',
      \ 'e:enum variants:1:0',
      \ 'P:methods:1',
  \ ],
  \ 'sro': '::',
  \ 'kind2scope' : {
      \ 'n': 'module',
      \ 's': 'struct',
      \ 'i': 'interface',
      \ 'c': 'implementation',
      \ 'f': 'function',
      \ 'g': 'enum',
      \ 't': 'typedef',
      \ 'v': 'variable',
      \ 'M': 'macro',
      \ 'm': 'field',
      \ 'e': 'enumerator',
      \ 'P': 'method',
  \ },
\ }

" rainbow parenthesis config (for lisp)
augroup rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

" haskell-vim configuration
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_backpack = 1

" coq config
autocmd FileType coq setlocal commentstring=(*%s*) tabstop=2 shiftwidth=2
hi default SentToCoq ctermbg=8 guibg=DarkGray
hi default CheckedByCoq ctermbg=2 guibg=DarkGreen
hi default CoqErrorCommand ctermbg=4 guibg=DarkRed
nnoremap <silent><leader>cL :call CoqLaunch()<CR>
nnoremap <silent><leader>cS :call CoqStop()<CR>
nnoremap <silent><leader>cn :call CoqNext()<CR>
nnoremap <silent><leader>ce :call CoqCancel()<CR>
nnoremap <silent><leader>cj :call CoqToCursor()<CR>
nnoremap <silent><leader>cu :call CoqUndo()<CR>
nnoremap <silent><leader>cv :call CoqVersion()<CR>
nnoremap <silent><leader>cb :call CoqBuild()<CR>
nnoremap <silent><leader>cq :call CoqQuery(input('Query: '))<CR>
nnoremap <silent><leader>cc :call CoqCheck(input('Check: '))<CR>
nnoremap <silent><leader>cl :call CoqLocate(input('Locate: '))<CR>
nnoremap <silent><leader>cp :call CoqPrint(input('Print: '))<CR>
nnoremap <silent><leader>cs :call CoqSearch(input('Search: '))<CR>
nnoremap <silent><leader>ca :call CoqSearchAbout(input('Search About: '))<CR>
