local M = {}
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap

local mapper_meta = nil
local mapper_newindex = function(tbl, lhs, rhs)
  if tbl[1].buffer then
    bufmap(tbl[2], lhs, rhs, tbl[1])
  else
    map(tbl[2], lhs, rhs, tbl[1])
  end
end
local mapper_call = function(tbl, mode)
  if mode == nil then
    mode = tbl[2]
  end
  return function(args)
    if args == nil then
      args = tbl[1]
    end
    return setmetatable({ args, mode }, mapper_meta)
  end
end
local mapper_index = function(tbl, flag)
  if #flag == 1 then
    return setmetatable({ tbl[1], flag }, mapper_meta)
  else
    return setmetatable({
      vim.tbl_extend("force", { [flag] = true }, tbl[1]),
      tbl[2],
    }, mapper_meta)
  end
end
mapper_meta = {
  __index = mapper_index,
  __newindex = mapper_newindex,
  __call = mapper_call,
}
local mapper = setmetatable({ {}, "n" }, mapper_meta)

M.map = map
M.buf = bufmap
local sile = { silent = true }
local nore = { noremap = true, silent = true }
local expr = { noremap = true, silent = true, expr = true }
local function op_from(lhs, rhs, opts)
  if opts == nil then
    opts = nore
  end
  if rhs == nil then
    rhs = lhs
  end

  map("o", lhs, "<cmd>normal v" .. rhs .. "<cr>", opts)
end
M.op_from = op_from
local function sel_map(lhs, rhs, opts)
  if opts == nil then
    opts = nore
  end
  map("x", lhs, rhs, opts)
  op_from(lhs, rhs, opts)
end
M.sel_map = sel_map

function M.sile(mode, from, to)
  map(mode, from, to, sile)
end
function M.nore(mode, from, to)
  map(mode, from, to, nore)
end
function M.expr(mode, from, to)
  map(mode, from, to, expr)
end

-- Custom nN repeats
local custom_n_repeat = nil
local custom_N_repeat = nil
local feedkeys_ = vim.api.nvim_feedkeys
local termcode = vim.api.nvim_replace_termcodes
local feedkeys = function(keys, o)
  if o == nil then
    o = "m"
  end
  feedkeys_(termcode(keys, true, true, true), o, false)
end
function M.n_repeat()
  if custom_n_repeat == nil then
    feedkeys("n", "n")
  else
    feedkeys(custom_n_repeat)
  end
end
function M.N_repeat()
  if custom_N_repeat == nil then
    feedkeys("N", "n")
  else
    feedkeys(custom_N_repeat)
  end
end
local function register_nN_repeat(nN)
  custom_n_repeat = nN[1]
  custom_N_repeat = nN[2]
end
M.register_nN_repeat = register_nN_repeat

function M.init()
  -- Set leader keys
  if O.leader_key == " " or O.leader_key == "space" then
    map("n", "<Space>", "<NOP>", nore)
    vim.g.mapleader = " "
  else
    map("n", O.leader_key, "<NOP>", nore)
    vim.g.mapleader = O.leader_key
  end
  if O.local_leader_key == " " or O.local_leader_key == "space" then
    map("n", "<Space>", "<NOP>", nore)
    vim.g.maplocalleader = " "
  else
    map("n", O.local_leader_key, "<NOP>", nore)
    vim.g.maplocalleader = O.local_leader_key
  end

  local wk = require "which-key"
  wk.setup {
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = true, -- adds help for operators like d, y,...
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    window = {
      border = "single", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
    },
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
  }
end

