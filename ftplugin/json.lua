local formatting = vim.lsp.buf.range_formatting
-- npm install -g vscode-json-languageserver
require("lsp.config").lspconfig "jsonls" {
  cmd = {
    "node",
    DATA_PATH .. "/lspinstall/json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js",
    "--stdio",
  },

  commands = {
    Format = {
      function()
        formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
      end,
    },
  },
}
