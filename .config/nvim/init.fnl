; A few tips:
;
; 1. c_Ctrl-R " is the keybind to paste text from register "
;
; 2. FileType: buffer-local ONLY (filetype is set once per buffer)
;    BufEnter: each time cursor enters a buffer
;
; 3. vim.fn.<vimscript_function> invokes that vimscript function

(local std (require :std))
(local tree-sitter (require :nvim-treesitter.configs))
(local lspconfig (require :lspconfig))
(local lean (require :lean))

; replaces ftdetect
(vim.filetype.add {:extension {:sv :silver}})
(vim.filetype.add {:extension {:mcr :macaroni}})

(std.set-global-vars {:mapleader " " :maplocalleader ","})

(std.set-options {:shada "!,'100,<0,s10,h" ; turn off saving register contents
                  :modeline false
                  :splitbelow true
                  :cursorline true
                  :autowriteall true
                  :expandtab true
                  :tabstop 4
                  :shiftwidth 4
                  :scrolloff 5
                  :hlsearch false})

; why does this work? this has remaps turned off
(std.set-key-maps :i {:<C-l> :<C-x><C-o>} {:silent true})

; no preview window for completions
(std.set-options {:completeopt :menu})

(local enter-forgetful-mode
       (fn []
         (std.set-options {:shadafile :NONE :undofile false :swapfile false})
         (print "ShaDa, undo history, and swap files have been disabled.")))

