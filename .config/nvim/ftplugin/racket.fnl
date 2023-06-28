(local lspconfig (require :lspconfig))

(lspconfig.racket_langserver.setup {:filetypes [:racket]})
