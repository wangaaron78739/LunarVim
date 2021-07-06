require "default-config"
vim.cmd("luafile " .. CONFIG_PATH .. "/lv-config.lua")
require "keymappings"
require "settings"
require "plugins"
require "lv-utils"
require "lv-galaxyline"
require "lv-which-key"
require "lv-treesitter"
require "lsp"

-- autoformat
if O.format_on_save then
  require("lv-utils").define_augroups {
    autoformat = {
      {
        "BufWritePre",
        "*",
        [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]],
      },
    },
  }
end
