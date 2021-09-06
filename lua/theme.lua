--- COLORSCHEME ---

-- My fav/common themes
vim.cmd [[
command! Zenbones colorscheme zenbones
command! LightMelya colorscheme light_melya
command! Nebulous colorscheme nebulous
command! DarkCatppuccino colorscheme dark_catppuccino
command! Acme colorscheme acme
command! Pencil colorscheme pencil
command! Paper colorscheme paper
command! Parchment colorscheme parchment
command! ModusOperandi colorscheme modus-operandi
]]

require("lv-utils").define_augroups {
  _nebulous_patches = {
    { "Colorscheme", "nebulous", "hi Conceal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828" },
    { "Colorscheme", "nebulous", "hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646" },
    { "Colorscheme", "nebulous", "hi LspReferenceText cterm=bold ctermbg=red guibg=#464646" },
    { "Colorscheme", "nebulous", "hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646" },
  },
}

local M = {}

vim.cmd [[command! Writing lua vim.cmd(O.lighttheme)]]

return setmetatable(M, {
  __call = function(table)
    vim.cmd(O.theme)
  end,
})
-- use "pgdouyon/vim-alayas"
-- require("colorbuddy").colorscheme "onebuddy"
