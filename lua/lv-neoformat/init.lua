local M = {}

M.config = function()
  vim.g.neoformat_run_all_formatters = 0

  vim.g.neoformat_enabled_python = { "black", "autopep8", "yapf", "docformatter" }
  vim.g.neoformat_enabled_javascript = { "prettier" }
  vim.g.neoformat_enabled_lua = { "stylua", "luaformat" }

  --[[ -- Enable alignment
  vim.g.neoformat_basic_format_align = 1
  -- Enable tab to spaces conversion
  vim.g.neoformat_basic_format_retab = 1
  -- Enable trimmming of trailing whitespace
  vim.g.neoformat_basic_format_trim = 1 ]]
end

return M
