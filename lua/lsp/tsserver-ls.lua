local M = {}

local linter = "eslint"
local formatter = "prettier"

local function on_attach(client, bufnr)
  -- lsp_config.common_on_attach(client, bufnr)
  client.server_capabilities.document_formatting = false

  local ts_utils = require "nvim-lsp-ts-utils"

  -- defaults
  ts_utils.setup {
    debug = false,
    disable_commands = false,
    enable_import_on_completion = false,
    import_all_timeout = 5000, -- ms
    -- eslint
    eslint_enable_code_actions = true,
    eslint_enable_disable_comments = true,
    eslint_bin = linter,
    eslint_config_fallback = nil,
    eslint_enable_diagnostics = true,
    -- formatting
    enable_formatting = not not formatter,
    formatter = formatter,
    formatter_config_fallback = nil,
    -- parentheses completion
    complete_parens = false,
    signature_help_in_parens = false,
    -- update imports on file move
    update_imports_on_move = false,
    require_confirmation_on_move = false,
    watch_dir = nil,
  }

  -- required to fix code action ranges
  ts_utils.setup_client(client)

  mappings.localleader({
    ["o"] = { "<cmd>TSLspOrganize<CR>", "Organize" },
    ["f"] = { "<cmd>TSLspFixCurrent<CR>", "Fix" },
    ["r"] = { "<cmd>TSLspRenameFile<CR>", "Rename File" },
    ["i"] = { "<cmd>TSLspImportAll<CR>", "Import All" },
  }, {
    buffer = bufnr,
  })
end

-- npm install -g typescript typescript-language-server
-- require'snippets'.use_suggested_mappings()
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true;
-- local function on_attach_common (client)
-- print("LSP Initialized")
-- require'completion'.on_attach(client)
-- require'illuminate'.on_attach(client)
-- end
function M.setup()
  require("lsp.config").lspconfig "tsserver" {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    on_attach = on_attach,
    root_dir = require("lspconfig/util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    -- This makes sure tsserver is not used for formatting (I prefer prettier)
    settings = { documentFormatting = false },
  }
  require("lsp.config").lspconfig "eslint" {}
end

return M