local operatorfunc_scaffold = require("lv-utils").operatorfunc_scaffold
local operatorfunc_keys = require("lv-utils").operatorfunc_keys
local operatorfuncV_keys = require("lv-utils").operatorfuncV_keys
function M.setup()
  M.init()
  local wk = require "which-key"

  -- Helper functions
  local cmd = require("lv-utils").cmd
  local to_cmd = cmd.from
  local luacmd = cmd.lua
  local luareq = cmd.require
  local dap_fn = luareq "dap"
  local gitsigns_fn = luareq "gitsigns"
  local telescope_fn = luareq "lv-telescope.functions"
  local lspbuf = cmd.lsp
  local lsputil = luareq "lsp.functions"

  -- custom_n_repeat
  map("n", "n", luareq("keymappings").n_repeat, nore)
  map("n", "N", luareq("keymappings").N_repeat, nore)
  local fwdrepeat = function(k)
    return to_cmd(function()
      register_nN_repeat { nil, nil }
      feedkeys(k, "n")
    end)
  end
  map("n", "/", fwdrepeat "/", nore)
  map("n", "*", fwdrepeat "*", nore)
  map("n", "#", fwdrepeat "#", nore)

  -- Command mode typos of wq
  vim.cmd [[
    cnoreabbrev W! w!
    cnoreabbrev Q! q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wq wq
    cnoreabbrev Wa wa
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev Wq wq
    cnoreabbrev qw wq
    cnoreabbrev Qw wq
    cnoreabbrev QW wq
    cnoreabbrev qW wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]]

  -- <ctrl-s> to Save
  map("n", "<C-s>", cmd "write", sile)
  map("x", "<C-s>", cmd "write", sile)
  map("i", "<C-s>", cmd "write", sile)
  -- map("i", "<C-v>", "<C-R>+", sile)

  -- better window movement -- tmux_navigator supplies these if installed
  if not O.plugin.tmux_navigator then
    map("n", "<C-h>", "<C-w>h", sile)
    map("n", "<C-j>", "<C-w>j", sile)
    map("n", "<C-k>", "<C-w>k", sile)
    map("n", "<C-l>", "<C-w>l", sile)
  end
  -- TODO fix this
  -- Terminal window navigation
  map("t", "<C-h>", [[<C-\><C-N><C-w>h]], nore)
  map("t", "<C-j>", [[<C-\><C-N><C-w>j]], nore)
  map("t", "<C-k>", [[<C-\><C-N><C-w>k]], nore)
  map("t", "<C-l>", [[<C-\><C-N><C-w>l]], nore)
  map("i", "<C-h>", [[<C-\><C-N><C-w>h]], nore)
  map("i", "<C-j>", [[<C-\><C-N><C-w>j]], nore)
  map("i", "<C-k>", [[<C-\><C-N><C-w>k]], nore)
  map("i", "<C-l>", [[<C-\><C-N><C-w>l]], nore)
  map("t", "<Esc>", [[<C-\><C-n>]], nore)

  -- TODO fix this
  -- resize with arrows
  local resize_prefix = "<C-"
  if vim.fn.has "mac" == 1 then
    resize_prefix = "<M-"
  end
  map("n", resize_prefix .. "Up>", cmd "resize -2", sile)
  map("n", resize_prefix .. "Down>", cmd "resize +2", sile)
  map("n", resize_prefix .. "Left>", cmd "vertical resize -2", sile)
  map("n", resize_prefix .. "Right>", cmd "vertical resize +2", sile)

  -- Move current line / block with Alt-j/k ala vscode.
  map("n", "<C-M-j>", "<cmd>m .+1<cr>==", nore)
  map("n", "<C-M-k>", "<cmd>m .-2<cr>==", nore)
  map("i", "<M-j>", "<Esc>:m .+1<cr>==gi", nore)
  map("i", "<M-k>", "<Esc>:m .-2<cr>==gi", nore)
  map("x", "<M-j>", "<cmd>m '>+1<cr>gv-gv", nore)
  map("x", "<M-k>", "<cmd>m '<-2<cr>gv-gv", nore)
  -- Move selected line / block of text in visual mode
  map("x", "K", "<cmd>move '<-2<cr>gv=gv", nore)
  map("x", "J", "<cmd>move '>+1<cr>gv=gv", nore)

  -- better indenting
  map("n", "<", "<<", { silent = true, noremap = true, nowait = true })
  map("n", ">", ">>", { silent = true, noremap = true, nowait = true })
  map("n", "<<", "<<<<", { silent = true, noremap = true, nowait = true })
  map("n", ">>", ">>>>", { silent = true, noremap = true, nowait = true })
  map("n", "g<", "<", nore)
  map("n", "g>", ">", nore)
  map("x", "<", "<gv", nore)
  map("x", ">", ">gv", nore)

  -- I hate escape
  map("i", "jk", "<ESC>", sile)
  map("i", "kj", "<ESC>", sile)
  -- map("x", "jk", "<ESC>", nore)
  -- map("x", "kj", "<ESC>", nore)

  -- Tab switch buffer
  -- map('n', '<TAB>', ':bnext<cr>', nore)
  -- map('n', '<S-TAB>', ':bprevious<cr>', nore)
  map("n", "<TAB>", cmd "b#", nore)
  map("n", "<S-TAB>", cmd "bnext", nore)

  -- Preserve register on pasting in visual mode
  map("x", "p", "pgvy", nore)
  map("x", "P", "p", nore) -- for normal p behaviour

  -- Add meta version that doesn't affect the clipboard
  local function noclobber_meta(m, c)
    if string.upper(c) == c then
      map(m, "<M-S-" .. string.lower(c) .. ">", '"_' .. c, nore)
    else
      map(m, "<M-" .. c .. ">", '"_' .. c, nore)
    end
  end
  -- Make the default not touch the clipboard, and add a meta version that does
  local function noclobber_default(m, c)
    if string.upper(c) == c then
      map(m, "<M-S-" .. string.lower(c) .. ">", c, nore)
    else
      map(m, "<M-" .. c .. ">", c, nore)
    end
    map(m, c, '"_' .. c, nore)
  end
  noclobber_meta("n", "d")
  noclobber_meta("n", "D")
  noclobber_default("n", "c")
  noclobber_default("x", "c")
  noclobber_default("x", "C")

  -- Preserve cursor on yank in visual mode
  map("x", "y", "myy`y", nore)
  map("x", "Y", "myY`y", nore) -- copy linewise
  map("x", "<M-y>", "y", nore)

  -- -- Original paste for when 'nvim-anywise-reg.lua' is installed
  -- if O.plugin.anywise_reg then
  --   map("n", "<M-p>", "p", nore)
  --   map("n", "<M-S-P>", "P", nore)
  --   map("n", "<M-C-p>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pp]], nore) -- charwise paste
  --   map("n", "<M-S-C-P>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pP]], nore) -- charwise paste
  -- else

  -- Paste over textobject
  map("n", "r", operatorfunc_keys("paste_over", "p"), sile)
  map("n", "R", "r$", sile)
  -- map("n", "rr", "vvr", sile)
  map("n", "<M-C-p>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pp]], nore) -- charwise paste
  map("n", "<M-S-C-P>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pP]], nore) -- charwise paste
  -- map("n", "<M-S-p>", [[<cmd>call setreg('p', getreg('+'), 'l')<cr>"pp]], nore) -- linewise paste

  if false then
    -- Select next/previous text object
    map("n", "<M-w>", "wviw", sile)
    map("n", "<M-b>", "bviwo", sile)
    map("x", "<M-w>", "eowo", sile)
    map("x", "<M-b>", "oboge", sile)
    -- map("x", "<M-w>", "<Esc>wviw", sile)
    -- map("x", "<M-b>", "<Esc>bviwo", sile)
    map("n", "<M-S-W>", "WviW", sile)
    map("n", "<M-S-B>", "BviWo", sile)
    map("x", "<M-S-W>", "EOWO", sile)
    map("x", "<M-S-B>", "OBOGE", sile)
    --[[ map("x", "<M-S-W>", "<Esc>WviW", sile)
map("x", "<M-S-B>", "<Esc>BviWo", sile) ]]
    map("n", "<M-)>", "f(va(", sile)
    map("n", "<M-(>", "F)va)o", sile)
    map("x", "<M-)>", "<Esc>f(vi(", sile)
    map("x", "<M-(>", "<Esc>F)vi)", sile)
    -- map("n", "<M-j>", "jV", sile)
    -- map("n", "<M-k>", "kV", sile)
    -- map("x", "<M-j>", "<Esc>jV", sile)
    -- map("x", "<M-k>", "<Esc>kV", sile)
  end

  -- Start selecting
  map("x", "<M-l>", "l", sile)
  map("n", "<M-l>", "<c-v>l", sile)
  map("x", "<M-h>", "h", sile)
  map("n", "<M-h>", "<c-v>h", sile)

  -- Charwise visual select line
  map("x", "v", "^og_", nore)
  map("x", "V", "0o$", nore)

  -- move along visual lines, not numbered ones
  -- without interferring with {count}<down|up>
  map("n", "<up>", "v:count == 0 ? 'gk' : '<up>'", expr)
  map("x", "<up>", "v:count == 0 ? 'gk' : '<up>'", expr)
  map("n", "<down>", "v:count == 0 ? 'gj' : '<down>'", expr)
  map("x", "<down>", "v:count == 0 ? 'gj' : '<down>'", expr)

  -- Better nav for omnicomplete
  map("i", "<c-j>", '("\\<C-n>")', expr)
  map("i", "<TAB>", '("\\<C-n>")', expr)
  map("i", "<c-k>", '("\\<C-p>")', expr)
  map("i", "<S-TAB>", '("\\<C-p>")', expr)

  -- QuickFix
  -- map("n", "]q", cmd "cnext", nore)
  -- map("n", "[q", cmd "cprev", nore)
  local quickfix_nN = { cmd "cnext", cmd "cprev" }
  map(
    "n",
    "]q",
    to_cmd(function()
      register_nN_repeat(quickfix_nN)
      vim.cmd [[cnext]]
    end),
    nore
  )
  map(
    "n",
    "[q",
    to_cmd(function()
      register_nN_repeat(quickfix_nN)
      vim.cmd [[cprev]]
    end),
    nore
  )
  -- map("n", "<C-M-j>", cmd "cnext", nore)
  -- map("n", "<C-M-k>", cmd "cprev", nore)

  -- Diagnostics jumps
  -- map("n", "]d", lsputil.diag_next, nore)
  -- map("n", "[d", lsputil.diag_prev, nore)
  local diag_nN = { lsputil.diag_next, lsputil.diag_prev }
  local diag_next = to_cmd(function()
    register_nN_repeat(diag_nN)
    require("lsp.functions").diag_next()
  end)
  local diag_prev = to_cmd(function()
    register_nN_repeat(diag_nN)
    require("lsp.functions").diag_prev()
  end)
  map("n", "]d", diag_next, nore)
  map("n", "[d", diag_prev, nore)

  -- Search for the current selection
  map("x", "*", '"z<M-y>/<C-R>z<cr>', nore) -- Search for the current selection
  map("n", "<M-s>", operatorfunc_keys("search_for", "*"), {}) -- Search textobject

  -- Select last changed/yanked text
  map("n", "+", [[/<C-R>+<cr>]], {}) -- Search for the current yank register
  sel_map("+", "`[o`]")

  -- Start search and replace from search
  map("c", "<M-r>", [[<cr>:%s/<C-R>///g<Left><Left>]], {})

  -- Continue the search and keep selecting (equivalent ish to doing `gn` in normal)
  map("x", "n", "<esc>ngn", nore)
  map("x", "N", "<esc>NgN", nore)
  -- Select the current/next search match
  map("x", "gn", "<esc>gn", nore)
  map("x", "gN", "<esc>NNgN", nore) -- current/prev

  -- Double Escape key clears search and spelling highlights
  -- map("n", "<Plug>ClearHighLights", ":nohls | :setlocal nospell | call minimap#vim#ClearColorSearch()<ESC>", nore)
  map("n", "<Plug>ClearHighLights", ":nohls | :setlocal nospell<cr>", nore)
  map("n", "<ESC>", "<Plug>ClearHighLights", sile)

  -- Map `cp` to `xp` (transpose two adjacent chars)
  -- as a **repeatable action** with `.`
  -- (since the `@=` trick doesn't work
  -- nmap cp @='xp'<cr>
  -- http://vimcasts.org/transcripts/61/en/
  map("n", "<Plug>TransposeCharacters", [[xp<cmd>call repeat#set("\<Plug>TransposeCharacters")<cr>]], nore)
  map("n", "cp", "<Plug>TransposeCharacters", {})
  -- Make xp repeatable
  -- map("n", "xp", "<Plug>TransposeCharacters", {})

  -- Yank till end of the line
  map("n", "Y", "y$", nore)

  -- Go Back
  map("n", "gb", "<c-o>", nore)
  map("n", "GB", "<c-i>", nore)

  -- Commenting helpers
  map("n", "gcj", "gccjgcc", sile)
  map("n", "gck", "gcckgcc", sile)
  map("n", "gcO", "O-<esc>gccA<BS>", sile)
  map("n", "gco", "o-<esc>gccA<BS>", sile)

  -- comment and copy
  map("x", "gy", '"z<M-y>gvgc`>"zp`[', sile)
  map("n", "gy", operatorfuncV_keys("comment_copy", "gy"), sile)
  -- map("n", "gyy", "Vgy", sile)

  -- Select Jupyter Cell
  -- Change to onoremap
  map("x", "ic", [[/#+\s*%+<cr>oN]], nore)

  -- Spell checking
  map("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u]]", nore)

  -- Vscode style commenting in insert mode
  map("i", "<C-/>", "<C-\\><C-n><cmd>CommentToggle<cr>", nore)

  -- Slightly easier commands
  map("n", ";", ":", {})
  map("x", ";", ":", {})
  -- map('c', ';', "<cr>", sile)

  -- Add semicolon
  map("i", ";;", "<esc>mzA;", nore)

  -- lsp keys
  map("n", "gd", luacmd "vim.lsp.buf.definition()", sile)
  map("n", "gD", luacmd "vim.lsp.buf.declaration()", sile)
  map("n", "gr", luacmd "vim.lsp.buf.references()", sile)
  map("n", "gi", luacmd "vim.lsp.buf.implementation()", sile)
  map("n", "gK", luacmd "vim.lsp.codelens.run()", sile)
  -- map("n", "<C-k>", luacmd "vim.lsp.buf.signature_help()", sile)
  -- Preview variants
  map("n", "gpd", luacmd [[require("lsp.functions").preview_location_at("definition")]], sile)
  map("n", "gpD", luacmd [[require("lsp.functions").preview_location_at("declaration")]], sile)
  map("n", "gpr", luacmd [[require("lsp.functions").preview_location_at("references")]], sile)
  map("n", "gpi", luacmd [[require("lsp.functions").preview_location_at("implementation")]], sile)
  -- Hover
  -- map("n", "K", luacmd "vim.lsp.buf.hover()", sile)
  map("n", "gh", luacmd "vim.lsp.buf.hover()", sile)
  map("n", "K", luacmd "vim.lsp.buf.code_action()", {})
  map("v", "K", "<esc><cmd>'<,'>lua vim.lsp.buf.range_code_action()<cr>", {})

  -- Formatting keymaps
  map("n", "gm", luacmd [[require("lsp.functions").format_range_operator()]], sile)
  -- map("n", "=", luacmd [[require("lsp.functions").format_range_operator()]], sile)
  map("x", "gm", luacmd "vim.lsp.buf.range_formatting()", sile)
  -- map("x", "=", luacmd "vim.lsp.buf.range_formatting()", sile)
  map("n", "gf", luacmd "vim.lsp.buf.formatting()", sile)
  -- map("n", "==", luacmd "vim.lsp.buf.formatting()", sile)

  -- TODO: Use more standard regex syntax
  -- map("n", "/", "/\v", nore)

  -- Open a new line in normal mode
  map("n", "<cr>", "o<esc>", nore)
  map("n", "<M-cr>", "O<esc>", nore)

  -- Split line
  map("n", "go", "i<cr><ESC>k<cmd>sil! keepp s/\v +$//<cr><cmd>noh<cr>j^", nore)

  -- Quick activate macro
  map("n", "Q", "@q", nore)

  -- Reselect visual linewise
  map("n", "gV", "'<V'>", nore)
  map("x", "gV", "<esc>'<V'>", nore)
  -- Reselect visual block wise
  map("n", "g<C-v>", "'<C-v>'>", nore)
  map("x", "g<C-v>", "<esc>'<C-v>'>", nore)

  -- Use reselect as an operator
  op_from "gv"
  op_from "gV"
  op_from "g<C-v>"

  local function undo_brkpt(key)
    -- map("i", key, key .. "<c-g>u", nore)
    map("i", key, "<c-g>u" .. key, nore)
  end
  local undo_brkpts = {
    "<cr>",
    ",",
    ".",
    ";",
    "{",
    "}",
    "[",
    "]",
    "(",
    ")",
    "'",
    '"',
  }
  for _, v in ipairs(undo_brkpts) do
    undo_brkpt(v)
  end
  map("n", "U", "<C-R>", nore)

  -- Go to multi insert from Visual mode
  map("x", "I", "<M-a>i", sile)
  map("x", "A", "<M-a>a", sile)

  -- Select all matching regex search
  -- map("n", "<M-S-/>", "<M-/><M-a>", {})

  -- Multi select object
  map("n", "<M-v>", operatorfunc_keys("multiselect", "<M-n>"), sile)
  -- Multi select all
  map("n", "<M-S-v>", operatorfunc_keys("multiselect_all", "<M-S-a>"), sile)

  -- Keymaps for easier access to 'ci' and 'di'
  local function quick_inside(key)
    map("o", key, "i" .. key, {})
    map("o", "<M-" .. key .. ">", "a" .. key, {})
    map("n", "<M-" .. key .. ">", "vi" .. key, {})
    map("n", "<C-M-" .. key .. ">", "va" .. key, {})
  end
  local function quick_around(key)
    map("o", key, "a" .. key, {})
    map("n", "<M-" .. key .. ">", "va" .. key, {})
  end
  quick_inside "w"
  quick_inside "W"
  quick_inside "b"
  quick_inside "B"
  quick_inside "["
  quick_around "]"
  quick_inside "("
  quick_around "]"
  quick_inside "{"
  quick_around "]"
  quick_inside '"'
  quick_inside "'"
  map("n", "<M-.>", "v.", {})
  map("n", "<M-;>", "v;", {})
  -- map("n", "r", '"_ci', {})
  -- map("n", "x", "di", {})
  -- map("n", "X", "x", nore)
  map("n", "<BS>", "X", nore)
  map("n", "<M-BS>", "x", nore)

  -- "better" end and beginning of line
  map("o", "H", "^", {}) -- do ^ first then 0
  map("o", "L", "$", {})
  -- map("n", "H", "^", {})
  map("n", "H", [[col('.') == match(getline('.'),'\S')+1 ? '0' : '^']], expr) -- do ^ first then 0
  map("n", "L", "$", {})

  -- map("n", "m-/", "")

  -- Free keys
  map("n", "C-q", "<NOP>", {})
  map("n", "C-n", "<NOP>", {})
  map("n", "C-p", "<NOP>", {})
  map("n", "C-o", "<NOP>", {})

  -- Select whole file
  map("o", "ie", "<cmd>normal! mzggVG<cr>`z", nore)
  map("x", "ie", "gg0oG$", nore)

  -- Operator for current line
  -- sel_map("il", "g_o^")
  -- sel_map("al", "$o0")

  -- Make change line (cc) preserve indentation
  map("n", "cc", "^cg_", sile)

  -- add j and k with count to jumplist
  map("n", "j", [[(v:count > 1 ? "m'" . v:count : '') . 'j']], expr)
  map("n", "k", [[(v:count > 1 ? "m'" . v:count : '') . 'k']], expr)

  -- Plugin keymaps
  require("lv-hop").keymaps()
  require("lv-zen").keymaps()
  require("lv-dial").keymaps()
  require("lv-neoterm").keymaps()

  -- Terminal pass through escape key
  map("t", "<ESC>", "<ESC>", nore)
  map("t", "<ESC><ESC>", [[<C-\><C-n>]], nore)

  -- Leader shortcut for ][ jumping
  map("n", "<leader>j", "]", {})
  map("n", "<leader>k", "[", {})

  local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = false,
    -- silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }
  local visualOpts = {
    mode = "v", -- Visual mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = false,
    -- silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  -- TODO create entire treesitter section

  -- TODO support vim-sandwich in the which-key menus
  local leaderMappings = {
    -- [" "] = { telescope_fn(.commands), "Commands" },
    [" "] = { telescope_fn.buffers, "Buffers" },
    [";"] = { cmd "Dashboard", "Dashboard" },
    ["/"] = { telescope_fn.live_grep, "Global search" },
    f = { telescope_fn.find_files, "Find File" },
    j = "Jump next (])",
    k = "Jump prev ([)",
    w = { cmd "w", "Write" }, -- w = { cmd "up", "Write" },
    W = { cmd "noau w", "Write (noau)" }, -- w = { cmd "noau up", "Write" },
    o = {
      name = "Toggle window",
      f = { cmd "NvimTreeToggle", "File Sidebar" },
      u = { cmd "UndotreeToggle", "Undo tree" },
      r = { cmd "RnvimrToggle", "Ranger" },
      q = { luareq("lv-utils").quickfix_toggle, "Quick fixes" },
      o = { cmd "!open '%:p:h'", "Open File Explorer" },
      F = { telescope_fn.file_browser, "Telescope browser" },
      v = { cmd "Vista nvim_lsp", "Vista" },
      -- ["v"] = {cmd "Vista", "Vista"},
      m = { cmd "MinimapToggle", "Minimap" },
      b = { luacmd "ftopen('broot')", "Broot" },
      p = { luacmd "ftopen('python')", "Python" },
      t = { luacmd "ftopen('top')", "System Monitor" },
      S = { luacmd "ftopen('spt')", "Spotify" },
      l = { luacmd "ftopen('right')", "Terminal" },
    },
    t = {
      name = "Terminals",
      -- TODO: Slime commands or replace slime with neoterm
      t = { cmd "Ttoggle", "Neoterm" },
      r = { cmd "TREPLSetTerm ", "Neoterm set repl..." },
      l = { cmd "Tls", "Neoterm list" },
      s = "Slime Line",
      M = { ":Tmap ", "Neoterm map a command" },
      -- t = {luacmd "ftopen('right')", "Terminal" },
      -- t = { luareq'FTerm'.toggle , "Terminal" },
    },
    T = {
      name = "Toggle Opts",
      w = { cmd "setlocal wrap!", "Wrap" },
      s = { cmd "setlocal spell!", "Spellcheck" },
      c = { cmd "setlocal cursorcolumn!", "Cursor column" },
      g = { cmd "setlocal signcolumn!", "Cursor column" },
      l = { cmd "setlocal cursorline!", "Cursor line" },
      h = { cmd "setlocal hlsearch", "hlsearch" },
      -- TODO: Toggle comment visibility
    },
    b = {
      name = "Buffers",
      j = { telescope_fn.buffers, "Jump to " },
      w = { cmd "w", "Write" },
      a = { cmd "wa", "Write All" },
      c = { cmd "bdelete!", "Close" },
      f = { lspbuf.formatting, "Format" },
      -- n = { cmd "tabnew", "New" },
      n = { cmd "enew", "New" },
      -- W = {cmd "BufferWipeout", "wipeout buffer"},
      -- e = {
      --     cmd "BufferCloseAllButCurrent",
      --     "close all but current buffer"
      -- },
      h = { cmd "BufferLineCloseLeft", "close all buffers to the left" },
      l = { cmd "BufferLineCloseRight", "close all BufferLines to the right" },
      D = { cmd "BufferLineSortByDirectory", "sort BufferLines automatically by directory" },
      L = { cmd "BufferLineSortByExtension", "sort BufferLines automatically by language" },
      t = { cmd("vnew term://" .. O.termshell .. ""), "Terminal" },
    },
    D = {
      -- " Available Debug Adapters:
      -- "   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
      -- "
      -- " Adapter configuration and installation instructions:
      -- "   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
      -- "
      -- " Debug Adapter protocol:
      -- "   https://microsoft.github.io/debug-adapter-protocol/
      name = "Debug",
      t = { dap_fn.toggle_breakpoint, "Toggle Breakpoint" },
      b = { dap_fn.step_back, "Step Back" },
      c = { dap_fn.continue, "Continue" },
      C = { dap_fn.run_to_cursor, "Run To Cursor" },
      d = { dap_fn.disconnect, "Disconnect" },
      g = { dap_fn.session, "Get Session" },
      i = { dap_fn.step_into, "Step Into" },
      o = { dap_fn.step_over, "Step Over" },
      u = { dap_fn.step_out, "Step Out" },
      p = { dap_fn.pause.toggle, "Pause" },
      r = { dap_fn.repl.toggle, "Toggle Repl" },
      s = { dap_fn.continue, "Start" },
      q = { dap_fn.stop, "Quit" },
    },
    g = {
      name = "Git",
      g = { luacmd "ftopen('gitui')", "Gitui" },
      m = { cmd "!smerge '%:p:h'", "Sublime Merge" },
      j = { gitsigns_fn.next_hunk, "Next Hunk" }, -- TODO: make nN repeatable
      k = { gitsigns_fn.prev_hunk, "Prev Hunk" },
      l = { gitsigns_fn.blame_line, "Blame" },
      L = { cmd "GitBlameToggle", "Blame Toggle" },
      p = { gitsigns_fn.preview_hunk, "Preview Hunk" },
      r = { gitsigns_fn.reset_hunk, "Reset Hunk" },
      R = { gitsigns_fn.reset_buffer, "Reset Buffer" },
      s = { gitsigns_fn.stage_hunk, "Stage Hunk" },
      u = { gitsigns_fn.undo_stage_hunk, "Undo Stage Hunk" },
      o = { telescope_fn.git_status, "Open changed file" },
      b = { telescope_fn.git_branches, "Checkout branch" },
      c = { telescope_fn.git_commits, "Checkout commit" },
      C = { telescope_fn.git_bcommits, "Checkout commit(for current file)" },
    },
    l = {
      name = "LSP",
      a = { lspbuf.code_action, "Code Action (K)" },
      h = { lspbuf.hover, "Code Action (gh)" },
      I = { cmd "LspInfo", "Info" },
      -- TODO: What is the replacement for this?
      -- f = { cmd"Lspsaga lsp_finder", "LSP Finder" },
      -- p = { cmd"Lspsaga preview_definition", "Preview Definition" },
      r = { telescope_fn.lsp_references, "References" },
      t = { lspbuf.type_definition, "Type Definition" },
      s = { lspbuf.signature_help, "Signature Help" },
      T = { cmd "TSConfigInfo", "Info" },
      f = { lspbuf.formatting, "Format" },
    },
    s = {
      name = "Search",
      b = { telescope_fn.git_branches, "Checkout branch" },
      c = { telescope_fn.colorscheme, "Colorscheme" },
      s = { telescope_fn.lsp_document_symbols, "Document Symbols" },
      S = { telescope_fn.lsp_dynamic_workspace_symbols, "Workspace Symbols" },
      d = { telescope_fn.lsp_document_diagnostics, "Document Diagnostics" },
      D = { telescope_fn.lsp_workspace_diagnostics, "Workspace Diagnostics" },
      m = { telescope_fn.lsp_implementations, "Workspace Diagnostics" },
      h = { telescope_fn.help_tags, "Find Help" },
      -- m = {telescope_fn(.marks), "Marks"},
      M = { telescope_fn.man_pages, "Man Pages" },
      R = { telescope_fn.oldfiles, "Open Recent File" },
      -- R = { telescope_fn.registers, "Registers" },
      t = { telescope_fn.live_grep, "Text" },
      k = { telescope_fn.keymaps, "Keymappings" },
      o = { cmd "TodoTelescope", "TODOs" },
      q = { telescope_fn.quickfix, "Quickfix" },
      ["*"] = { telescope_fn.grep_string, "cword" },
      ["/"] = { telescope_fn.grep_last_search, "Last Search" },
      i = "for (object)",
      r = { [[:%s///g<Left><Left><Left>]], "and Replace" },
    },
    r = {
      name = "Replace/Refactor",
      n = { lsputil.rename, "Rename" },
      t = "Rename TS",
      ["/"] = { [[:%s/<C-R>+//g<Left><Left>]], "Last search" },
      ["+"] = { [[:%s/<C-R>///g<Left><Left>]], "Last yank" },
      ["."] = { [[:%s/<C-R>.//g<Left><Left>]], "Last insert" },
      d = { cmd "DogeGenerate", "DogeGen" },
    },
    d = {
      name = "Diagnostics",
      j = { diag_next, "Next" },
      k = { diag_prev, "Previous" },
      i = { lsputil.toggle_diagnostics, "Toggle Inline" },
      l = { lsputil.diag_line, "Line Diagnostics" },
      c = { lsputil.diag_cursor, "Cursor Diagnostics" },
      v = {
        -- TODO: make this not move the cursor
        operatorfunc_scaffold("show_diagnostics", require("lsp.functions").range_diagnostics),
        "Range Diagnostics",
      },
    },
    P = {
      name = "Packer",
      c = { cmd "PackerCompile", "Compile" },
      i = { cmd "PackerInstall", "Install" },
      r = { cmd "luafile %", "Reload" },
      s = { cmd "PackerSync", "Sync" },
      u = { cmd "PackerUpdate", "Update" },
    },
    a = {
      name = "Swap",
      [" "] = { cmd "ISwap", "Interactive" },
      ["w"] = { cmd "ISwapWith", "I. With" },
    },
    -- m = "Multi",
    m = "which_key_ignore",
    c = {
      operatorfunc_keys("change_all", "<leader>c"),
      "Change all",
    },
  }

  local visualMappings = {
    -- ["/"] = { cmd "CommentToggle", "Comment" },
    dv = { lsputil.range_diagnostics, "Range Diagnostics" },
    r = { name = "Replace/Refactor" },
    c = {
      [["z<M-y>:%s/<C-r>z//g<Left><Left>]],
      "Change all",
    },
  }

  -- TODO: move these to different modules?
  if O.plugin.symbol_outline then
    leaderMappings["o"]["S"] = { cmd "SymbolsOutline", "Symbols Sidebar" }
  end
  if O.plugin.todo_comments then
    leaderMappings["o"]["T"] = { cmd "TodoTrouble", "Todos Sidebar" }
  end
  if O.plugin.trouble then
    leaderMappings["dt"] = { cmd "TroubleToggle", "Trouble Toggle" }
    leaderMappings["dd"] = { cmd "TroubleToggle lsp_document_diagnostics", "Document" }
    leaderMappings["dw"] = { cmd "TroubleToggle lsp_workspace_diagnostics", "Workspace" }
    leaderMappings["dr"] = { cmd "TroubleToggle lsp_references", "References" }
    leaderMappings["dD"] = { cmd "TroubleToggle lsp_definitions", "Definitions" }
    leaderMappings["dq"] = { cmd "TroubleToggle quickfix", "Quick Fixes" }
    leaderMappings["dL"] = { cmd "TroubleToggle loclist", "Location List" }
    leaderMappings["do"] = { cmd "TroubleToggle todo", "TODOs" }
  end
  if O.plugin.gitlinker then
    leaderMappings["gy"] = "Gitlink"
  end
  leaderMappings["z"] = { name = "Zen" }
  if O.plugin.zen then
    leaderMappings["zz"] = { cmd "TZAtaraxis", "Ataraxis" }
    leaderMappings["zf"] = { cmd "TZFocus", "Focus" }
    leaderMappings["zm"] = { cmd "TZMinimalist", "Minimalist" }
  end
  if O.plugin.twilight then
    leaderMappings["zt"] = { cmd "Twilight", "Twilight" }
  end
  if O.plugin.telescope_project then
    leaderMappings["p"] = { "Projects" }
    leaderMappings["pp"] = { luareq "telescope" "extensions.project.project{}", "Projects" }
  end
  if O.plugin.project_nvim then
    leaderMappings["p"] = { "Projects" }
    leaderMappings["pr"] = { cmd "ProjectRoot", "Projects" }
  end
  if O.plugin.spectre then
    local spectre = luareq "spectre"
    leaderMappings["rf"] = { spectre.open_file_search, "Current File" }
    leaderMappings["rp"] = { spectre.open, "Project" }
    visualMappings["rf"] = { spectre "open_visual({path = vim.fn.expand('%')})", "Current File" }
    visualMappings["rp"] = { spectre.open_visual, "Project" }
  end
  if O.plugin.lazygit then
    leaderMappings["gg"] = { cmd "LazyGit", "LazyGit" }
  end
  if O.lang.latex.active then
    leaderMappings["L"] = {
      name = "Latex",
      f = { cmd "call vimtex#fzf#run()", "Fzf Find" },
      i = { cmd "VimtexInfo", "Project Information" },
      s = { cmd "VimtexStop", "Stop Project Compilation" },
      t = { cmd "VimtexTocToggle", "Toggle Table Of Content" },
      v = { cmd "VimtexView", "View PDF" },
      c = { cmd "VimtexCompile", "Compile Project Latex" },
      o = { cmd "VimtexCompileOutput", "Compile Output Latex" },
    }
  end
  if O.plugin.neoterm then
    leaderMappings[O.plugin.neoterm.automap_keys] = "Neoterm AutoMap"
  end
  if O.lushmode then
    leaderMappings["L"] = {
      name = "+Lush",
      l = { cmd "Lushify", "Lushify" },
      x = { luacmd "require('lush').export_to_buffer(require('lush_theme.cool_name'))", "Lush Export" },
      t = { cmd "LushRunTutorial", "Lush Tutorial" },
      q = { cmd "LushRunQuickstart", "Lush Quickstart" },
    }
  end
  if O.plugin.magma then
    leaderMappings["to"] = { cmd "MagmaShowOutput", "Magma Output" }
    leaderMappings["tm"] = { cmd "MagmaInit", "Magma Init" }
  end

  wk.register(leaderMappings, opts)
  wk.register(visualMappings, visualOpts)

  -- TODO: move to plugin config files?
  if O.plugin.surround then
    local ops = { mode = "o" }
    wk.register({ ["s"] = "Surround", ["S"] = "Surround Rest", ["ss"] = "Line" }, ops)
  end
  if O.plugin.lightspeed then
    local ops = { mode = "o" }
    wk.register({ ["z"] = "Light speed", ["Z"] = "Light speed bwd" }, ops)
  end

  local ops = { mode = "n" }
  wk.register({ ["gy"] = "which_key_ignore", ["gyy"] = "which_key_ignore" }, ops)

  -- TODO: register all g prefix keys in whichkey

  -- FIXME: duplicate entries for some of the operators
end

return M
-- return setmetatable(M, {
--   __call = function(tbl, ...)
--     return map(unpack(...))
--   end,
-- })
