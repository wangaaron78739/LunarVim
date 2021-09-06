local M = {}
-- npm install -g typescript typescript-language-server
-- require'snippets'.use_suggested_mappings()
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true;
-- local on_attach_common = function(client)
-- print("LSP Initialized")
-- require'completion'.on_attach(client)
-- require'illuminate'.on_attach(client)
-- end
M.setup = function()
  if not require("lv-utils").check_lsp_client_active "tsserver" then
    require("lsp.config").lspconfig "tsserver" {
      cmd = {
        DATA_PATH .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
        "--stdio",
      },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      on_attach = require("lsp").tsserver_on_attach,
      -- This makes sure tsserver is not used for formatting (I prefer prettier)
      -- on_attach = require'lsp'.common_on_attach,
      root_dir = require("lspconfig/util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
      settings = { documentFormatting = false },
      handlers = {
        ["textDocument/publishDiagnostics"] = O.lang.tsserver.diagnostics and vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics,
          O.lang.tsserver.diagnostics
        ),
      },
      flags = O.lsp.flags,
    }
  end
end

return M