(std.a.nvim-create-autocmd [:BufEnter]
  {:group (std.a.nvim-create-augroup :SecureModeAucmds {})
   :pattern [:/tmp/bash-fc.* :/var/tmp/*]
   :callback enter-forgetful-mode})
       
(std.set-leader-maps {:q enter-forgetful-mode})

(local get-clipboard
  (fn []
    (let [primary (vim.fn.getreg "*")
          clipboard (vim.fn.getreg "+")
          unsplit-string (.. "PRIMARY:\n\n"
                             (if (std.str-is-empty primary) "<empty>" primary)
                             "\n\n"
                             "CLIPBOARD:\n\n"
                             (if (std.str-is-empty clipboard) "<empty>" clipboard))
          contents (vim.split unsplit-string "\n")
          buf (std.a.nvim-create-buf false true)]
      (std.a.nvim-buf-set-lines buf 0 -1 true contents)
      (std.open-centered-window buf 0.7 0.7 "Clipboard")
      (std.set-key-maps :n {:<Esc> (fn [] (std.a.nvim-buf-delete 0 {}))}
                           {:silent true :buffer buf}))))

(local clear-clipboard
  (fn []
    (vim.fn.setreg "*" "")
    (vim.fn.setreg "+" "")
    (print "PRIMARY and CLIPBOARD cleared.")))

(std.set-leader-maps {:w get-clipboard :e clear-clipboard})

; this will still remove buffers if it will close a tab other than
; one we are currently on. maybe it shouldn't
(local delete-current-buffer
  (fn []
    (let [current-buffer-identifier (std.a.nvim-get-current-buf)
          scratch-buffer-identifier (std.a.nvim-create-buf false true)
          current-window-identifier (std.a.nvim-get-current-win)]
      (std.a.nvim-command "silent! w")
      (std.a.nvim-win-set-buf current-window-identifier scratch-buffer-identifier)
      ; final parameter here is a lua array (previously: {1 "Edit another file!"})
      (std.a.nvim-buf-set-lines scratch-buffer-identifier 0 0 true ["Edit another file!"])
      (std.a.nvim-buf-set-option current-buffer-identifier :buflisted false)
      (std.a.nvim-buf-delete current-buffer-identifier {:force true :unload true}))))

(std.set-leader-maps {:dj :<Cmd>tabclose
                      :dk "<Cmd>tab split"
                      :dx delete-current-buffer
                      :dd "<Cmd>b#"
                      :dl :<Cmd>tabnew<bar>terminal})

(std.set-key-maps :n {:<C-j> :<Cmd>tabprev
                      :<C-k> :<Cmd>tabnext}
                     {:silent true})

; have to add <CR> explicitly for :t and :i bc it's a terminal mode map, and
; set-key-maps won't automatically take care of that here (:t and :i bindings
; shouldn't always have <CR>, this is just needed because we're escaping to
; command mode)

(std.set-key-maps :t {:<C-j> :<C-\><C-n><Cmd>tabprev<CR>
                      :<C-k> :<C-\><C-n><Cmd>tabnext<CR>}
                     {:silent true})

(std.set-key-maps :i {:<C-j> :<Esc><Cmd>tabprev<CR>
                      :<C-k> :<Esc><Cmd>tabnext<CR>}
                     {:silent true})

; suppress :healthcheck warning about perl provider
(std.set-global-vars {:loaded_perl_provider 0})

(std.set-options {:termguicolors true :background :dark})

(vim.cmd.colorscheme :gruvbox)

; undo config
(std.set-options {:undofile true :undolevels 10000})

(std.set-global-vars {:undotree_WindowLayout 3
                      :undotree_ShortIndicators 1
                      :undotree_HighlightChangedText 0
                      :undotree_HelpLine 0
                      :undotree_SetFocusWhenToggle 1})

(std.set-leader-maps {:u :<Cmd>UndotreeToggle})

; fzf config
(std.set-leader-maps {:ff :<Cmd>Files
                      :fb :<Cmd>BLines
                      :fl :<Cmd>Lines
                      :ft :<Cmd>BTags
                      :fp :<Cmd>Tags
                      :fm :<Cmd>Marks
                      :fc :<Cmd>Commands
                      :fo :<Cmd>Buffers})

; insert the lozenge character, for pollen
(std.set-key-maps :i {"\\loz" :<C-v>u25ca}
                     {:silent true})

(std.set-global-vars {:lisp_rainbow 1
                      :slimv_disable_scheme 1
                      :slimv_disable_clojure 1
                      :paredit_mode 0})

(std.set-global-vars {"conjure#mapping#prefix" "\\"
                      "conjure#mapping#doc_word" false
                      "conjure#mapping#def_word" false
                      "conjure#highlight#enabled" true
                      "conjure#filetypes" [:fennel :racket :scheme]})

(std.a.nvim-create-autocmd [:BufNewFile]
                           {:group (std.a.nvim-create-augroup :MyConjureAucmds {})
                            :pattern [:conjure-log-*]
                            :callback (fn [] (vim.diagnostic.disable 0))})

(tree-sitter.setup {:highlight {:enable true :additional_vim_regex_highlighting false}})

(lean.setup {:abbreviations {:builtin true} :mappings true})

; pairs, ipairs generate index, value
; ipairs is guaranteed to iterate sequentially
(each [_ server (ipairs [:rust_analyzer :metals :hls])]
  ((. lspconfig server :setup) {}))

(lspconfig.racket_langserver.setup {:filetypes [:racket]})
(lspconfig.texlab.setup {:settings {:texlab {:build {:args {} :onSave true}}}})

; Mappings.
; See `:help vim.diagnostic.*` for documentation on any of the below functions
(vim.keymap.set :n :<LocalLeader>e vim.diagnostic.open_float)
(vim.keymap.set :n "[d" vim.diagnostic.goto_prev)
(vim.keymap.set :n "]d" vim.diagnostic.goto_next)
(vim.keymap.set :n :<LocalLeader>q vim.diagnostic.setloclist)

(std.a.nvim-create-autocmd :LspAttach
    {:group (std.a.nvim-create-augroup :UserLspConfig {})
     :callback (fn [ev]
                 (tset (. vim.bo ev.buf) :omnifunc "v:lua.vim.lsp.omnifunc")
                 (local opts {:buffer ev.buf})
                 (vim.keymap.set :n :gD vim.lsp.buf.declaration opts)
                 (vim.keymap.set :n :gd vim.lsp.buf.definition opts)
                 (vim.keymap.set :n :K vim.lsp.buf.hover opts)
                 (vim.keymap.set :n :gi vim.lsp.buf.implementation opts)
                 (vim.keymap.set :n :gs vim.lsp.buf.signature_help opts)
                 (vim.keymap.set :n :<LocalLeader>wa vim.lsp.buf.add_workspace_folder opts)
                 (vim.keymap.set :n :<LocalLeader>wr vim.lsp.buf.remove_workspace_folder opts)
                 (vim.keymap.set :n :<LocalLeader>wl
                      (fn [] (print (vim.inspect (vim.lsp.buf.list_workspace_folders))) opts))
                 (vim.keymap.set :n :<LocalLeader>D vim.lsp.buf.type_definition opts)
                 (vim.keymap.set :n :<LocalLeader>rn vim.lsp.buf.rename opts)
                 (vim.keymap.set :n :<LocalLeader>ca vim.lsp.buf.code_action opts)
                 (vim.keymap.set :n :gr vim.lsp.buf.references opts)
                 (vim.keymap.set :n :<LocalLeader>f
                      (fn [] (vim.lsp.buf.format { :async true })) opts))})
