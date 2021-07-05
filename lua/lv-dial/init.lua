local M = {}

M.config = function()
  vim.cmd [[
nmap <C-a> <Plug>(dial-increment)
nmap <C-x> <Plug>(dial-decrement)
vmap <C-a> <Plug>(dial-increment)
vmap <C-x> <Plug>(dial-decrement)
vmap g<C-a> <Plug>(dial-increment-additional)
vmap g<C-x> <Plug>(dial-decrement-additional)
]]

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

return M
