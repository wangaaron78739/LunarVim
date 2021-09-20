local M = {}

local eval_line = "xx"
local eval_op = "x"
local eval_cell = "x<cr>"

local bmap = vim.api.nvim_buf_set_keymap

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

  -- FIXME: broot unable to open files correctly
  local fterms = setmetatable({
    down = under(nil),
    right = right(nil),
    term = popup(nil),
  }, {
    __index = function(tbl, key)
      local new = popup(key)
      tbl[key] = new
      return new
    end,
  })

  vim.api.nvim_set_keymap("n", "<M-i>", '<CMD>lua require("FTerm").toggle()<CR>', {})
  vim.api.nvim_set_keymap("t", "<M-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', {})
  -- map("t", "<Esc>", '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>', nore)

  function _G.ftopen(name)
    fterms[name]:open()
  end

  vim.cmd [[
    command! -nargs=1 FtOpen lua ftopen('<args>')
    command! -nargs=1 FtRun lua require'FTerm'.run('<args>\n')
    command! -nargs=1 FtScratch lua require'FTerm'.scratch({cmd='<args>'})
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
  bmap(0, "n", "<localleader>x", ":MagmaEvaluateOperator<CR>", { expr = true, silent = true })
  bmap(0, "v", "<localleader>x", "<cmd>MagmaEvaluateVisual<CR>", { silent = true })
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
  bmap(0, "v", "<localleader>x", "<Plug>(Luadev-Run)", { silent = true })
  -- bmap(0,"i", "", "<Plug>(Luadev-Complete)", { silent = true })
  -- bmap(0,"n", "<localleader>xw", "<Plug>(Luadev-RunWord)", { silent = true })
  -- bmap(
  --   0,
  --   "n",
  --   "<localleader>x",
  --   utils.operatorfunc_keys("luadev_exec", "<localleader>x"),
  --   { silent = true, noremap = true }
  -- )
end

function M.kitty()
  require("kitty-runner").setup {
    use_keymaps = false, --use keymaps
  }
  vim.cmd [[ command KittyOpen :lua require("lv-terms").activate_kitty() ]]
  vim.cmd [[ command KittyOpenLocal :lua require("lv-terms").activate_kitty('<local>') ]]
end

function M.activate_kitty(port)
  port = port or ""
  local ops = port == "<local>" and {
    prefix = "<localleader>",
    buffer = 0,
  } or {
    prefix = "<leader>",
    -- buffer = 0,
  }
  require("kitty-runner").open_new_runner(port)

  -- Once we start the kitty-runner we override (some) of the neoterm stuff
  mappings.whichkey({
    [vim.g.neoterm_automap_keys] = { "<cmd>KittyReRunCommand " .. port .. "<CR>", "Rerun" },
    tt = { "<cmd>KittyRunCommand " .. port .. "<CR>", "Run new" },
    ["t<space>"] = { "<cmd>KittyRunCommandOnce" .. port .. "<CR>", "Run once" },
  }, ops)
  bmap(0, "x", "<localleader>k", "<cmd>KittySendLines " .. port .. "<CR>", { silent = true, noremap = true })
  bmap(
    0,
    "n",
    "<localleader>k",
    utils.operatorfunc_keys("kitty_exec", "<localleader>k"),
    { silent = true, noremap = true }
  )
end

function M.keymaps(leaderMappings, vLeaderMappings)
  local cmd = utils.cmd
  local map = vim.api.nvim_set_keymap
  if O.plugin.neoterm then
    vim.cmd [[ command -nargs=+ Tmem :lua require("lv-terms").Tmem("<args>") ]]

    vim.g.neoterm_automap_keys = "<leader>x<cr>"
    -- Use gt to send to terminal
    map("n", "<leader>t<space>", ":Tmem ", {})
    map("n", "<leader>tt", ":T ", {})
    leaderMappings["t<space>"] = "Tmem ..."
    leaderMappings["tt"] = "T ..."
    leaderMappings["t<cr>"] = { cmd "Ttoggle", "Neoterm Toggle" }
    leaderMappings["tl"] = { cmd "Tls", "Neoterm list" }

    leaderMappings["xm"] = { "<Plug>(neoterm-repl-send)", "Neoterm Send" }
    leaderMappings["xn"] = { "<Plug>(neoterm-repl-send-line)", "Neoterm Line" }
    vLeaderMappings["xn"] = { "<Plug>(neoterm-repl-send)", "Neoterm Send" }
    leaderMappings["x<space>"] = "Neoterm AutoMap"
  end

  if O.plugin.kittyrunner then
    leaderMappings["tko"] = { "<cmd>KittyOpen<CR>", "Kitty Open" }
    leaderMappings["tkl"] = { "<cmd>KittyOpenLocal<CR>", "Kitty Local" }
    leaderMappings["xk"] = { "<cmd>KittyReRunCommand<CR>", "Kitty Rerun" }
    leaderMappings["xK"] = { "<cmd>KittyRunCommand<CR>", "Kitty Run" }
    leaderMappings["xl"] = { "<cmd>KittySendLines<CR>", "Kitty Send" }
    vLeaderMappings["xl"] = { "<cmd>KittySendLines<CR>", "Kitty Send" }
    -- TODO: add operator mapping
  end

  if O.plugin.floatterm then
    map("n", "<leader>tf", ":FtScratch ", {})
    map("n", "<leader>tF", ":FtRun ", {})
    leaderMappings["tf"] = "Scratch ..."
    leaderMappings["tF"] = "(F)Run ..."
  end

  if O.plugin.sniprun then
    leaderMappings["tp"] = { "<Plug>SnipClose", "SnipRun Close" }
    leaderMappings["tP"] = { "<cmd>SnipReset<cr>", "SnipRun Reset" }
    leaderMappings["tC"] = { "<Plug>SnipReplMemoryClean", "SnipRun Clean" }

    vLeaderMappings["xs"] = { "<cmd>SnipRun<cr>", "SnipRun" }
    leaderMappings["xs"] = { "<Plug>SnipRun", "SnipRun Line" }
    leaderMappings["xc"] = { "<Plug>SnipRun", "SnipRun" }
  end

  -- Can use: "!", "&", "gt", "gx"
end

function M.coderunner()
  require("code_runner").setup {
    filetype = { map = "<leader>xf" },
    project_context = { map = "<leader>xP" },
  }
end

return M
