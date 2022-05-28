local M = {}

function M.config()
  -- local dial = require "dial"
  local dial_config = require "dial.config"
  local augend = require "dial.augend"

  -- table.insert(dial.config.searchlist.normal, "markup#markdown#header")

  dial_config.augends:register_group {
    default = {
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.integer.alias.binary,
      augend.constant.alias.bool,
      augend.constant.alias.alpha,
      augend.constant.alias.Alpha,
      augend.semver.alias.semver,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%d/%m/%Y"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%d-%m-%Y"],
    },
  }

  local dialmap = require "dial.map"
  local map = vim.keymap.set
  map("n", "<C-a>", dialmap.inc_normal(), {})
  map("n", "<C-x>", dialmap.dec_normal(), {})
  map("v", "<C-a>", dialmap.inc_visual(), {})
  map("v", "<C-x>", dialmap.dec_visual(), {})
  map("v", "g<C-a>", dialmap.inc_gvisual(), {})
  map("v", "g<C-x>", dialmap.dec_gvisual(), {})
end

function M.keymaps() end

return M
