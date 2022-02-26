local M = {}

function M.config()
  local nore = require("keymappings").nore
  nore("n", "<TAB>", ":BufferNext<CR>")
  nore("n", "<S-TAB>", ":BufferPrevious<CR>")
  nore("n", "<S-x>", ":BufferClose<CR>")
end

return M
