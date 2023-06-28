(local std (require :std))

(std.set-localleader-maps {:f (fn [] (vim.cmd "silent !fnlfmt --fix %"))})
(std.set-local-options {:textwidth 99})
