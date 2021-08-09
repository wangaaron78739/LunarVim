local M = {}

M.config = function()
  noremap("n", "<TAB>", ":BufferNext<CR>")
  noremap("n", "<S-TAB>", ":BufferPrevious<CR>")
  noremap("n", "<S-x>", ":BufferClose<CR>")
end

return M
