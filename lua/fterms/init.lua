local term = require("FTerm.terminal")

local gitui = term:new():setup({
    cmd = "gitui",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})
local broot = term:new():setup({
    cmd = "broot",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})
local python = term:new():setup({
    cmd = "python",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})
local spt = term:new():setup({
    cmd = "spt",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})
local top = term:new():setup({
    cmd = "btm",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})
function _G.__fterm_broot()
    broot:toggle()
end
function _G.__fterm_python()
    python:toggle()
end
function _G.__fterm_gitui()
    gitui:toggle()
end
function _G.__fterm_top()
    top:toggle()
end
function _G.__fterm_spt()
    spt:toggle()
end