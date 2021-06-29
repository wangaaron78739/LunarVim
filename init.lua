require('default-config')
vim.cmd('luafile ' .. CONFIG_PATH .. '/lv-config.lua')
require('settings')
require('plugins')
require('lv-utils')
require('lv-autocommands')
require('keymappings')
require('colorscheme') -- This plugin must be required somewhere after nvimtree. Placing it before will break navigation keymappings
require('lv-galaxyline')
require('lv-telescope')
require('lv-treesitter')
require('lv-autopairs')


-- extras
-- if O.extras then
--     require('lv-rnvimr')
--     require('lv-gitblame')
--     require('lv-matchup')
--     require('lv-numb')
--     require('lv-dial')
--     require('lv-hop')
--     require('lv-colorizer')
--     require('lv-spectre')
--     require('lv-symbols-outline')
--     require('lv-vimtex')
--     require('lv-zen')
--     require('lv-dashboard')
--     require('lv-lsp-rooter')
-- end

-- LSP
require('lsp')
-- TODO should I put this in the filetype files?
if O.lang.java.active then require('lsp.java-ls') end
if O.lang.clang.active then require('lsp.clangd') end
if O.lang.sh.active then require('lsp.bash-ls') end
if O.lang.cmake.active then require('lsp.cmake-ls') end
if O.lang.css.active then require('lsp.css-ls') end
if O.lang.dart.active then require('lsp.dart-ls') end
if O.lang.docker.active then require('lsp.docker-ls') end
if O.lang.efm.active then require('lsp.efm-general-ls') end
if O.lang.elm.active then require('lsp.elm-ls') end
if O.lang.emmet.active then require('lsp.emmet-ls') end
if O.lang.graphql.active then require('lsp.graphql-ls') end
if O.lang.go.active then require('lsp.go-ls') end
if O.lang.html.active then require('lsp.html-ls') end
if O.lang.json.active then require('lsp.json-ls') end
if O.lang.kotlin.active then require('lsp.kotlin-ls') end
if O.lang.latex.active then require('lsp.latex-ls') end
if O.lang.lua.active then require('lsp.lua-ls') end
if O.lang.php.active then require('lsp.php-ls') end
if O.lang.python.active then require('lsp.python-ls') end
if O.lang.ruby.active then require('lsp.ruby-ls') end
if O.lang.rust.active then require('lsp.rust-ls') end
if O.lang.svelte.active then require('lsp.svelte-ls') end
if O.lang.terraform.active then require('lsp.terraform-ls') end
if O.lang.tailwindcss.active then require('lsp.tailwindcss-ls') end
if O.lang.vim.active then require('lsp.vim-ls') end
if O.lang.yaml.active then require('lsp.yaml-ls') end
if O.lang.elixer.active then require('lsp.elixer-ls') end
if O.lang.tsserver.active then
    require('lsp.js-ts-ls')
    require('lsp.angular-ls')
    require('lsp.vue-ls')
end

-- FIXME: This is not the proper place to enable these plugins and stuff
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
require('diffview').setup()

vim.cmd([[
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * TroubleRefresh
]])

vim.cmd('set spelllang=en_us')

vim.cmd('hi Conceal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828')

