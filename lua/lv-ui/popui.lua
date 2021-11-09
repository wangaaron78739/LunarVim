local M = {}
M.config = function()
  vim.g.popui_border_style = O.lsp.border
  -- vim.ui.select = require "popui.ui-overrider"
end
return M
