local M = {}
M.config = function()
  require("true-zen").setup {}
end
M.keymaps = function()
  if O.plugin.zen then
    local sile = require("keymappings").sile
    -- sile("n", "zz", "<cmd>TZFocus<CR>")
    -- sile("n", "zm", "<cmd>TZMinimalist<CR>")
  end
end
return M
