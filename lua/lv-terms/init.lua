local M = {}

local eval_line = "xx"
local eval_op = "x"
local eval_cell = "x<cr>"

local map = vim.api.nvim_set_keymap
local bmap = vim.api.nvim_buf_set_keymap

function M.fterm()
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

  local fterms = {}
  fterms.down = under(nil)
  fterms.right = right(nil)
  fterms.term = popup(nil)
  fterms.gitui = popup "gitui"
  -- FIXME: broot unable to open files correctly
  fterms.broot = popup "broot"
  fterms.xplr = popup "xplr"
  fterms.python = popup "ipython"
  fterms.spt = popup "spt"
  fterms.top = popup "btm"

  vim.api.nvim_set_keymap("n", "<M-i>", '<CMD>lua require("FTerm").toggle()<CR>', {})
  vim.api.nvim_set_keymap("t", "<M-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', {})
  -- map("t", "<Esc>", '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>', nore)

  function _G.ftopen(name)
    fterms[name]:open()
  end

  vim.cmd [[
    command! -nargs=1 Ftopen lua ftopen('<args>')
  ]]

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

  return fterms
end

function M.neoterm()
  vim.g.neoterm_default_mod = "FocusSplitNicely"
  vim.g.neoterm_autoinsert = 1
  vim.g.neoterm_autoscroll = 1
  vim.g.neoterm_shell = O.termshell
  vim.g.neoterm_bracketed_paste = 1
  vim.g.neoterm_repl_python = { "ipython" }
  vim.g.neoterm_repl_lua = { "croissant" }
  --vim.g.neoterm_repl_python = "['conda activate venv', 'clear', 'ipython']"
end

function M.magma()
  vim.cmd [[ command MagmaStart :lua require("lv-terms").activate_magma() ]]
end

function M.activate_magma()
  vim.cmd "MagmaInit"
  mappings.localleader {
    ["xx"] = { "<cmd>MagmaEvaluateLine<CR>", "Line" },
    ["x<cr>"] = { "<cmd>MagmaReevaluateCell<CR>", "Cell" },
    ["xd"] = { "<cmd>MagmaDelete<CR>", "MagmaDel" },
    ["to"] = { "<cmd>MagmaShowOutput<cr>", "Magma Output" },
    x = "Magma",
  }
  bmap("n", "<localleader>x", ":MagmaEvaluateOperator<CR>", { expr = true, silent = true })
  bmap("v", "<localleader>x", "<cmd>MagmaEvaluateVisual<CR>", { silent = true })
end

function M.luadev()
  vim.cmd [[ command LuadevStart :lua require("lv-terms").activate_luadev() ]]
end

function M.activate_luadev()
  vim.cmd "Luadev"
  mappings.localleader {
    ["xx"] = { "<Plug>(Luadev-RunLine)", "Line" },
    ["x"] = { "<Plug>(Luadev-Run)", "Luadev" },
  }
  map("v", "<localleader>x", "<Plug>(Luadev-Run)", { silent = true })
  -- map("i", "", "<Plug>(Luadev-Complete)", { silent = true })
  -- map("n", "<leader>xw", "<Plug>(Luadev-RunWord)", { silent = true })
end

local feedkeys = vim.api.nvim_feedkeys
local termcodes = vim.api.nvim_replace_termcodes
function M.Tmem(cmd)
  vim.cmd("Tmap " .. cmd)
  feedkeys(termcodes(vim.g.neoterm_automap_keys, true, true, true), "m", false)
end

function M.sniprun()
  require("sniprun").setup {
    -- TODO: customize these displays
    --# you can combo different display modes as desired
    display = {
      "Classic", --# display results in the command-line  area
      "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)

      -- "VirtualTextErr",          --# display error results as virtual text
      -- "TempFloatingWindow",      --# display results in a floating window
      -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
      -- "Terminal",                --# display results in a vertical split
      -- "NvimNotify",              --# display with the nvim-notify plugin
      -- "Api"                      --# return output to a programming interface
    },

    --# You can use the same keys to customize whether a sniprun producing
    --# no output should display nothing or '(no output)'
    show_no_output = {
      "Classic",
      "TempFloatingWindow", --# implies LongTempFloatingWindow, which has no effect on its own
    },

    --# customize highlight groups (setting this overrides colorscheme)
    snipruncolors = {
      SniprunVirtualTextOk = { bg = "#66eeff", fg = "#000000", ctermbg = "Cyan", cterfg = "Black" },
      SniprunFloatingWinOk = { fg = "#66eeff", ctermfg = "Cyan" },
      SniprunVirtualTextErr = { bg = "#881515", fg = "#000000", ctermbg = "DarkRed", cterfg = "Black" },
      SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" },
    },

    --# miscellaneous compatibility/adjustement settings
    inline_messages = 0, --# inline_message (0/1) is a one-line way to display messages
    --# to workaround sniprun not being able to display anything

    borders = "single", --# display borders around floating windows
    --# possible values are 'none', 'single', 'double', or 'shadow'
  }
end

function M.coderunner()
  require("code_runner").setup {
    filetype = { map = "<leader>xf" },
    project_context = { map = "<leader>xP" },
  }
end

function M.keymaps(leaderMappings, vLeaderMappings)
  local cmd = utils.cmd
  local opts = { silent = true, noremap = true }
  if O.plugin.neoterm then
    vim.cmd [[ command -nargs=+ Tmem :lua require("lv-terms").Tmem("<args>") ]]

    vim.g.neoterm_automap_keys = "<leader>x<space>"
    -- Use gt to send to terminal
    map("n", "<leader>t<space>", ":Tmem ", {})
    map("n", "<leader>tt", ":T ", {})
    leaderMappings["t<cr>"] = { cmd "Ttoggle", "Neoterm Toggle" }
    leaderMappings["tl"] = { cmd "Tls", "Neoterm list" }

    map("n", "<leader>xm", "<Plug>(neoterm-repl-send)", opts)
    map("n", "<leader>xn", "<Plug>(neoterm-repl-send-line)", opts)
    map("x", "<leader>xn", "<Plug>(neoterm-repl-send)", opts)
    leaderMappings["x<space>"] = "Neoterm AutoMap"
  end

  if O.plugin.kittyrunner then
    map("n", "<leader>tk", "<cmd>KittyOpen<CR>", opts)
    map("n", "<leader>tK", "<cmd>KittyOpenLocal<CR>", opts)
    map("n", "<leader>xk", "<cmd>KittyReRunCommand<CR>", opts)
    map("n", "<leader>xK", "<cmd>KittyRunCommand<CR>", opts)
    map("n", "<leader>xl", "<cmd>KittySendLines<CR>", opts)
    map("x", "<leader>xl", "<cmd>KittySendLines<CR>", opts)
  end

  if O.plugin.sniprun then
    map("n", "<leader>tp", "<Plug>SnipClose", opts)
    map("n", "<leader>tP", "<cmd>SnipReset<cr>", opts)
    map("n", "<leader>tC", "<Plug>SnipReplMemoryClean", opts)

    map("v", "<leader>xs", ":SnipRun<cr>", opts)
    map("n", "<leader>xs", "<Plug>SnipRun", opts)
    map("n", "<leader>xc", "<Plug>SnipRunOperator", opts)
  end

  -- Can use: "!", "&", "gt", "gx"
end
return M
