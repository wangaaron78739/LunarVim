local M = {}

M.config = function()
  local dial = require "dial"
  local function enum_cyclic(name, list)
    dial.augends["custom#" .. name] = dial.common.enum_cyclic {
      name = name,
      strlist = list,
    }
    table.insert(dial.config.searchlist.normal, "custom#" .. name)
  end

  enum_cyclic("boolean", { "true", "false" })
  enum_cyclic("Boolean", { "True", "False" })
end

M.keymaps = function()
  local map = function(from, to)
    vim.api.nvim_set_keymap("n", from, to, { silent = true })
    vim.api.nvim_set_keymap("v", from, to, { silent = true })
  end
  map("<C-a>", "<Plug>(dial-increment)")
  map("g<C-a>", "<Plug>(dial-increment-additional)")
  map("<C-x>", "<Plug>(dial-decrement)")
  map("g<C-x>", "<Plug>(dial-decrement-additional)")
end

return M
