(vim.loader.enable) ; byte compile and cache modules

(local std (require :std))

(local autocmds-init (std.a.nvim-create-augroup :autocmds-init-hemant {})) ; clear grouped autocmds, avoids duplicating autocmds on reload

; forward editor usages to the running nvim instance
(set vim.env.VISUAL :e)
(set vim.env.EDITOR vim.env.VISUAL)

; suppress :healthcheck warning about perl provider
(std.set-global-vars {:loaded_perl_provider 0
                      :loaded_ruby_provider 0})

; replaces ftdetect
; there's a conflict with zipPlugin.vim using .ott
(vim.filetype.add {:extension {:fml :flowcaml
                               :lam :lambda
                               :mcr :macaroni
                               :ott :ott
                               :pm :pollen
                               :sv :silver
                               :sprig :thyme}
                   :pattern {".*bash%-fc%.%w*" :bash}})

; interferes with ftdetect here if we don't set it only for reasonable extensions
; plugins are loaded after init.lua so we could set this anywhere
(std.set-global-vars {:zipPlugin_ext "*.docx,*.dotx,*.epub,*.jar,*.odf,*.otf,*.pptx,*.xlsx,*.zip"})

(std.set-global-vars {:mapleader " " :maplocalleader "\\"})

(std.set-options {:shada "!,'100,<0,s10,h" ; turn off saving register contents
                  :modeline false
                  :splitbelow true
                  :cursorline true
                  :autowriteall true
                  :expandtab true
                  :tabstop 4
                  :shiftwidth 4
                  :scrolloff 11
                  :hlsearch false})

(std.a.nvim-create-user-command :W (fn [] (vim.cmd.write)) {})

; enable math input with :Math
(std.a.nvim-create-user-command :Math (fn [] (std.set-options {:keymap :math})) {})

; why does this work? this has remaps turned off
; for starting omnicomplete
(std.set-key-maps :i {"<C-;>" :<C-x><C-o>} {:silent true})

; no preview window for completions
(std.set-options {:completeopt :menu})

(fn save-as-date [] (vim.cmd.write (.. (std.get-date-string) ".md")))

(std.a.nvim-create-user-command :S save-as-date {})

(fn enter-forgetful-mode []
  (std.set-options {:shadafile :NONE :undofile false :swapfile false})
  (print "ShaDa, persistent undo, and swap files have been disabled."))

(std.a.nvim-create-autocmd [:BufEnter]
  {:group autocmds-init
   :pattern [:/tmp/bash-fc.* :/var/tmp/*]
   :callback enter-forgetful-mode})

(std.set-leader-maps {:q enter-forgetful-mode})

(fn show-clipboard []
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
    (std.open-centered-window buf 0.7 0.7 "Clipboard" 30)
    (std.set-key-maps :n {:<Esc> (fn [] (std.a.nvim-buf-delete buf {}))}
                         {:silent true :buffer buf})))

(fn clear-clipboard []
  (vim.fn.setreg "*" "")
  (vim.fn.setreg "+" "")
  (print "PRIMARY and CLIPBOARD cleared."))

(std.set-leader-maps {:w show-clipboard :e clear-clipboard})

; this will still remove buffers if it will close a tab other than
; one we are currently on. maybe it shouldn't
(fn del-buf-keep-tab []
  (let [current-buffer-identifier (std.a.nvim-get-current-buf)
        scratch-buffer-identifier (std.a.nvim-create-buf false true)
        current-window-identifier (std.a.nvim-get-current-win)]
    (vim.cmd "silent! w")
    (std.a.nvim-win-set-buf current-window-identifier scratch-buffer-identifier)
    ; final parameter here is a lua array (previously: {1 "Edit another file!"})
    (std.a.nvim-buf-set-lines scratch-buffer-identifier 0 0 true ["Edit another file!"])
    ; remove buffer from buffer list
    (std.a.nvim-buf-set-option current-buffer-identifier :buflisted false)
    ; since :h :bwipeout might be dangerous somehow, :bunload instead
    (std.a.nvim-buf-delete current-buffer-identifier {:force true :unload true})))

(std.set-leader-maps {:dh vim.cmd.tabclose
                      :dl (fn [] (vim.cmd "tab split"))
                      :dj (fn [] (vim.cmd "silent! tabmove -1"))
                      :dk (fn [] (vim.cmd "silent! tabmove +1"))
                      :dx del-buf-keep-tab
                      "d;" (fn [] (vim.cmd.tabnew) (vim.cmd.terminal))
                      :dd (fn [] (vim.cmd.buffer "#"))})

(std.set-key-maps :n {:<C-h> vim.cmd.tabprev
                      :<C-l> vim.cmd.tabnext} 
                     {:silent true})

(std.set-key-maps :t {:<C-h> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabprev))
                      :<C-l> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabnext))}
                     {:silent true})

(std.set-key-maps :i {:<C-h> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabprev))
                      :<C-l> (fn [] (vim.cmd.stopinsert) (vim.cmd.tabnext))}
                     {:silent true})

; make sure 24 bit TUI color is enabled (do it ourselves to be theme-independent)
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
                      :fm vim.cmd.Marks
                      :fo vim.cmd.Buffers})

; unset status line
(std.a.nvim-create-autocmd [:User]
    {:group autocmds-init :pattern :FzfStatusLine :callback (fn [])})

(std.set-global-vars {"conjure#mapping#prefix" "\\"
                      "conjure#mapping#doc_word" false
                      "conjure#mapping#def_word" false
                      "conjure#highlight#enabled" true
                      "conjure#filetypes" [:fennel :racket :scheme]})

(std.a.nvim-create-autocmd :BufNewFile
                           {:group autocmds-init
                            :pattern [:conjure-log-*]
                            :callback (fn [] (vim.diagnostic.disable 0))})

(std.a.nvim-create-autocmd :FileType
                           {:group autocmds-init
                            :pattern [:tex :fennel :rust]
                            :callback (fn [] (vim.treesitter.start))})

(set vim.lsp.config.racket_langserver {:filetypes [:racket]})
(set vim.lsp.config.texlab {:settings {:texlab {:build {:args {} :onSave true}}}})

; pairs, ipairs generate index, value
; ipairs is guaranteed to iterate sequentially
(each [_ server (ipairs [:hls :marksman :metals :ocamllsp :rust_analyzer :racket_langserver :texlab])]
  (vim.lsp.enable server))

; Mappings.
; See `:help vim.diagnostic.*` for documentation on any of the below functions
(var virtual-lines-state false)
(vim.keymap.set :n :<LocalLeader>e
                (fn []
                  (set virtual-lines-state (not virtual-lines-state))
                  (vim.diagnostic.config {:virtual_lines virtual-lines-state})))

(std.a.nvim-create-autocmd :LspAttach
    {:group autocmds-init
     :callback (fn [ev]
                 (local opts {:buffer ev.buf})
                 (vim.keymap.set :n :gD vim.lsp.buf.declaration opts)
                 (vim.keymap.set :n :gd vim.lsp.buf.definition opts)
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
