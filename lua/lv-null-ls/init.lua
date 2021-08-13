local M = {}
function M.config()
  local null = require "null-ls"
  local diagnostics_format = "[#{c}] #{m} (#{s})"
  local formatters = null.builtins.formatting
  local diagnostics = null.builtins.diagnostics
  local code_actions = null.builtins.code_actions

  null.config {
    diagnostics_format = diagnostics_format,
    sources = {
      -- Formatters
      formatters.stylua,
      formatters.prettierd,
      -- formatters.rustfmt,
      formatters.shfmt,
      formatters.black, -- yapf, autopep8
      formatters.isort,
      formatters.clang_format,
      -- formatters.uncrustify,
      formatters.cmake_format,
      formatters.elm_format,
      formatters.fish_indent,
      formatters.fnlfmt,
      formatters.json_tool,
      formatters.nixfmt,

      -- Diagnostics
      -- diagnostics.chktex, -- vimtex?
      diagnostics.eslint,
      diagnostics.flake8,
      diagnostics.pylint,
      diagnostics.hadolint,
      -- diagnostics.luacheck,
      -- diagnostics.selene,
      diagnostics.write_good,
      diagnostics.vale,
      -- diagnostics.misspell,
      diagnostics.markdownlint,

      -- Code Actions
      code_actions.gitsigns,
    },
  }
  require("lspconfig")["null-ls"].setup {}
end

M.keymaps = function()
  noremap("n", "gm", [[<cmd>lua require("lsp.functions").format_range_operator()<CR>]])
  noremap("n", "=", [[<cmd>lua require("lsp.functions").format_range_operator()<CR>]])
  noremap("v", "gm", "<cmd>lua vim.lsp.buf.range_formatting()<cr>")
  noremap("v", "=", "<cmd>lua vim.lsp.buf.range_formatting()<cr>")
  noremap("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<cr>")
  noremap("n", "==", "<cmd>lua vim.lsp.buf.formatting()<cr>")
end

return M
