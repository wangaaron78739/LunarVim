local M = {}

M.config = function()
  require("hop").setup()
end

M.keymaps = function()
  if O.plugin.hop then
    local sile = require("keymappings").sile
    sile("n", "<M-f>", "<cmd>lua require('hop').hint_words()<cr>")
    sile("n", "<M-S-f>", "<cmd>lua require('hop').hint_lines()<cr>")
  end
end

return M
