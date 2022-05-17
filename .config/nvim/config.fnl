; TENTATIVE editor config in fennel

; Setup boilerplate to allow us to use the vim and neovim apis with a lispy
; naming scheme ("-" as separator instead of "_")

(local v {})

(setmetatable v
  {:__index
   (fn [tbl key]
     (. vim.fn (vim.fn.substitute key "-" "_" "g")))})

(fn compute-lookup-table-for-api []
  (let [api-functions (. (v.api-info) :functions)
        generated-lookup-table {}]
    (each [_ value (ipairs api-functions)]
      (let [actual-api-function (. vim.api (. value :name))
            generated-function-name
              (vim.fn.substitute (. value :name) "_" "-" "g")]
        (tset generated-lookup-table
              generated-function-name
              actual-api-function)))
    generated-lookup-table))

(local a (compute-lookup-table-for-api))

(fn set-options [options]
 (each [key value (pairs options)]
   (tset vim.opt key value)))

(fn set-global-vars [vars]
 (each [key value (pairs vars)]
  (a.nvim-set-var key value)))

(fn set-leader-maps [maps]
 (each [key value (pairs maps)]
  (a.nvim-set-keymap "n" (.. "<Leader>" key) (.. value "<CR>")
   { "noremap" true "silent" true })))

(set-options {
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
(set-global-vars {
  "mapleader" " "
  "maplocalleader" "," })

(set-leader-maps { "lr" "<Cmd>echo system(['lualatex', expand('%')])" })

; <leader> does not work?
(set-leader-maps { "p" "<Cmd>set paste!" })

; we have to escape the string here...
; this lets us press "ESC" to exit to normal mode in a terminal
(vim.api.nvim_set_keymap "t" "<Esc>" "<C-\\><C-n>" { "noremap" true })

; set colorscheme
(set-options {
  "termguicolors" true
  "background" "dark" })
(vim.cmd "colorscheme gruvbox")

; undo config
(set-options {
  "undofile" true
  "undolevels" 10000 })

(set-global-vars { 
  "undotree_WindowLayout" 3
  "undotree_ShortIndicators" 1
  "undotree_HighlightChangedText" 0
  "undotree_HelpLine" 0
  "undotree_SetFocusWhenToggle" 1 })

(set-leader-maps { "u" "<Cmd>UndotreeToggle" })

(set-global-vars { "sneak#label" 1 })

(set-leader-maps {
  "ff" "<Cmd>Files"
  "fb" "<Cmd>BLines"
  "fl" "<Cmd>Lines"
  "ft" "<Cmd>BTags"
  "fp" "<Cmd>Tags"
  "fm" "<Cmd>Marks"
  "fc" "<Cmd>Commands"
  "fo" "<Cmd>Buffers" })

(set-global-vars {
  "lisp_rainbow" 1
  "slimv_disable_scheme" 1 })
    
; this will still remove buffers if it will close a tab other than
; one we are currently on. maybe it shouldn't
(set _G.delete_current_buffer
  (fn []
    ; vim.fn.<vimscript_function> invokes that vimscript function
    (let [current-buffer-identifier (a.nvim-get-current-buf)
          scratch-buffer-identifier (a.nvim-create-buf false true)
          current-window-identifier (a.nvim-get-current-win)]
      (a.nvim-command "silent! w")
      (a.nvim-win-set-buf current-window-identifier scratch-buffer-identifier)
      (a.nvim-buf-set-lines scratch-buffer-identifier
                            ; the last parameter here is a lua array
                            ; we may also be able to use [ "Edit another file!" ]?
                            0 0 true { 1 "Edit another file!" })
      (a.nvim-buf-set-option current-buffer-identifier "buflisted" false)   
      (a.nvim-buf-delete current-buffer-identifier { "force" true "unload" true }))))

(set-leader-maps {
  "dh" "<Cmd>tabclose"
  "dj" "<Cmd>tabprev"
  "dk" "<Cmd>tabnext"
  "dl" "<Cmd>tabnew" 
  "dx" "<Cmd>lua _G.delete_current_buffer()"
  "dd" "<Cmd>b#"
  "d;" "<Cmd>tabnew<bar>terminal" })

(set-global-vars {
  "conjure#client#scheme#stdio#command" "scheme"
  "conjure#client#scheme#stdio#prompt_pattern" "> $"
  "conjure#client#scheme#stdio#value_prefix_pattern" false })

(lua
"
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<LocalLeader>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<LocalLeader>q', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<LocalLeader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<LocalLeader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<LocalLeader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<LocalLeader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<LocalLeader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<LocalLeader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<LocalLeader>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'metals' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

-- Stop racket langserver from triggering on scheme
require('lspconfig').racket_langserver.setup {
  on_attach = on_attach,
  filetypes = { 'racket' }
}

require ('lspconfig').texlab.setup {
    on_attach = on_attach,
    settings = {
        texlab = {
            build = {
                args = {},
                onSave = true
            },
            chktex = {
                onEdit = true,
                onOpenAndSave = true
            }
        }
    }
}
")
