local M = {}

M.config = function()
  require("hop").setup()
end

M.keymaps = function()
  if O.plugin.hop then
    local prefix = "<cmd>lua require('hop')."
    require("which-key").register({
      ["<leader>h"] = {
        name = "Hop",
        w = { prefix .. "hint_words()<cr>", "Words" },
        h = { prefix .. "hint_lines()<cr>", "Lines" },
        ["*"] = { prefix .. "hint_cword()<cr>", "cword" },
        W = { prefix .. "hint_cWORD()<cr>", "cWORD" },
        l = { prefix .. "hint_locals()<cr>", "Locals" },
        d = { prefix .. "hint_definitions()<cr>", "Definitions" },
        r = { prefix .. "hint_references()<cr>", "References" },
        u = { prefix .. "hint_references(nil, '<cword>')<cr>", "Usages" },
        s = { prefix .. "hint_scopes()<cr>", "Scopes" },
      },
    }, {
      mode = "n",
      silent = true,
    })
  end
end

return M
