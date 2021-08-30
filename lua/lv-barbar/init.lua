local M = {}

M.config = function()
  local nore = require("keymappings").nore
  nore("n", "<TAB>", ":BufferNext<CR>")
  nore("n", "<S-TAB>", ":BufferPrevious<CR>")
  nore("n", "<S-x>", ":BufferClose<CR>")
end

return M
