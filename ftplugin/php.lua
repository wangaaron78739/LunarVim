if require("lv-utils").check_lsp_client_active "intelephense" then
  return
end

require("lsp.config").lspconfig  "intelephense" {
  cmd = {
    DATA_PATH .. "/lspinstall/php/node_modules/.bin/intelephense",
    "--stdio",
  },
  on_attach = require("lsp.functions").common_on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = O.lang.php.diagnostics and vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      O.lang.php.diagnostics
    ),
  },
  filetypes = O.lang.php.filetypes,
  settings = {
    intelephense = {
      format = { braces = O.lang.php.format.braces },
      environment = { phpVersion = O.lang.php.environment.php_version },
    },
  },
  flags = O.lsp.flags,
}
