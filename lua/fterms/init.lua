local term = require "FTerm.terminal"

require("FTerm").setup {
  dimensions = { height = 0.8, width = 0.8, x = 0.5, y = 0.5 },
  border = "single", -- or 'double'
}

local function right(cmd)
  return term:new():setup {
    cmd = cmd,
    dimensions = { height = 0.95, width = 0.4, x = 1.0, y = 0.5 },
  }
end

local function under(cmd)
  return term:new():setup {
    cmd = cmd,
    dimensions = { height = 0.4, width = 0.6 },
  }
end

local function popup(cmd)
  return term:new():setup {
    cmd = cmd,
    dimensions = { height = 0.9, width = 0.9 },
  }
end

local M = {}
M.down = under(nil)
M.right = right(nil)
M.term = popup(nil)
M.gitui = popup "gitui"
-- FIXME: broot unable to open files correctly
M.broot = popup "broot"
M.python = popup "ipython"
M.spt = popup "spt"
M.top = popup "btm"

function _G.ftopen(name)
  M[name]:open()
end

require("lv-utils").define_augroups {
  _close_fterm = {
    { "FileType", "FTerm", "nnoremap <silent> <buffer> q <CMD>q<CR>" },
    -- { "FileType", "FTerm", "tnoremap <silent> <buffer> <esc> <nop>" },
    -- { "FileType", "FTerm", "tnoremap <silent> <buffer> <M-e> <C-\\><C-n>" },
    { "FileType", "FTerm", "tnoremap <silent> <buffer> <C-h> <C-\\><C-n><CMD>q<CR>" },
    { "FileType", "FTerm", "tnoremap <silent> <buffer> <C-j> <C-\\><C-n><CMD>q<CR>" },
    { "FileType", "FTerm", "tnoremap <silent> <buffer> <C-k> <C-\\><C-n><CMD>q<CR>" },
    { "FileType", "FTerm", "tnoremap <silent> <buffer> <C-l> <C-\\><C-n><CMD>q<CR>" },
  },
}
