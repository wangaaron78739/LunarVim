-- OLD and OUTDATED
-- Example configuations here: https://github.com/mattn/efm-langserver
-- You can look for project scope Prettier and Eslint with e.g. vim.fn.glob("node_modules/.bin/prettier") etc. If it is not found revert to global Prettier where needed.
local M = {}

local function tsserver_on_attach(client, bufnr)
  -- lsp_config.common_on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = false

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
    eslint_bin = O.lang.tsserver.linter,
    eslint_config_fallback = nil,
    eslint_enable_diagnostics = true,
    -- formatting
    enable_formatting = O.lang.tsserver.autoformat,
    formatter = O.lang.tsserver.formatter,
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

  -- TODO: keymap these?
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", {silent = true})
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", {silent = true})
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", {silent = true})
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", {silent = true})
end

local function setup_efm()
  local prettier = {
    formatCommand = "prettier --stdin-filepath ${INPUT}",
    formatStdin = true,
  }

  if vim.fn.glob "node_modules/.bin/prettier" ~= "" then
    prettier = {
      formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}",
      formatStdin = true,
    }
  end

  require("lspconfig").efm.setup {
    -- init_options = {initializationOptions},
    cmd = { DATA_PATH .. "/lspinstall/efm/efm-langserver" },
    init_options = { documentFormatting = true, codeAction = false },
    filetypes = { "html", "css", "yaml", "vue", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    settings = {
      rootMarkers = { ".git/", "package.json" },
      languages = {
        html = { prettier },
        css = { prettier },
        json = { prettier },
        yaml = { prettier },
      },
    },
  }

  if O.lang.tsserver.autoformat then
    require("lv-utils").define_augroups {
      _javascript_autoformat = {
        {
          "BufWritePre",
          "*.js",
          "lua vim.lsp.buf.formatting_sync(nil, 1000)",
        },
      },
      _javascriptreact_autoformat = {
        {
          "BufWritePre",
          "*.jsx",
          "lua vim.lsp.buf.formatting_sync(nil, 1000)",
        },
      },
      _typescript_autoformat = {
        {
          "BufWritePre",
          "*.ts",
          "lua vim.lsp.buf.formatting_sync(nil, 1000)",
        },
      },
      _typescriptreact_autoformat = {
        {
          "BufWritePre",
          "*.tsx",
          "lua vim.lsp.buf.formatting_sync(nil, 1000)",
        },
      },
    }
  end
end

M.setup = function()
  -- npm install -g typescript typescript-language-server
  -- require'snippets'.use_suggested_mappings()
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true;
  -- local on_attach_common = function(client)
  -- print("LSP Initialized")
  -- require'completion'.on_attach(client)
  -- require'illuminate'.on_attach(client)
  -- end
  require("lspconfig").tsserver.setup {
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
    on_attach = require("lsp.jsts").tsserver_on_attach,
    -- This makes sure tsserver is not used for formatting (I prefer prettier)
    -- on_attach = require'lsp'.common_on_attach,
    root_dir = require("lspconfig/util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    settings = { documentFormatting = true },
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = O.lang.tsserver.diagnostics.virtual_text,
        signs = O.lang.tsserver.diagnostics.signs,
        underline = O.lang.tsserver.diagnostics.underline,
        update_in_insert = true,
      }),
    },
  flags = O.lsp.flags
  }

  vim.cmd "setl ts=2 sw=2"
end

return M
