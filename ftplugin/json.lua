if require("lv-utils").check_lsp_client_active "jsonls" then
  return
end

local formatting = vim.lsp.buf.range_formatting
-- npm install -g vscode-json-languageserver
require("lsp.config").lspconfig "jsonls" {
  cmd = {
    "node",
    DATA_PATH .. "/lspinstall/json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js",
    "--stdio",
  },
  on_attach = require("lsp.functions").common_on_attach,

  commands = {
    Format = {
      function()
        formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
      end,
    },
  },

  flags = O.lsp.flags,
}
