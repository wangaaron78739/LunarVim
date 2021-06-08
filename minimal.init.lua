require('lv-globals')
vim.cmd('luafile '..CONFIG_PATH..'/lv-settings.lua')
require('settings')
require('keymappings')

require('colorscheme') 
