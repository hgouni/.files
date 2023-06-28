(local lspconfig (require :lspconfig))

(lspconfig.texlab.setup {:settings {:texlab {:build {:args {} :onSave true}}}})
