set shell=sh

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

" move preview window to bottom (less intrusive)
set splitbelow

" make cursor more visible
set cursorline

" less annoying write behavior (no more write errors on switching buffers,
" among others)
set autowriteall

" make macros execute faster
set lazyredraw

" tab settings
set expandtab
set tabstop=4
set shiftwidth=4

" scroll context (note that for set <var>=<mode>, there must be not be spaces on
" either side of the equal sign)
set scrolloff=5

set foldmethod=syntax
set foldlevel=1
set nofoldenable

augroup autofold_conf
    autocmd!
    autocmd FileType git set foldenable foldlevel=0
augroup END

" consistent behavior
nnoremap Y y$

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
cnoreabbrev w!! w !sudo tee > /dev/null %

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
" without constantly writing to disk
set updatetime=0
set directory=/dev/shm/nvim_swap//

" use async job control to sync swapfiles to non-volatile storage
function! Fs_sync(timer_fs_sync)
    call jobstart(['rsync', '-aq', '--delete', '/dev/shm/nvim_swap/', ''.$HOME.'/.local/share/nvim/swap'])
endfunction

let timer_fs_sync = timer_start(1000, 'Fs_sync', {'repeat': -1})

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#7c6f64
      hi LspReferenceText cterm=bold ctermbg=red guibg=#7c6f64
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#7c6f64
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "hls", "r_language_server" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

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
let g:airline#extensions#hunks#enabled = 0
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

function! g:CoqtailHighlight()
    hi def CoqtailSent ctermbg=8 guibg=DarkBlue
    hi def CoqtailChecked ctermbg=2 guibg=DarkGreen
endfunction
