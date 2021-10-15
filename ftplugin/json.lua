local formatting = vim.lsp.buf.range_formatting
-- npm install -g vscode-json-languageserver
require("lsp.config").lspconfig "jsonls" {
  commands = {
    Format = {
      function()
        formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
      end,
    },
  },
}
