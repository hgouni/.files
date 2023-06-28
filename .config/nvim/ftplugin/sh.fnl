(local std (require :std))

(std.set-local-options {:makeprg "shellcheck -f gcc %"})

