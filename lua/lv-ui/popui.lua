local M = {}
function M.config()
  vim.g.popui_border_style = O.lsp.border
  -- vim.ui.select = require "popui.ui-overrider"
end
return M
