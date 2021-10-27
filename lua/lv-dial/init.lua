local M = {}

M.config = function()
  local dial = require "dial"

  table.insert(dial.config.searchlist.normal, "markup#markdown#header")

  local function enum_cyclic(name, list)
    dial.augends["custom#" .. name] = dial.common.enum_cyclic {
      name = name,
      strlist = list,
    }
    table.insert(dial.config.searchlist.normal, "custom#" .. name)
  end
  local function enum_cyclic_chars(charstr)
    local charlist = {}
    charstr:gsub(".", function(c)
      vim.list_extend(charlist, { c })
      return c
    end)

    enum_cyclic(charstr, charlist)
  end

  enum_cyclic("boolean", { "true", "false" })
  enum_cyclic("Boolean", { "True", "False" })
  enum_cyclic_chars "ijk"
  enum_cyclic_chars "xyz"
  enum_cyclic_chars "uvw"
  enum_cyclic_chars "abc"
  enum_cyclic_chars "nmpqr"

  local map = vim.api.nvim_set_keymap
  local dialmap = function(from, to)
    map("n", from, to, { silent = true })
    map("x", from, to, { silent = true })
  end
  -- 5
  dialmap("<C-a>", "<Plug>(dial-increment)")
  dialmap("g<C-a>", "<Plug>(dial-increment-additional)")
  dialmap("<C-x>", "<Plug>(dial-decrement)")
  dialmap("g<C-x>", "<Plug>(dial-decrement-additional)")
end

M.keymaps = function() end

return M
