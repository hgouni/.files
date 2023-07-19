; A few tips:
;
; 1. c_Ctrl-R " is the keybind to paste text from register "
;
; 2. FileType: buffer-local ONLY (filetype is set once per buffer)
;    BufEnter: each time cursor enters a buffer
;
; 3. vim.fn.<vimscript_function> invokes that vimscript function
;
; 4. V starts linewise insert, C-v starts block insert
;
; 5. :%norm can be used to execute a normal mode command on a range (every line here)
;
; 6. :helpgrep and :cdo can be used to perform edits on lines matching a pattern
;
; 7. q in a :Man buffer closes it

(local std (require :std))
(local tree-sitter (require :nvim-treesitter.configs))
(local lspconfig (require :lspconfig))
(local lean (require :lean))

; forward editor usages to the running nvim instance
(vim.fn.setenv :EDITOR :e)
(vim.fn.setenv :VISUAL :e)

; replaces ftdetect
; there's a conflict with zipPlugin.vim using .ott
(vim.filetype.add {:extension {:sv :silver
                               :mcr :macaroni
                               :ott :ott
                               :pm :pollen}})

; interferes with ftdetect here if we don't set it only for reasonable extensions
; plugins are loaded after init.lua so we could set this anywhere
(std.set-global-vars {:zipPlugin_ext "*.docx,*.dotx,*.epub,*.jar,*.odf,*.otf,*.pptx,*.xlsx,*.zip"})

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
(std.set-key-maps :i {"<C-;>" :<C-x><C-o>} {:silent true})

; no preview window for completions
(std.set-options {:completeopt :menu})

(fn enter-forgetful-mode []
  (std.set-options {:shadafile :NONE :undofile false :swapfile false})
  (print "ShaDa, persistent undo, and swap files have been disabled."))

(std.a.nvim-create-autocmd [:BufEnter]
  {:group (std.a.nvim-create-augroup :ForgetfulModeAucmds {})
   :pattern [:/tmp/bash-fc.* :/var/tmp/*]
   :callback enter-forgetful-mode})
       
(std.set-leader-maps {:q enter-forgetful-mode})

(fn get-clipboard []
  (let [primary (vim.fn.getreg "*")
        clipboard (vim.fn.getreg "+")
        unsplit-string
          (vim.fn.join ["PRIMARY:"
                        (if (std.str-is-empty primary) :<empty> primary)
                        "CLIPBOARD:"
                        (if (std.str-is-empty clipboard) :<empty> clipboard)]
                       "\n\n")
        contents (vim.split unsplit-string "\n")
        buf (std.a.nvim-create-buf false true)]
    (std.a.nvim-buf-set-lines buf 0 -1 true contents)
    (std.open-centered-window buf 0.7 0.7 "Clipboard")
    (std.set-key-maps :n {:<Esc> (fn [] (std.a.nvim-buf-delete buf {}))}
                         {:silent true :buffer buf})))

(fn clear-clipboard []
  (vim.fn.setreg "*" "")
  (vim.fn.setreg "+" "")
  (print "PRIMARY and CLIPBOARD cleared."))

(std.set-leader-maps {:w get-clipboard :e clear-clipboard})

; this will still remove buffers if it will close a tab other than
; one we are currently on. maybe it shouldn't
(fn del-buf-keep-tab []
  (let [current-buffer-identifier (std.a.nvim-get-current-buf)
        scratch-buffer-identifier (std.a.nvim-create-buf false true)
        current-window-identifier (std.a.nvim-get-current-win)]
    (std.a.nvim-command "silent! w")
    (std.a.nvim-win-set-buf current-window-identifier scratch-buffer-identifier)
    ; final parameter here is a lua array (previously: {1 "Edit another file!"})
    (std.a.nvim-buf-set-lines scratch-buffer-identifier 0 0 true ["Edit another file!"])
    ; remove buffer from buffer list
    (std.a.nvim-buf-set-option current-buffer-identifier :buflisted false)
    ; since :h :bwipeout might be dangerous somehow, :bunload instead
    (std.a.nvim-buf-delete current-buffer-identifier {:force true :unload true})))

(std.set-leader-maps {:dh vim.cmd.tabclose
                      :dl (fn [] (vim.cmd "tab split"))
                      :dx del-buf-keep-tab
                      :dd (fn [] (vim.cmd.buffer "#"))
                      "d;" (fn [] (vim.cmd.tabnew) (vim.cmd.terminal))})

(std.set-key-maps :n {:<C-h> vim.cmd.tabprev
                      :<C-l> vim.cmd.tabnext} 
                     {:silent true})

(fn mantab-for-cmd [word]
  (vim.cmd (.. "tab Man " word))) 

(fn get-word-under-cursor []
  (vim.fn.expand "<cWORD>"))

(std.set-key-maps :t {:<C-h> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabprev))
                      :<C-l> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabnext))
                      :<C-k> (fn [] (mantab-for-cmd (get-word-under-cursor)))}
                     {:silent true})

(std.set-key-maps :i {:<C-h> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabprev))
                      :<C-l> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabnext))}
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

(std.set-leader-maps {:u vim.cmd.UndotreeToggle})

; fzf config
(std.set-leader-maps {:ff vim.cmd.Files
                      :fb vim.cmd.BLines
                      :fl vim.cmd.Lines
                      :ft vim.cmd.BTags
                      :fp vim.cmd.Tags
                      :fm vim.cmd.Marks
                      :fc vim.cmd.Commands
                      :fo vim.cmd.Buffers})

; insert the lozenge character, for pollen (:h i_CTRL-V)
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
