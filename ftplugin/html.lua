-- npm install -g vscode-html-languageserver-bin

require("lsp.config").lspconfig "html" {
  capabilities = require("lsp.config").caps {
    textDocument = { completion = { completionItem = { snippetSupport = true } } },
  },
}

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
