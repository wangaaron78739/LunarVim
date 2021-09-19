vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- npm install -g vscode-css-languageserver-bin
require("lsp.config").lspconfig "cssls" {
  cmd = {
    "node",
    DATA_PATH .. "/lspinstall/css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
    "--stdio",
  },
}
