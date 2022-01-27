--- COLORSCHEME ---

-- My fav/common themes
vim.cmd [[
command! Zenbones colorscheme zenbones
command! Nordbones colorscheme nordbones
command! LightMelya colorscheme light_melya
command! Nebulous lua require'theme'.nebulous()
command! Material lua require'theme'.material()
command! Rdark lua require('colorbuddy').colorscheme('nvim-rdark')
command! DarkCatppuccino colorscheme catppuccin
command! Acme colorscheme acme
command! Pencil colorscheme pencil
command! Paper colorscheme paper
command! Parchment colorscheme parchment
command! ModusOperandi colorscheme modus-operandi
command! ModusVivendi colorscheme modus-vivendi
command! Writing lua vim.cmd(O.lighttheme)
]]

require("lv-utils").define_augroups {
  _nebulous_patches = {
    { "Colorscheme", "nebulous", "hi Conceal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828" },
    { "Colorscheme", "nebulous", "hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646" },
    { "Colorscheme", "nebulous", "hi LspReferenceText cterm=bold ctermbg=red guibg=#464646" },
    { "Colorscheme", "nebulous", "hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646" },
  },
}

local M = {
  nebulous = function()
    require("nebulous").setup {
      variant = "night",
      italic = {
        comments = true,
        keywords = false,
        functions = false,
        variables = false,
      },
      custom_colors = { -- FIXME: custom colors not bound
        -- Conceal = { ctermfg = "223", ctermbg = "235 ", guifg = "#ebdbb2", guibg = "#282828" },
        LspReferenceRead = { style = "bold", bg = "#464646" },
        LspReferenceText = { style = "bold", bg = "#464646" },
        LspReferenceWrite = { style = "bold", bg = "#464646" },
      },
    }
    -- vim.cmd "colorscheme nebulous"
  end,
  material = function()
    vim.g.material_style = "deep ocean"
    -- vim.g.material_style = "darker"
    require("material").setup {
      contrast = true, -- Enable contrast for sidebars, floating windows and popup menus like Nvim-Tree
      borders = true, -- Enable borders between verticaly split windows

      popup_menu = "dark", -- Popup menu style ( can be: 'dark', 'light', 'colorful' or 'stealth' )

      italics = {
        comments = true, -- Enable italic comments
        keywords = true, -- Enable italic keywords
        functions = false, -- Enable italic functions
        strings = false, -- Enable italic strings
        variables = false, -- Enable italic variables
      },

      contrast_windows = { -- Specify which windows get the contrasted (darker) background
        "terminal", -- Darker terminal background
        "packer", -- Darker packer background
        "qf", -- Darker qf list background
      },

      text_contrast = {
        lighter = true, -- Enable higher contrast text for lighter style
        darker = true, -- Enable higher contrast text for darker style
      },

      disable = {},
      custom_highlights = {}, -- Overwrite highlights with your own
    }
    vim.cmd "colorscheme material"
  end,
}

return setmetatable(M, {
  __call = function(table)
    vim.cmd(O.theme)
  end,
})
-- use "pgdouyon/vim-alayas"
-- require("colorbuddy").colorscheme "onebuddy"
