-- npm install -g vscode-html-languageserver-bin

require("lsp.config").lspconfig "html" {
  cmd = {
    "node",
    DATA_PATH .. "/lspinstall/html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js",
    "--stdio",
  },

  capabilities = require("lsp.config").caps {
    textDocument = { completion = { completionItem = { snippetSupport = true } } },
  },
}

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
