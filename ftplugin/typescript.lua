require("lsp.tsserver-ls").setup()

require("lsp.efm-ls").generic_setup { "typescript" }

vim.cmd "setl ts=2 sw=2"
