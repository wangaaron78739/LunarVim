local M = {}
-- Imports
local libmodal = require "libmodal"

local function rhs(rhs)
  return {
    rhs = rhs,
  }
end
local function silent(rhs)
  return {
    rhs = rhs,
    silent = true, -- don't echo
  }
end
local function nore(rhs)
  return {
    rhs = rhs,
    noremap = true, -- don't recursively map.
  }
end

-- create a new layer.
M.mode = libmodal.Layer.new {
  n = { -- normal mode mappings
    ["w"] = nore "eviwo",
    ["e"] = nore "eviw",
    ["b"] = nore "bviwo",
    ["S-W"] = nore "WviW",
    ["S-B"] = nore "BviWo",
    [")"] = nore "f(va(",
    ["("] = nore "F)va)o",
    ["j"] = nore "jV",
    ["k"] = nore "kV",
    ["<ESC>"] = nore ":lua require('lv-kakmode').exit()<CR>",
  },
  v = {
    ["w"] = nore "oeow",
    ["e"] = nore "eowo",
    --[  "w"] = nore "<Esc>wviw",
    ["b"] = nore "ogeob",
    --[  "b"] = nore "<Esc>bviwo",
    ["S-W"] = nore "EOWO",
    --[  "S-W"] = nore "<Esc>WviW",
    ["S-B"] = nore "OBOGE",
    --[  "S-B"] = nore "<Esc>BviWo",
    [")"] = nore "<Esc>f(vi(",
    ["("] = nore "<Esc>F)vi)",
    ["j"] = nore "<Esc>jV",
    ["k"] = nore "<Esc>kV",
  },
}

-- M.visual = libmodal.Layer.new {
-- map("v", "<M-w>", "eowo", sile)
-- -- map("v", "<M-w>", "<Esc>wviw", sile)
-- map("v", "<M-b>", "oboge", sile)
-- -- map("v", "<M-b>", "<Esc>bviwo", sile)
-- map("v", "<M-S-W>", "EOWO", sile)
-- -- map("v", "<M-S-W>", "<Esc>WviW", sile)
-- map("v", "<M-S-B>", "OBOGE", sile)
-- -- map("v", "<M-S-B>", "<Esc>BviWo", sile)
-- map("v", "<M-)>", "<Esc>f(vi(", sile)
-- map("v", "<M-(>", "<Esc>F)vi)", sile)
-- map("v", "<M-j>", "<Esc>jV", sile)
-- map("v", "<M-k>", "<Esc>kV", sile)
-- }

-- enter the `mode`.
function M.enter()
  M.mode:enter()
end
-- enter the `mode`.
function M.exit()
  M.mode:exit()
end

-- --[[ unmap `gg` and `G`. Notice they both return to their defaults,
--      rather than just not doing anything anymore. ]]
-- layer:unmap("n", "gg")
-- layer:unmap("n", "G")
-- If you wish to only change the mappings of a layer temporarily, you should use another layer. `map` and `unmap` permanently add and remove from the layer's keymap.

return M
