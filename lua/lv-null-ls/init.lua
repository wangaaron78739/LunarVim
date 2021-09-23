local M = {}

local null = require "null-ls"

local gcc_diagnostics = require "lv-null-ls.gcc"

function M.config()
  local diagnostics_format = "[#{c}] #{m} (#{s})"

  local formatters = null.builtins.formatting
  local diagnostics = null.builtins.diagnostics
  -- local code_actions = null.builtins.code_actions

  null.config {
    diagnostics_format = diagnostics_format,
    sources = {
      -- Formatters
      formatters.stylua,
      formatters.prettierd.with {
        command = "npx prettierd",
      },
      -- formatters.rustfmt,
      formatters.shfmt,
      formatters.black, -- yapf, autopep8
      formatters.isort,
      -- formatters.clang_format,
      -- formatters.uncrustify,
      formatters.cmake_format,
      formatters.elm_format,
      formatters.fish_indent,
      formatters.fnlfmt,
      formatters.json_tool,
      formatters.nixfmt,

      -- -- Diagnostics
      -- -- diagnostics.chktex, -- vimtex?
      -- diagnostics.eslint,
      -- diagnostics.flake8,
      -- -- diagnostics.pylint,
      -- diagnostics.hadolint,
      -- -- diagnostics.luacheck,
      -- diagnostics.selene, -- lua linter
      -- diagnostics.write_good,
      -- diagnostics.vale,
      -- -- diagnostics.misspell,
      -- diagnostics.markdownlint,

      -- Code Actions
      -- code_actions.gitsigns, -- TODO: reenable when I can lower the priority
    },
  }
  require("lspconfig")["null-ls"].setup {}
end

return M
