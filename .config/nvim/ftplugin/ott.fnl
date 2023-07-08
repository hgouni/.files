(local std (require :std))

(std.set-local-options {:errorformat (.. "%EFile %f on line %l\\, column %c%.%#:,%CError: ,%Z%m,"
                                         "%EFile %f on line %l\\, column %c%.%#:,%ZError: %m,"
                                         "%Efile %f on line %l%.%#:,%ZError: %m,"
                                         "%-G%.%#")  ; ignore remaining unmatched lines
                        :commentstring "% %s"})

(std.a.nvim-create-autocmd [:BufWritePost]
  {:group (std.a.nvim-create-augroup :OttAucmds {})
   :pattern [:*.ott]
   :callback (fn [] (vim.fn.jobstart ["make"]))})
