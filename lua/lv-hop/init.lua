local M = {}

M.config = function()
  require("hop").setup()
end

M.keymaps = function()
  if O.plugin.hop.active then
    -- silemap("n", "<M-s>", ":HopChar2<cr>")
    -- silemap("n", "<M-f>", ":HopChar1<cr>")
    silemap("n", "<M-f>", "<cmd>HopWord<cr>")
    silemap("n", "<M-S-f>", "<cmd>HopLine<cr>")
  end
end

return M
