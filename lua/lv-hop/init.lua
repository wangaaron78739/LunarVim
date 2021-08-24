local M = {}

M.config = function()
  require("hop").setup()
end

M.keymaps = function()
  if O.plugin.hop then
    -- silemap("n", "<M-s>", ":HopChar2<cr>")
    -- silemap("n", "<M-f>", ":HopChar1<cr>")
    silemap("n", "<M-f>", "<cmd>lua require('hop').hint_words()<cr>")
    silemap("n", "<M-S-f>", "<cmd>lua require('hop').hint_lines()<cr>")
  end
end

return M
