require('FTerm').setup({
    dimensions  = {
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5
    },
    border = 'single' -- or 'double'
})

-- Keybinding
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<M-j>', '<CMD>lua require("FTerm").toggle()<CR>', opts)
map('t', '<M-j>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opts)

local term = require("FTerm.terminal")

local gitui = term:new():setup({
    cmd = "gitui",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})

function _G.__fterm_gitui()
    gitui:toggle()
end
map('n', '<M-g>', "<CMD>lua _G.__fterm_gitui()<CR>", opts)
map('t', '<M-g>', "<C-\\><C-n><CMD>lua _G.__fterm_gitui()<CR>", opts)


local spt = term:new():setup({
    cmd = "spt",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})

function _G.__fterm_spt()
    spt:toggle()
end
map('n', '<M-,>', "<CMD>lua _G.__fterm_spt()<CR>", opts)
map('t', '<M-,>', "<C-\\><C-n><CMD>lua _G.__fterm_spt()<CR>", opts)


