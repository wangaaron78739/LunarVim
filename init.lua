-- vim.opt.shadafile = "NONE"
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- Install packer first
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  vim.cmd "packadd packer.nvim"
  vim.cmd ":qa"
end

pcall(require, "impatient")

-- if vim.g.started_by_firenvim then
-- end

-- Disable builtin plugins
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

-- Source the config files
require "config"
utils = require "lv-utils"
mappings = require "keymappings"
require "settings"
require "plugins"
require "theme"

-- 'Mandatory' plugin configs
mappings.setup()
require "lv-galaxyline"
require "lv-treesitter"
require "lsp"

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- vim.opt.shadafile = ""
