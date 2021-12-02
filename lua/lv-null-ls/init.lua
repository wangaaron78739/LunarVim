local M = {}

local null = require "null-ls"

function M.config()
  local gcc_diagnostics = require "lv-null-ls.gcc"

  local diagnostics_format = "[#{c}] #{m} (#{s})"

  local formatters = null.builtins.formatting
  local diagnostics = null.builtins.diagnostics
  local code_actions = null.builtins.code_actions
  local hover = null.builtins.hover
  local compl = null.builtins.completion

  null.config {
    -- debug = true,
    diagnostics_format = diagnostics_format,
    sources = {
      gcc_diagnostics, -- Move to builtin when PR is accepted

      -- Formatters
      formatters.stylua,
      formatters.prettierd,
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
      -- formatters.json_tool,
      formatters.nixfmt,

      -- -- Diagnostics
      -- -- diagnostics.chktex, -- vimtex?
      -- diagnostics.selene, -- lua linter
      -- diagnostics.luacheck, -- lua linter
      -- diagnostics.eslint,
      -- diagnostics.hadolint,
      diagnostics.cppcheck,
      -- diagnostics.flake8,
      -- diagnostics.pylint,
      -- diagnostics.hadolint,
      -- -- diagnostics.luacheck,
      diagnostics.write_good,
      -- diagnostics.proselint,
      -- diagnostics.vale, -- lets install vale-linter
      -- -- diagnostics.misspell,
      diagnostics.markdownlint,
      diagnostics.yamllint,

      -- Code Actions
      -- code_actions.gitsigns, -- TODO: reenable when I can lower the priority
      -- code_actions.proselint,
      code_actions.refactoring,
      code_actions.statix,

      -- compl.spell,

      -- Hover Info
      hover.dictionary.with {
        generator = {},
        filetypes = { "txt", "markdown", "tex" },
      },
    },
  }
  require("lspconfig")["null-ls"].setup {}
end

return M
