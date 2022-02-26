local M = {}

function M.config()
  local dial = require "dial"

  table.insert(dial.config.searchlist.normal, "markup#markdown#header")

  local function enum_cyclic(name, list)
    dial.augends["custom#" .. name] = dial.common.enum_cyclic {
      name = name,
      strlist = list,
    }
    table.insert(dial.config.searchlist.normal, "custom#" .. name)
  end
  local function string_to_list(charstr)
    local charlist = {}
    charstr:gsub(".", function(c)
      vim.list_extend(charlist, { c })
      return c
    end)
    return charlist
  end
  local function enum_cyclic_chars(charstr)
    local charlist = string_to_list(charstr)
    enum_cyclic(charstr, charlist)
  end

  enum_cyclic("boolean", { "true", "false" })
  enum_cyclic("Boolean", { "True", "False" })
  local function cycle(v, pre)
    return {
      pre .. v,
      pre .. "{" .. v .. "+1}",
      pre .. "{" .. v .. "-1}",
    }
  end
  -- for _, v in ipairs(string_to_list "ijkxyzmn") do
  --   enum_cyclic("_" .. v, cycle(v, "_"))
  --   enum_cyclic("^" .. v, cycle(v, "^"))
  -- end
  enum_cyclic_chars "ijk"
  enum_cyclic_chars "xyz"
  enum_cyclic_chars "uvw"
  enum_cyclic_chars "abc"
  enum_cyclic_chars "nmpqr"

  local map = vim.keymap.set
  local function dialmap(from, to)
    map("n", from, to, { silent = true })
    map("x", from, to, { silent = true })
  end
  -- 5
  dialmap("<C-a>", "<Plug>(dial-increment)")
  dialmap("g<C-a>", "<Plug>(dial-increment-additional)")
  dialmap("<C-x>", "<Plug>(dial-decrement)")
  dialmap("g<C-x>", "<Plug>(dial-decrement-additional)")
end

function M.keymaps() end

return M
