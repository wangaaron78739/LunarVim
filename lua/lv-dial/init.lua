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
  local map = vim.api.nvim_set_keymap
  local dialmap = function(from, to)
    map("n", from, to, { silent = true })
    map("v", from, to, { silent = true })
  end
  dialmap("<C-a>", "<Plug>(dial-increment)")
  dialmap("g<C-a>", "<Plug>(dial-increment-additional)")
  dialmap("<C-x>", "<Plug>(dial-decrement)")
  dialmap("g<C-x>", "<Plug>(dial-decrement-additional)")
end

return M
