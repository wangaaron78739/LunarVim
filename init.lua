vim.opt.shadafile = "NONE"
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

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

vim.cmd [[
function! SynGroup()                                                            
    let l:s = synID(line('.'), col('.'), 1)                                       
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
]]

vim.opt.shadafile = ""
