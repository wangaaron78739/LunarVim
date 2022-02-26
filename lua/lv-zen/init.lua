local M = {}
function M.config()
  require("true-zen").setup {}
end
function M.keymaps()
  if O.plugin.zen then
    local sile = require("keymappings").sile
    -- sile("n", "zz", "<cmd>TZFocus<CR>")
    -- sile("n", "zm", "<cmd>TZMinimalist<CR>")
  end
end
return M
