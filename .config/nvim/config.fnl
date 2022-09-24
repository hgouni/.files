(local std (require :std))

(local tree-sitter (require :nvim-treesitter.configs))

; TENTATIVE editor config in fennel

; note that vim.filetype.add can be used to replace ftdetect
; (and also ftplugin actually)

((. (require :nvim-treesitter.configs) :setup) {
    :highlight {
        :enable true
        :additional_vim_regex_highlighting false
    }
})

(std.set-options {
  "shell" "sh"
  "modeline" false
  "splitbelow" true
  "cursorline" true
  "autowriteall" true
  "expandtab" true
  "tabstop" 4
  "shiftwidth" 4
  "scrolloff" 5
  "hlsearch" false })

; attempt setting leader keys
(std.set-global-vars {
  "mapleader" " "
  "maplocalleader" "," })

; <leader> does not work?
(std.set-leader-maps { "p" "<Cmd>set paste!" })

; we have to escape the string here...
; this lets us press "ESC" to exit to normal mode in a terminal
; (vim.api.nvim_set_keymap "t" "<Esc>" "<C-\\><C-n>" { "noremap" true })

(std.set-options {
  "termguicolors" true
  "background" "dark" })
(vim.cmd "colorscheme gruvbox")

; undo config
(std.set-options {
  "undofile" true
  "undolevels" 10000 })

(std.set-global-vars { 
  "undotree_WindowLayout" 3
  "undotree_ShortIndicators" 1
  "undotree_HighlightChangedText" 0
  "undotree_HelpLine" 0
  "undotree_SetFocusWhenToggle" 1 })

(std.set-leader-maps { "u" "<Cmd>UndotreeToggle" })

(std.set-global-vars { "sneak#label" 1 })

(std.set-leader-maps {
  "ff" "<Cmd>Files"
  "fb" "<Cmd>BLines"
  "fl" "<Cmd>Lines"
  "ft" "<Cmd>BTags"
  "fp" "<Cmd>Tags"
  "fm" "<Cmd>Marks"
  "fc" "<Cmd>Commands"
  "fo" "<Cmd>Buffers" })
    
; this will still remove buffers if it will close a tab other than
; one we are currently on. maybe it shouldn't
(set _G.delete_current_buffer
  (fn []
    ; vim.fn.<vimscript_function> invokes that vimscript function
    (let [current-buffer-identifier (std.a.nvim-get-current-buf)
          scratch-buffer-identifier (std.a.nvim-create-buf false true)
          current-window-identifier (std.a.nvim-get-current-win)]
      (std.a.nvim-command "silent! w")
      (std.a.nvim-win-set-buf current-window-identifier scratch-buffer-identifier)
      (std.a.nvim-buf-set-lines scratch-buffer-identifier
                            ; the last parameter here is a lua array
                            ; we may also be able to use [ "Edit another file!" ]?
                            0 0 true { 1 "Edit another file!" })
      (std.a.nvim-buf-set-option current-buffer-identifier "buflisted" false)   
      (std.a.nvim-buf-delete current-buffer-identifier { "force" true "unload" true }))))

(std.set-leader-maps {
  "dh" "<Cmd>tabclose"
  "dj" "<Cmd>tabprev"
  "dk" "<Cmd>tabnext"
  "dl" "<Cmd>tabnew" 
  "dx" _G.delete_current_buffer
  "dd" "<Cmd>b#"
  "d;" "<Cmd>tabnew<bar>terminal" })

(std.set-global-vars {
  "lisp_rainbow" 1
  "slimv_disable_scheme" 1
  "slimv_disable_clojure" 1 })

(std.set-global-vars {
  "conjure#mapping#prefix" "\\"
  "conjure#mapping#doc_word" false
  "conjure#filetypes" [ "fennel" "racket" "scheme" ]
  "conjure#client#scheme#stdio#command" "scheme"
  "conjure#client#scheme#stdio#prompt_pattern" "> $"
  "conjure#client#scheme#stdio#value_prefix_pattern" false })

(lua
"
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<LocalLeader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<LocalLeader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<LocalLeader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<LocalLeader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<LocalLeader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<LocalLeader>f', vim.lsp.buf.formatting, bufopts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'metals', 'ocamllsp', 'rust_analyzer', 'hls' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
  }
end

-- Stop racket langserver from triggering on scheme
require('lspconfig').racket_langserver.setup {
  on_attach = on_attach,
  filetypes = { 'racket' }
}

require('lspconfig').texlab.setup {
    on_attach = on_attach,
    settings = {
        texlab = {
            build = {
                args = {},
                onSave = true
            },
            chktex = {
                onOpenAndSave = true
            }
        }
    }
}
")
