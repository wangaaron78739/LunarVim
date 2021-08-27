local M = {}

M.config = function()
  mappings.nore("n", "<TAB>", ":BufferNext<CR>")
  mappings.nore("n", "<S-TAB>", ":BufferPrevious<CR>")
  mappings.nore("n", "<S-x>", ":BufferClose<CR>")
end

return M
