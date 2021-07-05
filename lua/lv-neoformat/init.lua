local M = {}

M.config = function()
  vim.g.neoformat_enabled_lua = { "stylua", "luaformat" }
end

return M
