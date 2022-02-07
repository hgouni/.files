set shell=sh

" note: there's no need to create an alternative escape-- alt+space will
" already do this (alt+char creates terminal escape code that executes
" <esc> + <char>)

" disable modelines (security)
set nomodeline

" leader key
let mapleader = " "

" localleader key
let maplocalleader = ","

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
set hlsearch!
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
let g:term_buffer = -1
let g:term_window = -1

function! Term_toggle()
    " if a window containing the terminal buffer
    " exists, remove it
    if win_gotoid(g:term_window)
        " hide does not 'hide' the window; it
        " quits it without deleting the buffer
        hide
    else
        " make a new split window, and a new buffer in it
        " analogous to `split <bar> enew`
        "
        " this buffer is named so we can remove it later,
        " and avoid leaking buffers (shown in :buffers! or
        " ls!)
        new terminal
        " attempt to switch to the terminal buffer
        " inside the split
        try
            " switch to the terminal buffer,
            " if there is one
            execute "buffer ".g:term_buffer
            " remove the unneeded buffer here
            bd terminal
        " if it does not exist, make a new terminal buffer
        catch
            let g:term_buffer = bufnr()
            call termopen($SHELL)
            setlocal nocursorline
        endtry
        " record the new window identifier
        let g:term_window = win_getid()
        " enter insert mode
        startinsert!
    endif
endfunction

nnoremap <silent><M-t> :call Term_toggle()<CR>
inoremap <silent><M-t> <ESC>:call Term_toggle()<CR>
tnoremap <silent><M-t> <C-\><C-n>:call Term_toggle()<CR>

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'metals', 'racket_langserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
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

let g:lisp_rainbow = 1
let g:slimv_disable_scheme = 1

function! g:CoqtailHighlight()
    hi def CoqtailSent ctermbg=8 guibg=DarkBlue
    hi def CoqtailChecked ctermbg=2 guibg=DarkGreen
endfunction
