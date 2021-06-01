require('lv-globals')
vim.cmd('luafile '..CONFIG_PATH..'/lv-settings.lua')
require('settings')
require('lv-gitblame')
require('plugins')
require('lv-utils')
require('lv-autocommands')
require('keymappings')
require('lv-nvimtree') -- This plugin must be required somewhere before colorscheme.  Placing it after will break navigation keymappings
require('colorscheme') -- This plugin must be required somewhere after nvimtree. Placing it before will break navigation keymappings
require('lv-galaxyline')
require('lv-comment')
require('lv-gitblame')
require('lv-compe')
require('lv-barbar')
require('lv-dashboard')
require('lv-telescope')
require('lv-gitsigns')
require('lv-treesitter')
require('lv-matchup')
require('lv-autopairs')
require('lv-rnvimr')
require('lv-which-key')
require('lv-lsp-rooter')
require('lv-zen')

-- extras
if O.extras then
    require('lv-numb')
    require('lv-dial')
    require('lv-hop')
    require('lv-colorizer')
end



-- TODO is there a way to do this without vimscript
vim.cmd('source '..CONFIG_PATH..'/vimscript/functions.vim')

-- LSP
require('lsp')
-- require('lsp.angular-ls')
-- require('lsp.bash-ls')
require('lsp.clangd')
-- require('lsp.css-ls')
-- require('lsp.dart-ls')
-- require('lsp.docker-ls')
require('lsp.efm-general-ls')
require('lsp.elm-ls')
-- require('lsp.emmet-ls')
-- require('lsp.graphql-ls')
-- require('lsp.go-ls')
-- require('lsp.html-ls')
require('lsp.json-ls')
-- require('lsp.js-ts-ls')
-- require('lsp.kotlin-ls')
require('lsp.latex-ls')
require('lsp.lua-ls')
-- require('lsp.php-ls')
require('lsp.python-ls')
-- require('lsp.ruby-ls')
require('lsp.rust-ls')
-- require('lsp.svelte-ls')
-- require('lsp.terraform-ls')
-- require('lsp.tailwindcss-ls')
require('lsp.vim-ls')
-- require('lsp.vue-ls')
require('lsp.yaml-ls')
-- require('lsp.elixir-ls')

require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    position = "right",
    auto_preview = false,
    hover = "h"
}

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
require('todo-comments').setup()
require('diffview').setup()

vim.cmd([[
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * TroubleRefresh
]])

vim.cmd('setlocal spell')
vim.cmd('set spelllang=en_us')

vim.cmd('hi Conceal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828')

-- FTerm
require('fterms')
