require('default-config')
vim.cmd('luafile ' .. CONFIG_PATH .. '/lv-config.lua')
require('settings')
require('plugins')
require('colorscheme')
require('lv-utils')
require('keymappings')
require('colorscheme') -- This plugin must be required somewhere after nvimtree. Placing it before will break navigation keymappings
require('lv-galaxyline')
require('lv-treesitter')
require('lv-which-key').config()
require('lsp')
if O.lang.emmet.active then require('lsp.emmet-ls') end

-- FIXME: This is not the proper place to enable these plugins and stuff

-- require('neoscroll').setup({
--     -- All these keys will be mapped to their corresponding default scrolling animation
--     mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
--                 '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
--     hide_cursor = false,          -- Hide cursor while scrolling
--     stop_eof = false,             -- Stop at <EOF> when scrolling downwards
--     respect_scrolloff = true,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
--     cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
--     easing_function = "sine"        -- Default easing function
-- })

-- vim.cmd('set spelllang=en_us')

vim.cmd('hi Conceal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828')

-- TODO: Refactor and organize these
-- Autosave
vim.api.nvim_command('au FocusLost * silent! wa')
vim.api.nvim_command(':set autowriteall')

-- vim-sandwhich
vim.api.nvim_command('runtime macros/sandwich/keymap/surround.vim')
vim.api.nvim_command([[
xmap is <Plug>(textobj-sandwich-query-i)
xmap as <Plug>(textobj-sandwich-query-a)
omap is <Plug>(textobj-sandwich-query-i)
omap as <Plug>(textobj-sandwich-query-a)
]])
