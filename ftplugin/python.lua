-- npm i -g pyright
require("lsp.config").lspconfig  "pyright" {
  cmd = {
    DATA_PATH .. "/lspinstall/python/node_modules/.bin/pyright-langserver",
    "--stdio",
  },
  on_attach = require("lsp.functions").common_on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = O.lang.python.diagnostics and vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      O.lang.python.diagnostics
    ),
  },
  settings = {
    python = {
      analysis = O.lang.python.analysis,
    },
  },
  flags = O.lsp.flags,
}

if O.plugin.debug and O.plugin.dap_install then
  local dap_install = require "dap-install"
  dap_install.config("python_dbg", {})
end

require("lv-sandwich").add_recipe {
  buns = { [["""]], [["""]] },
  quoteescape = true,
  expand_range = false,
  nesting = false,
  input = { "s" },
}
