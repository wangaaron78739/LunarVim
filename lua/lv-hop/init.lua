local M = {}

M.config = function()
  require("hop").setup()
end

M.keymaps = function()
  if O.plugin.hop then
    local sile = require("keymappings").sile
    require("which-key").register({
      ["]h"] = { "<cmd>lua require(hop).hint_words()<cr>", "Hop Words" },
      ["]H"] = { "<cmd>lua require(hop).hint_lines()<cr>", "Hop Lines" },
    }, {
      mode = "n",
      silent = true,
    })
    -- sile("n", "]h", "<cmd>lua require('hop').hint_words()<cr>")
    -- sile("n", "]H", "<cmd>lua require('hop').hint_lines()<cr>")
  end
end

return M
