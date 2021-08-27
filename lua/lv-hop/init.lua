local M = {}

M.config = function()
  require("hop").setup()
end

M.keymaps = function()
  if O.plugin.hop then
    mappings.sile("n", "<M-f>", "<cmd>lua require('hop').hint_words()<cr>")
    mappings.sile("n", "<M-S-f>", "<cmd>lua require('hop').hint_lines()<cr>")
  end
end

return M
