if require("lv-utils").check_lsp_client_active "solargraph" then
  return
end

-- If you are using rvm, make sure to change below configuration
require("lsp.config").lspconfig  "solargraph" {
  cmd = { DATA_PATH .. "/lspinstall/ruby/solargraph/solargraph", "stdio" },
  on_attach = require("lsp.functions").common_on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = O.lang.ruby.diagnostics and vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      O.lang.ruby.diagnostics
    ),
  },
  filetypes = O.lang.ruby.filetypes,
  flags = O.lsp.flags,
}
