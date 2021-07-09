require("lsp.tsserver-ls").setup()

require("lsp.efm-ls").generic_setup { "javascript" }

vim.cmd "setl ts=2 sw=2"
