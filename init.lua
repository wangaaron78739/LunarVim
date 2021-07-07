require "default-config"
vim.cmd("luafile " .. CONFIG_PATH .. "/lv-config.lua")
require "keymappings"
require "settings"
require "plugins"
require "lv-utils"
-- Below three could be moved to config function() in plugins.lua?
require "lv-galaxyline"
require "lv-which-key"
require "lv-treesitter"
require "lsp"

-- if O.lang.emmet.active then
--   require "lsp.emmet-ls"
-- end
-- if O.lang.tailwindcss.active then
--   require "lsp.tailwindcss-ls"
-- end

-- autoformat
if O.format_on_save then
  require("lv-utils").define_augroups {
    autoformat = {
      {
        "BufWritePre",
        "*",
        [[undojoin | Neoformat]],
        -- [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]],
      },
    },
  }
end
