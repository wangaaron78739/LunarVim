local M = {}

M.config = function()
  require("hop").setup()
end

M.keymaps = function()
  if O.plugin.hop then
    local prefix = "<cmd>lua require('hop')."
    require("which-key").register({
      ["<leader>hw"] = { prefix .. "hint_words()<cr>", "Hop Words" },
      ["<leader>hh"] = { prefix .. "hint_lines()<cr>", "Hop Lines" },
      ["<leader>h*"] = { prefix .. "hint_cword()<cr>", "Hop cword" },
      ["<leader>hW"] = { prefix .. "hint_cWORD()<cr>", "Hop cWORD" },
      ["<leader>hl"] = { prefix .. "hint_locals()<cr>", "Hop Locals" },
      ["<leader>hd"] = { prefix .. "hint_definitions()<cr>", "Hop Defns" },
      ["<leader>hr"] = { prefix .. "hint_references()<cr>", "Hop Defns" },
    }, {
      mode = "n",
      silent = true,
    })
  end
end

return M
