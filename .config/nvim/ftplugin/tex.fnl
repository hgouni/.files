(local std (require :std))

(std.set-leader-maps { "lr" "<Cmd>echo system(['latexmk', expand('%')])" })
