-- TODO: replace all keymaps with functions or something
-- TODO: <[cC][mM][dD]>lua
local M = {}
local map = vim.keymap.set

-- Custom nN repeats
local custom_n_repeat = nil
local custom_N_repeat = nil
local feedkeys_ = vim.api.nvim_feedkeys
local termcode = vim.api.nvim_replace_termcodes
local function feedkeys(keys, o)
  if o == nil then
    o = "m"
  end
  feedkeys_(termcode(keys, true, true, true), o, false)
end
function M.n_repeat()
  -- vim.cmd [[normal! m']]
  if custom_n_repeat == nil then
    feedkeys("n", "n")
  else
    feedkeys(custom_n_repeat)
  end
end
function M.N_repeat()
  -- vim.cmd [[normal! m']]
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

-- Helper functions
local cmd = require("lv-utils").cmd
local luareq = cmd.require
local gitsigns_fn = luareq "gitsigns"
local telescope_fn = require "lv-telescope.functions"
local focus_fn = luareq "focus"
local lspbuf = cmd.lsp
local lsputil = require "lsp.functions"
local operatorfunc_scaffold = require("lv-utils").operatorfunc_scaffold
local operatorfunc_keys = require("lv-utils").operatorfunc_keys
local operatorfuncV_keys = require("lv-utils").operatorfuncV_keys
local function make_nN_pair(pair)
  return {
    function()
      vim.cmd [[normal! m']]
      register_nN_repeat(pair)
      if type(pair[1]) == "string" then
        feedkeys(pair[1])
      else
        pair[1]()
      end
    end,
    function()
      vim.cmd [[normal! m']]
      register_nN_repeat(pair)
      if type(pair[2]) == "string" then
        feedkeys(pair[2])
      else
        pair[2]()
      end
    end,
  }
end
M.make_nN_pair = make_nN_pair

vim.g.libmodalTimeouts = "1"
function M.libmodal_setup()
  local libmodal = require "libmodal"

  -- TODO fix this
  -- resize with arrows
  local resize_mode
  resize_mode = libmodal.Layer.new {
    n = {
      ["<Up>"] = { rhs = cmd "resize -2" },
      ["<Down>"] = { rhs = cmd "resize +2" },
      ["<Left>"] = { rhs = cmd "vertical resize -2" },
      ["<Right>"] = { rhs = cmd "vertical resize +2" },
      ["<ESC>"] = {
        rhs = function()
          resize_mode:exit()
        end,
      },
    },
  }
  map("n", "<C-w><CR>", function()
    resize_mode:enter()
  end)
end

vim.keymap.setl = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts or {}, { buffer = 0 }))
end
local sile = { silent = true, remap = true }
local nore = { noremap = true, silent = true }
local norexpr = { noremap = true, silent = true, expr = true }
local expr = { silent = true, expr = true }
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
function M.norexpr(mode, from, to)
  map(mode, from, to, norexpr)
end

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
    map("n", O.local_leader_key, function()
      require("which-key").show(",", { mode = "n" })
    end, nore)
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

function M.setup()
  M.init()
  local wk = require "which-key"

  -- Free keys for reference
  map("n", "<C-q>", "<NOP>", {})
  map("n", "<C-p>", "<NOP>", {})
  -- map("n", "<C-o>", "<NOP>", {})

  -- custom_n_repeat
  map("n", "n", M.n_repeat, nore)
  map("n", "N", M.N_repeat, nore)
  local function srchrpt(k, op)
    return function()
      register_nN_repeat { nil, nil }
      feedkeys(k, op or "n")
    end
  end
  map("n", "/", srchrpt "/", nore)
  map("n", "?", srchrpt "?", nore)
  map("n", "*", srchrpt("viw*", "m"), nore) -- Swap g* and *
  map("n", "#", srchrpt("viw#", "m"), nore)
  map("n", "g*", srchrpt "*", nore)
  map("n", "g#", srchrpt "#", nore)
  map("n", "g.", [[/\V<C-r>"<CR>]] .. "cgn<C-a><ESC>") -- Repeat the recent edit with cgn

  -- Command mode typos of wq
  --   vim.cmd [[
  --     cnoreabbrev W! w!
  --     cnoreabbrev Q! q!
  --     cnoreabbrev Qa! qa!
  --     cnoreabbrev Qall! qall!
  --     cnoreabbrev Wq wq
  --     cnoreabbrev Wa wa
  --     cnoreabbrev wQ wq
  --     cnoreabbrev WQ wq
  --     cnoreabbrev Wq wq
  --     cnoreabbrev qw wq
  --     cnoreabbrev Qw wq
  --     cnoreabbrev QW wq
  --     cnoreabbrev qW wq
  --     cnoreabbrev W w
  --     cnoreabbrev Q q
  --     cnoreabbrev Qa qa
  --     cnoreabbrev Qall qall
  -- ]]
  map("c", "<C-v>", "'<,'>")

  vim.o.mousetime = 0
  -- map("n", "<2-ScrollWheelUp>", "<nop>", sile)
  -- map("n", "<2-ScrollWheelDown>", "<nop>", sile)
  -- map("n", "<3-ScrollWheelUp>", "<nop>", sile)
  -- map("n", "<3-ScrollWheelDown>", "<nop>", sile)
  -- map("n", "<4-ScrollWheelUp>", "<nop>", sile)
  -- map("n", "<4-ScrollWheelDown>", "<nop>", sile)
  -- map("n", "<ScrollWheelUp>", "<C-a>", sile)
  -- map("n", "<ScrollWheelDown>", "<C-x>", sile)
  map("n", "<C-ScrollWheelUp>", "<C-a>", sile)
  map("n", "<C-ScrollWheelDown>", "<C-x>", sile)
  map("n", "<C-S-ScrollWheelUp>", cmd "FontUp", sile)
  map("n", "<C-S-ScrollWheelDown>", cmd "FontDown", sile)
  map("n", "<C-->", cmd "FontDown", sile)
  -- map("n", "<C-S-=>", cmd "FontUp", sile)
  map("n", "<C-+>", cmd "FontUp", sile)

  -- More convenient incr/decr
  map("n", "+", "<C-a>", sile) -- recursive so we get dial.nvim
  map("n", "-", "<C-x>", sile)
  map("x", "+", "g<C-a>", sile)
  map("x", "-", "g<C-x>", sile)

  vim.o.mousetime = 0
  -- map("n", "<2-ScrollWheelUp>", "<nop>", sile)
  -- map("n", "<2-ScrollWheelDown>", "<nop>", sile)
  -- map("n", "<3-ScrollWheelUp>", "<nop>", sile)
  -- map("n", "<3-ScrollWheelDown>", "<nop>", sile)
  -- map("n", "<4-ScrollWheelUp>", "<nop>", sile)
  -- map("n", "<4-ScrollWheelDown>", "<nop>", sile)
  -- map("n", "<ScrollWheelUp>", "<C-a>", sile)
  -- map("n", "<ScrollWheelDown>", "<C-x>", sile)
  map("n", "<C-ScrollWheelUp>", "<C-a>", sile)
  map("n", "<C-ScrollWheelDown>", "<C-x>", sile)
  map("n", "<C-S-ScrollWheelUp>", cmd "FontUp", sile)
  map("n", "<C-S-ScrollWheelDown>", cmd "FontDown", sile)
  map("n", "<C-->", cmd "FontDown", sile)
  -- map("n", "<C-S-=>", cmd "FontUp", sile)
  map("n", "<C-+>", cmd "FontUp", sile)

  -- More convenient incr/decr
  map("n", "+", "<C-a>", sile) -- recursive so we get dial.nvim
  map("n", "-", "<C-x>", sile)
  map("x", "+", "g<C-a>", sile)
  map("x", "-", "g<C-x>", sile)

  -- better window movement -- tmux_navigator supplies these if installed
  if not O.plugin.tmux_navigator then
    if O.plugin.splitfocus then
      -- FIXME: this automatically reenables Focus mode
      map("n", "<C-h>", focus_fn "split_command('h')", nore)
      map("n", "<C-j>", focus_fn "split_command('j')", nore)
      map("n", "<C-k>", focus_fn "split_command('k')", nore)
      map("n", "<C-l>", focus_fn "split_command('l')", nore)
      map("n", "<C-w>v", focus_fn "split_command('l')", nore)
      map("n", "<C-w>s", focus_fn "split_nicely()", nore)
      map("n", "<C-w>e", focus_fn "focus_equalise()", nore)
    else
      map("n", "<C-h>", "<C-w>h", sile)
      map("n", "<C-j>", "<C-w>j", sile)
      map("n", "<C-k>", "<C-w>k", sile)
      map("n", "<C-l>", "<C-w>l", sile)
    end
  end
  -- TODO fix this
  -- Terminal window navigation
  -- map("t", "<C-h>", [[<C-\><C-N><C-w>h]], nore)
  -- map("t", "<C-j>", [[<C-\><C-N><C-w>j]], nore)
  -- map("t", "<C-k>", [[<C-\><C-N><C-w>k]], nore)
  -- map("t", "<C-l>", [[<C-\><C-N><C-w>l]], nore)
  map("t", "<C-h>", [[<C-\><C-N>]] .. focus_fn "split_command('h')", sile)
  map("t", "<C-j>", [[<C-\><C-N>]] .. focus_fn "split_command('j')", sile)
  map("t", "<C-k>", [[<C-\><C-N>]] .. focus_fn "split_command('k')", sile)
  map("t", "<C-l>", [[<C-\><C-N>]] .. focus_fn "split_command('l')", sile)
  map("t", "<Esc>", [[<C-\><C-n>]], nore)

  local resize_prefix = "<C-"
  if vim.fn.has "mac" == 1 then
    resize_prefix = "<M-"
  end
  map("n", resize_prefix .. "Up>", cmd "resize -2", sile)
  map("n", resize_prefix .. "Down>", cmd "resize +2", sile)
  map("n", resize_prefix .. "Left>", cmd "vertical resize -2", sile)
  map("n", resize_prefix .. "Right>", cmd "vertical resize +2", sile)

  -- Move current line / block with Alt-j/k ala vscode.
  -- map("n", "<C-M-j>", "<cmd>move .+1<cr>==", nore)
  -- map("n", "<C-M-k>", "<cmd>move .-2<cr>==", nore)
  -- map("x", "<M-j>", ":move '>+1<cr>gv-gv", nore)
  -- map("x", "<M-k>", ":move '<-2<cr>gv-gv", nore)
  map("n", "<C-M-h>", "<Plug>GoNSMLeft", {})
  map("n", "<C-M-j>", "<Plug>GoNSMDown", {})
  map("n", "<C-M-k>", "<Plug>GoNSMUp", {})
  map("n", "<C-M-l>", "<Plug>GoNSMRight", {})
  map("x", "<M-h>", "<Plug>GoVSMLeft", {})
  map("x", "<M-j>", "<Plug>GoVSMDown", {})
  map("x", "<M-k>", "<Plug>GoVSMUp", {})
  map("x", "<M-l>", "<Plug>GoVSMRight", {})
  map("n", "<C-M-S-h>", "<Plug>GoNSDLeft", {}) -- Duplicate
  map("n", "<C-M-S-j>", "<Plug>GoNSDDown", {})
  map("n", "<C-M-S-k>", "<Plug>GoNSDUp", {})
  map("n", "<C-M-S-l>", "<Plug>GoNSDRight", {})
  map("x", "<M-S-h>", "<Plug>GoVSDLeft", {})
  map("x", "<M-S-j>", "<Plug>GoVSDDown", {})
  map("x", "<M-S-k>", "<Plug>GoVSDUp", {})
  map("x", "<M-S-l>", "<Plug>GoVSDRight", {})

  -- Keep accidentally hitting J instead of j when first going visual mode
  map("x", "J", "j", nore)
  map("x", "gJ", "J", nore)

  -- better indenting
  utils.au "_better_indent" { -- This need to be a <buffer> map otherwise nowait doesn't work
    { "FileType", "nnoremap <buffer> <nowait> > >>" },
    { "FileType", "nnoremap <buffer> <nowait> < <<" },
  }
  map("n", "g<", "<", nore)
  map("n", "g>", ">", nore)
  map("x", "<", "<gv", nore)
  map("x", ">", ">gv", nore)

  -- I hate escape
  if not O.plugin.better_escape then
    map("i", "jk", "<ESC>", sile)
    map("i", "kj", "<ESC>", sile)
  end

  -- for _, v in pairs { "h", "j", "k", "l" } do
  --   for _, m in pairs { "x", "n" } do
  --     map(m, v .. v, "<Nop>", sile)
  --   end
  -- end

  -- Tab switch buffer
  map("n", "<tab>", cmd "b#", nore)
  map("n", "<leader><tab>", cmd "bnext", nore)
  map("n", "<leader><S-tab>", cmd "bnext", nore)
  map("n", "<S-tab>", cmd "bprev", nore)

  -- Preserve register on pasting in visual mode
  -- TODO: use the correct register
  map("x", "p", "pgvy", nore)
  map("x", "P", "p", nore) -- for normal p behaviour
  map("x", "<M-p>", "pgv", nore) -- Paste and keep selection

  -- Add meta version that doesn't affect the clipboard
  local function dont_clobber_if_meta(m, c)
    if string.upper(c) == c then
      map(m, "<M-S-" .. string.lower(c) .. ">", '"_' .. c, nore)
    else
      map(m, "<M-" .. c .. ">", '"_' .. c, nore)
    end
  end
  -- Make the default not touch the clipboard, and add a meta version that does
  local function dont_clobber_by_default(m, c)
    if string.upper(c) == c then
      map(m, "<M-S-" .. string.lower(c) .. ">", c, nore)
    else
      map(m, "<M-" .. c .. ">", c, nore)
    end
    map(m, c, '"_' .. c, nore)
  end
  dont_clobber_if_meta("n", "d")
  dont_clobber_if_meta("n", "D")
  dont_clobber_if_meta("x", "r")
  dont_clobber_by_default("n", "c")
  dont_clobber_by_default("x", "c")
  dont_clobber_by_default("n", "C")
  dont_clobber_by_default("n", "x")
  dont_clobber_by_default("x", "x")

  -- Preserve cursor on yank in visual mode
  -- TODO: use register argument
  map("x", "y", "myy`y", nore)
  map("x", "Y", "myY`y", nore) -- copy linewise
  map("x", "<M-y>", "y", nore)

  -- Paste over textobject
  local substitute = function(fn, opts)
    return function()
      local substitute = require "substitute"
      substitute[fn](opts)
    end
  end
  map("n", "r", substitute "operator")
  map("n", "rr", substitute "line")
  map("n", "R", substitute "eol")
  map("x", "r", substitute "visual")
  local substitute_range = function(fn, opts)
    return function()
      local range = require "substitute.range"
      range[fn](opts)
    end
  end
  map("n", "<leader>c", substitute_range "operator")
  map("x", "<leader>c", substitute_range "visual")
  map("n", "<leader>cc", substitute_range "word")
  map("n", "<leader>C", substitute_range("operator", { motion2 = "iG" }))
  -- map("n", "r", operatorfunc_keys("paste_over", "p"), sile)
  -- -- map("n", "R", "r$", sile)
  -- map("n", "R", "r", nore)
  -- -- map("n", "rr", "vvr", sile)

  map("n", "<M-p>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pp]], nore) -- charwise paste
  -- map("n", "<M-S-C-P>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pP]], nore) -- charwise paste
  -- map("n", "<M-S-p>", [[<cmd>call setreg('p', getreg('+'), 'l')<cr>"pp]], nore) -- linewise paste

  -- Charwise visual select line
  map("x", "v", "^og_", nore)
  map("x", "V", "0o$", nore)

  -- move along visual lines, not numbered ones
  -- without interferring with {count}<down|up>
  map("n", "<up>", "v:count == 0 ? 'gk' : '<up>'", norexpr)
  map("x", "<up>", "v:count == 0 ? 'gk' : '<up>'", norexpr)
  map("n", "<down>", "v:count == 0 ? 'gj' : '<down>'", norexpr)
  map("x", "<down>", "v:count == 0 ? 'gj' : '<down>'", norexpr)

  local pre_goto_next = O.treesitter.textobj_prefixes.goto_next
  local pre_goto_prev = O.treesitter.textobj_prefixes.goto_previous
  local pre_swap_next = O.treesitter.textobj_prefixes.swap_next
  local pre_swap_prev = O.treesitter.textobj_prefixes.swap_prev

  -- QuickFix
  local quickfix_nN = make_nN_pair { cmd "cnext", cmd "cprev" }
  map("n", pre_goto_next .. "q", quickfix_nN[1], nore)
  map("n", pre_goto_prev .. "q", quickfix_nN[2], nore)

  -- Diagnostics jumps
  local diag_nN = make_nN_pair { lsputil.diag_next, lsputil.diag_prev }
  map("n", pre_goto_next .. "d", diag_nN[1], nore)
  map("n", pre_goto_prev .. "d", diag_nN[2], nore)
  local error_nN = make_nN_pair { lsputil.error_next, lsputil.error_prev }
  map("n", pre_goto_next .. "D", error_nN[1], nore)
  map("n", pre_goto_prev .. "D", error_nN[2], nore)

  local hunk_nN = make_nN_pair { gitsigns_fn.next_hunk, gitsigns_fn.prev_hunk }
  map("n", pre_goto_next .. "g", hunk_nN[1], nore)
  map("n", pre_goto_prev .. "g", hunk_nN[2], nore)

  local usage_nN = make_nN_pair {
    require("nvim-treesitter-refactor.navigation").goto_next_usage,
    require("nvim-treesitter-refactor.navigation").goto_previous_usage,
  }
  map("n", pre_goto_next .. "u", usage_nN[1], nore)
  map("n", pre_goto_prev .. "u", usage_nN[2], nore)

  local jumps = {
    d = "Diagnostics",
    q = "QuickFix",
    g = "Git Hunk",
    u = "Usage",
  }
  wk.register({
    ["]"] = jumps,
    ["["] = jumps,
  }, M.wkopts)

  -- Close window
  map("n", "gq", "<C-w>q", nore)
  map("n", "<c-q>", "<C-w>q", nore)
  map("n", "<c-w>d", cmd "bdelete!", nore)

  -- Search for the current selection
  map("x", "*", srchrpt '"zy/<C-R>z<cr>', nore) -- Search for the current selection
  map("n", "<leader>*", operatorfunc_keys("searchbwd_for", "*"), {}) -- Search textobject
  map("x", "#", srchrpt '"zy?<C-R>z<cr>', nore) -- Backwards
  map("n", "<leader>#", operatorfunc_keys("search_for", "#"), {})

  -- Search for the current yank register
  map("n", "+", [[/<C-R>+<cr>]], {})
  sel_map("+", "`[o`]")

  -- Search for last edited text
  map("n", 'g"', [[/\V<C-r>"<CR>]])
  -- map("x", 'g"', [[:keepjumps normal! /\V<C-r>"<CR>gn]])
  map("x", 'g"', '<ESC>g"gn', { remap = true })
  map("o", 'g"', '<cmd>normal vg"<cr>', { remap = true })

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
  -- map("n", "<Plug>ClearHighLights", cmd "nohls" .. cmd "setlocal nospell", nore)
  map("n", "<Plug>ClearHighLights", cmd "nohls", nore)
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

  -- Go Back
  map("n", "gb", "<c-o>", nore)
  map("n", "GB", "<c-i>", nore)

  -- -- Commenting helpers
  -- map("n", "gcO", "O-<esc>gccA<BS>", sile)
  -- map("n", "gco", "o-<esc>gccA<BS>", sile)

  -- Select last pasted
  map("n", "gp", "`[v`]", sile)
  map("x", "gp", "<esc>gp", sile)
  map("n", "gP", "`[V`]", sile)
  map("x", "gP", "<esc>gP", sile)
  map("n", "g<C-p>", "`[<C-v>`]", sile)
  map("x", "g<C-p>", "<esc>g<C-p>", sile)
  -- Use reselect as an operator
  op_from "gp"
  op_from "gP"
  op_from "g<C-p>"

  -- comment and copy
  -- map("x", "gy", '"z<M-y>gvgc`>"zp`[', sile)
  map("x", "gy", '"z<M-y>mz`<"zPgPgc`z', sile)
  map("n", "gy", operatorfuncV_keys("comment_copy", "gy"), sile)
  -- map("n", "gyy", "Vgy", sile)

  -- Toggle comments
  -- map("x", "gt", ":normal gcc<CR>", nore)
  -- map("x", "gt", ":normal :lua require'Comment'.toggle()<C-v><CR><CR>", nore)
  map("x", "gt", ":g/./lua require('Comment.api').toggle_current_linewise(cfg)<CR><cmd>nohls<CR>", nore)
  map("n", "gt", operatorfunc_keys("toggle_comment", "gt"), sile)

  -- Swap the mark jump keys
  map("n", "'", "`", nore)
  map("n", "`", "'", nore)

  -- Jupyter Cells
  -- Change to onoremap
  map("x", "aj", [[?#\+\s*%\+<cr>o/#\+\s*%\+/s-1<cr>]], nore)
  op_from("aj", "aj", sile)
  local cell_nN = {
    -- "/#+s*%+/s-1<cr>",
    [[/#\+\s*%\+<cr>]],
    -- "?#+s*%+/e+1<cr>",
    [[?#\+\s*%\+<cr>]],
  }
  map("n", pre_goto_next .. "j", cell_nN[1], nore)
  map("n", pre_goto_prev .. "j", cell_nN[2], nore)
  -- map("n", pre_goto_next .. "j", [[/#\+\s*%\+<cr>]], nore)

  -- Spell checking
  -- map("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", nore)

  map("i", "<M-a>", cmd "normal! A", nore)
  map("i", "<M-i>", cmd "normal! I", nore)

  -- Slightly easier commands
  -- map("n", ";", ":", {})
  -- map("x", ";", ":", {})
  -- map('c', ';', "<cr>", sile)

  -- Add semicolon
  -- map("i", ";;", "<esc>mzA;`z", nore)
  map("i", ";;", "<esc>A;", nore)

  -- lsp keys
  map("n", "gd", vim.lsp.buf.definition, sile)
  map("n", "gD", vim.lsp.buf.declaration, sile)
  map("n", "gi", vim.lsp.buf.implementation, sile)
  map("n", "gr", telescope_fn.lsp_references, sile)
  map("n", "gK", vim.lsp.codelens.run, sile)
  -- map("n", "gr", vim.lsp.buf.references, sile)
  -- Preview variants
  map("n", "gpd", require("lsp.functions").view_location_split("definition", "FocusSplitNicely"), sile)
  map("n", "gpD", require("lsp.functions").view_location_split("declaration", "FocusSplitNicely"), sile)
  map("n", "gpr", require("lsp.functions").view_location_split("references", "FocusSplitNicely"), sile)
  map("n", "gpi", require("lsp.functions").view_location_split("implementation", "FocusSplitNicely"), sile)
  -- Hover
  -- map("n", "K", vim.lsp.buf.hover, sile)
  map("n", "gh", vim.lsp.buf.hover, sile)
  map("n", "K", cmd "CodeActionMenu", {})
  map("x", "K", ":lua vim.lsp.buf.range_code_action()<cr>", {})

  -- Formatting keymaps
  map("n", "gq", require("lsp.functions").format_range_operator, sile)
  map("x", "gq", vim.lsp.buf.range_formatting, sile)
  map("n", "gf", vim.lsp.buf.formatting, sile)

  -- TODO: Use more standard regex syntax
  -- map("n", "/", "/\v", nore)

  -- Open a new line in normal mode
  map("n", "<M-cr>", "o<esc>", nore)
  map("n", "<M-S-cr>", "O<esc>", nore)

  -- Split line
  map("n", "go", "i<cr><ESC>k<cmd>sil! keepp s/\v +$//<cr><cmd>noh<cr>j^", nore)

  -- Quick activate macro
  map("n", "Q", "@q", nore)
  map("x", "Q", "@q", nore)
  -- Run macro on each line
  map("x", "<M-q>", ":normal @q<CR>", nore)
  map("x", ".", ":normal .<CR>", nore)

  -- Reselect visual linewise
  map("n", "gV", "'<V'>", nore)
  map("x", "gV", "<esc>gV", sile)
  -- Reselect visual block wise
  map("n", "g<C-v>", "'<C-v>'>", nore)
  map("x", "g<C-v>", "<esc>g<C-v>", sile)

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
  map("x", "I", "<M-a>i", { remap = true })
  map("x", "A", "<M-a>a", { remap = true })

  -- Select all matching regex search
  -- map("n", "<M-S-/>", "<M-/><M-a>", {remap=true})

  -- Multi select object
  map("n", "<M-v>", operatorfunc_keys("multiselect", "<M-n>"), sile)
  -- Multi select all
  map("n", "<M-S-v>", operatorfunc_keys("multiselect_all", "<M-S-a>"), sile)

  -- Keymaps for easier access to 'ci' and 'di'
  local function quick_inside(key)
    map("o", key, "i" .. key, { remap = true })
    map("o", "<M-" .. key .. ">", "a" .. key, { remap = true })
    -- map("n", "<M-" .. key .. ">", "vi" .. key, {remap=true})
    -- map("n", "<C-M-" .. key .. ">", "va" .. key, {remap=true})
  end
  local function quick_around(key)
    map("o", key, "a" .. key, { remap = true })
    map("n", "<M-" .. key .. ">", "va" .. key, { remap = true })
  end
  -- quick_inside "w"
  -- quick_inside "p"
  -- quick_inside "W"
  -- quick_inside "b"
  -- quick_inside "B"
  -- quick_inside "["
  -- quick_around "]"
  -- quick_inside "("
  -- quick_around ")"
  -- quick_inside "{"
  -- quick_around "}"
  -- quick_inside '"'
  -- quick_inside "'"
  -- quick_inside "q"
  -- map("n", "r", '"_ci', {})
  -- map("n", "x", '"_d', {})
  -- map("n", "X", "x", nore)
  map("n", "<BS>", "X", nore)
  map("n", "<M-BS>", "x", nore)

  -- "better" end and beginning of line
  map("o", "H", "^", { remap = true })
  map("o", "L", "$", { remap = true })
  map("x", "H", "^", { remap = true })
  map("x", "L", "g_", { remap = true })
  map("n", "H", [[col('.') == match(getline('.'),'\S')+1 ? '0' : '^']], norexpr)
  map("n", "L", "$", { remap = true })

  -- map("n", "m-/", "")

  -- Select whole file
  map("o", "iG", "<cmd>normal! mzggVG<cr>`z", nore)
  sel_map("iG", "gg0oG$", nore)

  -- Operator for current line
  -- sel_map("il", "g_o^")
  -- sel_map("al", "$o0")

  -- Make change line (cc) preserve indentation
  map("n", "cc", "^cg_", sile)

  -- add j and k with count to jumplist
  M.countjk()

  -- Plugin keymaps
  require("lv-zen").keymaps()
  require("lv-dial").keymaps()
  if O.plugin.gesture then
    require("lv-gestures").keymaps()
  end

  -- Terminal pass through escape key
  map("t", "<ESC>", "<ESC>", nore)
  map("t", "<ESC><ESC>", [[<C-\><C-n>]], nore)

  local ldr_goto_next = "j"
  local ldr_goto_prev = "k"
  local ldr_swap_next = "a"
  local ldr_swap_prev = "A"
  -- Leader shortcut for ][ jumping and )( swapping
  map("n", "<leader>" .. ldr_goto_next, pre_goto_next, { remap = true })
  map("n", "<leader>" .. ldr_goto_prev, pre_goto_prev, { remap = true })
  map("n", "<leader>" .. ldr_swap_next, pre_swap_next, { remap = true })
  map("n", "<leader>" .. ldr_swap_prev, pre_swap_prev, { remap = true })

  map("n", "<leader><leader>", "<localleader>", { remap = true })
  map("x", "<leader><leader>", "<localleader>", { remap = true })

  -- Open new line with a count
  map("n", "o", function()
    local count = vim.v.count
    feedkeys("o", "n")
    for _ = 1, count do
      feedkeys "<CR>"
    end
  end, nore)

  local leaderOpts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = false,
    -- silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }
  local vLeaderOpts = {
    mode = "v", -- Visual mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = false,
    -- silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  -- TODO: create entire treesitter section

  -- TODO: support vim-sandwich in the which-key menus
  local leaderMappings = {
    [";"] = { telescope_fn.commands, "Commands" },
    [" "] = { name = "Electric Boogaloo" },
    ["*"] = "Search obj",
    ["#"] = "Search(bwd) obj",
    -- [";"] = { cmd "Dashboard", "Dashboard" },
    ["/"] = { telescope_fn.live_grep, "Global search" },
    ["?"] = { telescope_fn.live_grep_all, "Global search" },
    f = { telescope_fn.find_files, "Find File" },
    F = { telescope_fn.find_all_files, "Find all Files" },
    [ldr_goto_next] = "Jump next (])",
    [ldr_goto_prev] = "Jump prev ([)",
    [ldr_swap_next] = "Swap next ())",
    [ldr_swap_prev] = "Swap prev (()",
    x = "Execute/Send",
    w = { cmd "w", "Write" }, -- w = { cmd "up", "Write" },
    W = { cmd "noau w", "Write (noau)" }, -- w = { cmd "noau up", "Write" },
    q = { "<C-W>q", "Quit" },
    Q = { "<C-W>q", "Quit" },
    o = {
      name = "Toggle window",
      -- s = { focus_fn.split_nicely, "Nice split" },
      o = { cmd "SidebarNvimToggle", "Sidebar.nvim" },
      e = { focus_fn.focus_max_or_equal, "Max/Equal splits" },
      f = { cmd "NvimTreeToggle", "File Sidebar" },
      u = { cmd "UndotreeToggle", "Undo tree" },
      r = { cmd "Ranger", "Ranger" },
      q = { utils.quickfix_toggle, "Quick fixes" },
      E = { cmd "!open '%:p:h'", "Open File Explorer" },
      F = { telescope_fn.file_browser, "Telescope browser" },
      v = { cmd "Vista nvim_lsp", "Vista" },
      -- ["v"] = {cmd "Vista", "Vista"},
      M = { vim.g.goneovim and cmd "GonvimMiniMap" or cmd "MinimapToggle", "Minimap" },
      b = {
        function()
          require("lv-terms").ftopen "broot"
        end,
        "Broot",
      },
      p = {
        function()
          require("lv-terms").ftopen "ipython"
        end,
        "Python",
      },
      t = {
        function()
          require("lv-terms").ftopen "btm"
        end,
        "System Monitor",
      },
      S = {
        function()
          require("lv-terms").ftopen "spt"
        end,
        "Spotify",
      },
      l = {
        function()
          require("lv-terms").ftopen "right"
        end,
        "Terminal",
      },
    },
    t = { name = "Terminals" },
    p = { name = "Project (Tasks)" },
    T = {
      name = "Toggle Opts",
      w = { cmd "setlocal wrap!", "Wrap" },
      s = { cmd "setlocal spell!", "Spellcheck" },
      C = { cmd "setlocal cursorcolumn!", "Cursor column" },
      n = { cmd "setlocal number!", "Number column" },
      g = { cmd "setlocal signcolumn!", "Cursor column" },
      l = { cmd "setlocal cursorline!", "Cursor line" },
      h = { cmd "setlocal hlsearch", "hlsearch" },
      c = { utils.conceal_toggle, "Conceal" },
      f = { focus_fn.focus_toggle, "Focus.nvim" },
      -- TODO: Toggle comment visibility
    },
    b = {
      name = "Buffers",
      j = { telescope_fn.buffers, "Jump to " },
      w = { cmd "w", "Write" },
      a = { cmd "wa", "Write All" },
      c = { cmd "Bdelete!", "Close" },
      d = { cmd "bdelete!", "Close+Win" },
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
      -- TODO: can use localleader for this??
      name = "Debug",
      U = {
        function()
          require("dapui").toggle()
        end,
        "Toggle DAP-UI",
      },
      v = {
        function()
          require("dapui").eval()
        end,
        "Eval",
      },
      t = {
        function()
          require("dap").toggle_breakpoint()
        end,
        "Toggle Breakpoint",
      },
      b = {
        function()
          require("dap").step_back()
        end,
        "Step Back",
      },
      c = {
        function()
          require("dap").continue()
        end,
        "Continue",
      },
      C = {
        function()
          require("dap").run_to_cursor()
        end,
        "Run To Cursor",
      },
      d = {
        function()
          require("dap").disconnect()
        end,
        "Disconnect",
      },
      g = {
        function()
          require("dap").session()
        end,
        "Get Session",
      },
      i = {
        function()
          require("dap").step_into()
        end,
        "Step Into",
      },
      o = {
        function()
          require("dap").step_over()
        end,
        "Step Over",
      },
      u = {
        function()
          require("dap").step_out()
        end,
        "Step Out",
      },
      p = {
        function()
          require("dap").pause.toggle()
        end,
        "Pause",
      },
      r = {
        function()
          require("dap").repl.toggle()
        end,
        "Toggle Repl",
      },
      s = {
        function()
          require("dap").continue()
        end,
        "Start",
      },
      q = {
        function()
          require("dap").stop()
        end,
        "Quit",
      },
    },
    g = {
      name = "Git",
      g = { require("lv-terms").ftopen "gitui", "Gitui" },
      v = { require("lv-terms").ftopen "verco", "Verco" },
      m = { cmd "!smerge '%:p:h'", "Sublime Merge" },
      L = { cmd "GitBlameToggle", "Blame Toggle" },
      l = { gitsigns_fn.blame_line, "Blame" },
      p = { gitsigns_fn.preview_hunk, "Preview Hunk" },
      r = { gitsigns_fn.reset_hunk, "Reset Hunk" },
      R = { gitsigns_fn.reset_buffer, "Reset Buffer" },
      s = { gitsigns_fn.stage_hunk, "Stage Hunk" },
      u = { gitsigns_fn.undo_stage_hunk, "Undo Stage Hunk" },
      o = { telescope_fn.git_status, "Open changed file" },
      b = { telescope_fn.git_branches, "Checkout branch" },
      c = { telescope_fn.git_commits, "Checkout commit" },
      C = { telescope_fn.git_bcommits, "Checkout commit(for current file)" },
      d = {
        name = "Diffview",
        o = { cmd "DiffviewOpen", "Open" },
        h = { cmd "DiffviewFileHistory", "History" },
        O = { ":DiffviewOpen ", "Open ..." },
        H = { ":DiffviewFileHistory ", "History ..." },
      },
      ["<CR>"] = { cmd "Git", "Fugitive Status" },
      [" "] = { ":Git ", "Fugitive ..." },
    },
    l = {
      name = "LSP",
      i = {
        l = { cmd "LspInfo", "LSP" },
        n = { cmd "NullLsInfo", "Null-ls" },
        i = { cmd "LspInstallInfo", "LspInstall" },
        t = { cmd "TSConfigInfo", "Treesitter" },
      },
      h = { lspbuf.hover, "Hover (gh)" },
      a = { do_code_action, "Code Action (K)" },
      k = { vim.lsp.codelens.run, "Run Code Lens (gK)" },
      t = { lspbuf.type_definition, "Type Definition" },
      f = { lspbuf.formatting, "Format" },
      c = {
        name = "Calls",
        i = { lspbuf.incoming_calls, "Incoming" },
        o = { lspbuf.outgoing_calls, "Outgoing" },
      },
      s = {
        d = {
          require("lsp.functions").view_location_split("definition", "FocusSplitNicely"),
          "Split Definition",
        },
        D = {
          require("lsp.functions").view_location_split("declaration", "FocusSplitNicely"),
          "Split Declaration",
        },
        r = {
          require("lsp.functions").view_location_split("references", "FocusSplitNicely"),
          "Split References",
        },
        s = {
          require("lsp.functions").view_location_split("implementation", "FocusSplitNicely"),
          "Split Implementation",
        },
      },
    },
    s = {
      name = "Search",
      [" "] = { telescope_fn.resume, "Redo last" },
      -- n = { telescope_fn.notify.notify, "Notifications" },
      c = { telescope_fn.colorscheme, "Colorscheme" },
      a = { telescope_fn.lsp_code_actions, "Code Actions" },
      s = { telescope_fn.lsp_document_symbols, "Document Symbols" },
      S = { telescope_fn.lsp_dynamic_workspace_symbols, "Workspace Symbols" },
      d = { telescope_fn.diagnostics, "Document Diagnostics" },
      D = { telescope_fn.diagnostics, "Workspace Diagnostics" },
      r = { telescope_fn.lsp_references, "References" },
      I = { telescope_fn.lsp_implementations, "Implementations" },
      h = { telescope_fn.help_tags, "Find Help" },
      j = { telescope_fn.jumplist, "Jump List" },
      M = { telescope_fn.man_pages, "Man Pages" },
      R = { telescope_fn.oldfiles, "Open Recent File" },
      -- R = { telescope_fn.registers, "Registers" },
      t = { telescope_fn.live_grep, "Text" },
      T = { telescope_fn.live_grep_all, "Text (ALL)" },
      b = { telescope_fn.curbuf, "Current Buffer" },
      k = { telescope_fn.keymaps, "Keymappings" },
      o = { cmd "TodoTelescope", "TODOs" },
      q = { telescope_fn.quickfix, "Quickfix" },
      ["*"] = { telescope_fn.grep_string, "Curr word" },
      ["/"] = { telescope_fn.grep_last_search, "Last Search" },
      -- ["+"] = { telescope_fn.grep_last_yank, "Last Yank" },
      -- ["."] = { [[:%s/<C-R>.//g<Left><Left>]], "Last insert" },
      i = "for (object)",
      p = { cmd "SearchSession", "Sessions" },
      m = { telescope_fn.marks, "Marks" },
    },
    r = {
      name = "Replace/Refactor",
      n = { lsputil.rename, "Rename" },
      t = "Rename TS",
      ["*"] = { [["zyiw:%s/<C-R>z//g<Left><Left>]], "Curr word" },
      ["/"] = { [[:%s/<C-R>///g<Left><Left>]], "Last search" },
      ["+"] = { [[:%s/<C-R>+//g<Left><Left>]], "Last yank" },
      ["."] = { [[:%s/<C-R>.//g<Left><Left>]], "Last insert" },
      s = { [[:%s///g<Left><Left><Left>]], "From Search" },
    },
    n = {
      name = "Generate",
      n = { cmd "Neogen", "Gen Doc" },
      f = { cmd "Neogen func", "Func Doc" },
      F = { cmd "Neogen file", "File Doc" },
      t = { cmd "Neogen type", "type Doc" },
      c = { cmd "Neogen class", "Class Doc" },
    },
    d = {
      name = "Diagnostics",
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
      name = "Projects",
    },
    -- m = "Multi",
    m = "which_key_ignore",
    -- c = {
    --   operatorfunc_keys("change_all", "<leader>c"),
    --   "Change all",
    -- },
  }
  map("n", "<M-S-s>", operatorfunc_keys("separate", "<leader>s"), sile)
  map("x", "<M-S-s>", "<leader>s", sile)

  M.whichkey {
    [O.treesitter.textobj_prefixes.swap_prev] = {
      name = "Swap Prev",
      ["("] = { cmd "ISwap", "Interactive" },
      [")"] = { cmd "ISwapWith", "I. With" },
    },
    [O.treesitter.textobj_prefixes.swap_next] = {
      name = "Swap Next",
      ["("] = { cmd "ISwap", "Interactive" },
      [")"] = { cmd "ISwapWith", "I. With" },
    },
  }
  M.sile("o", O.plugin.ts_hintobjects.key, [[:<C-U>lua require('tsht').nodes()<CR>]])
  M.sile("v", O.plugin.ts_hintobjects.key, [[:lua require('tsht').nodes()<CR>]])

  M.whichkey {
    [O.treesitter.textobj_prefixes.swap_prev] = {
      name = "Swap Prev",
      ["("] = { cmd "ISwap", "Interactive" },
      [")"] = { cmd "ISwapWith", "I. With" },
    },
    [O.treesitter.textobj_prefixes.swap_next] = {
      name = "Swap Next",
      ["("] = { cmd "ISwap", "Interactive" },
      [")"] = { cmd "ISwapWith", "I. With" },
    },
  }
  M.sile("o", O.plugin.ts_hintobjects.key, [[:<C-U>lua require('tsht').nodes()<CR>]])
  M.sile("x", O.plugin.ts_hintobjects.key, [[:lua require('tsht').nodes()<CR>]])

  local vLeaderMappings = {
    -- ["/"] = { cmd "CommentToggle", "Comment" },
    d = { lsputil.range_diagnostics, "Range Diagnostics" },
    r = { name = "Replace/Refactor" },
    -- c = {
    --   [["z<M-y>:%s/<C-r>z//g<Left><Left>]],
    --   "Change all",
    -- },
    s = { 'ygvc<CR><C-r>"<CR><ESC>', "separate" },
    D = {
      name = "Debug",
      v = {
        function()
          require("dapui").eval()
        end,
        "Eval",
      },
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
    -- TODO: make sure this is symmetric with <leader>s (telescope search)
    leaderMappings["d<space>"] = { cmd "TroubleToggle", "Trouble Toggle" }
    leaderMappings["dd"] = { cmd "TroubleToggle document_diagnostics", "Document" }
    leaderMappings["dD"] = { cmd "TroubleToggle workspace_diagnostics", "Workspace" }
    leaderMappings["dr"] = { cmd "TroubleToggle lsp_references", "References" }
    leaderMappings["ds"] = { cmd "TroubleToggle lsp_definitions", "Definitions" }
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
    leaderMappings["zm"] = { cmd "TZMinimalist", "Minimalist" }
  end
  if O.plugin.twilight then
    leaderMappings["zt"] = { cmd "Twilight", "Twilight" }
  end
  if O.plugin.telescope_project then
    leaderMappings["PP"] = { telescope_fn.projects, "Projects" }
  end
  if O.plugin.project_nvim then
    leaderMappings["PR"] = { cmd "ProjectRoot", "Rooter" }
  end
  if O.plugin.spectre then
    leaderMappings["rf"] = {
      function()
        require("spectre").open_file_search()
      end,
      "Current File",
    }
    leaderMappings["/"][1] = function()
      require("spectre").open()
    end
    -- leaderMappings["?"][1] = function () require'spectre'.open_no_ignore() end
    leaderMappings["rp"] = {
      function()
        require("spectre").open()
      end,
      "Project",
    }
    vLeaderMappings["rf"] = {
      function()
        require("spectre").open_visual { path = vim.fn.expand "%" }
      end,
      "Current File",
    }
    vLeaderMappings["rp"] = {
      function()
        require("spectre").open_visual()
      end,
      "Project",
    }
    -- TODO: other spectre maps like '<leader>r'
  end
  if O.plugin.lazygit then
    leaderMappings["gg"] = { cmd "LazyGit", "LazyGit" }
  end
  require("lv-terms").keymaps(leaderMappings, vLeaderMappings)
  require("lv-hop").keymaps(leaderMappings, vLeaderMappings)
  require("lv-bufferline").keymaps(leaderMappings, vLeaderMappings)
  require("lv-yabs").keymaps(leaderMappings, vLeaderMappings)
  if O.plugin.nabla then
    leaderMappings["xn"] = {
      function()
        require("nabla").action()
      end,
      "Nabla",
    }
  end
  -- if O.plugin.neoterm then
  --   leaderMappings[O.plugin.neoterm.automap_keys] = "Neoterm AutoMap"
  -- end
  if O.lushmode then
    leaderMappings["L"] = {
      name = "+Lush",
      l = { cmd "Lushify", "Lushify" },
      x = {
        function()
          require("lush").export_to_buffer(require "lush_theme.cool_name")
        end,
        "Lush Export",
      },
      t = { cmd "LushRunTutorial", "Lush Tutorial" },
      q = { cmd "LushRunQuickstart", "Lush Quickstart" },
    }
  end
  if O.plugin.notify then
    leaderMappings["mm"] = { cmd "Message", "Notifications" }
  end

  wk.register(leaderMappings, leaderOpts)
  wk.register(vLeaderMappings, vLeaderOpts)

  -- TODO: move to plugin config files?
  if O.plugin.surround then
    local ops = { mode = "o" }
    wk.register({ ["s"] = "Surround", ["S"] = "Surround Rest", ["ss"] = "Line" }, ops)
  end
  if O.plugin.lightspeed then
    local ops = { mode = "o" }
    wk.register({ ["z"] = "Light speed", ["Z"] = "Light speed bwd" }, ops)

    -- function repeat_ft(reverse)
    --   local ls = require "lightspeed"
    --   ls.ft["instant-repeat?"] = true
    --   ls.ft:to(reverse, ls.ft["prev-t-like?"])
    -- end

    -- map("n", ";", "<cmd>lua repeat_ft(false)<cr>", { noremap = true, silent = true })
    -- map("x", ";", "<cmd>lua repeat_ft(false)<cr>", { noremap = true, silent = true })
    -- map("n", ",", "<cmd>lua repeat_ft(true)<cr>", { noremap = true, silent = true })
    -- map("x", ",", "<cmd>lua repeat_ft(true)<cr>", { noremap = true, silent = true })
  end

  local ops = { mode = "n" }
  wk.register({
    ["gy"] = "which_key_ignore",
    ["gyy"] = "which_key_ignore",
    ["z="] = {
      telescope_fn.spell_suggest,
      "Spelling suggestions",
    },
  }, ops)

  -- TODO: register all g prefix keys in whichkey

  -- Tab management keybindings
  local tab_mgmt = {
    t = { cmd "tabnext", "Next" },
    -- ["<C-t>"] = { cmd "tabnext", "which_key_ignore" },
    n = { cmd "tabnew", "New" },
    q = { cmd "tabclose", "Close" },
    p = { cmd "tabprev", "Prev" },
    l = { cmd "tabs", "List tabs" },
    o = { cmd "tabonly", "Close others" },
    ["1"] = { cmd "tabfirst", "First tab" },
    ["0"] = { cmd "tablast", "Last tab" },
  }
  wk.register(tab_mgmt, {
    mode = "n",
    prefix = "<C-t>",
    noremap = true,
    silent = true,
  })
  for key, value in pairs(tab_mgmt) do
    -- local lhs = "<C-t><C-" .. key .. ">"
    -- map("n", lhs, value[1], { noremap = true, silent = true })
    local lhs = "<C-" .. key .. ">"
    wk.register({ [lhs] = { value[1], "which_key_ignore" } }, {
      mode = "n",
      prefix = "<C-t>",
      noremap = true,
      silent = true,
    })
  end

  -- FIXME: duplicate entries for some of the operators
end

local mincount = 5
function M.wrapjk()
  map("n", "j", [[v:count ? (v:count > ]] .. mincount .. [[ ? "m'" . v:count : '') . 'j' : 'gj']], norexpr)
  map("n", "k", [[v:count ? (v:count > ]] .. mincount .. [[ ? "m'" . v:count : '') . 'k' : 'gk']], norexpr)
  map("x", "j", [[v:count ? (v:count > ]] .. mincount .. [[ ? "m'" . v:count : '') . 'j' : 'gj']], norexpr)
  map("x", "k", [[v:count ? (v:count > ]] .. mincount .. [[ ? "m'" . v:count : '') . 'k' : 'gk']], norexpr)
end
function M.countjk()
  map("n", "j", [[(v:count > ]] .. mincount .. [[ ? "m'" . v:count : '') . 'j']], norexpr)
  map("n", "k", [[(v:count > ]] .. mincount .. [[ ? "m'" . v:count : '') . 'k']], norexpr)
end

M.wkopts = {
  mode = "n", -- NORMAL mode
  silent = true,
  noremap = false,
  nowait = false,
}
function M.whichkey(maps, opts)
  if opts == nil then
    opts = {}
  end
  require("which-key").register(maps, vim.tbl_extend("keep", opts, M.wkopts))
end
function M.localleader(maps, opts)
  if opts == nil then
    opts = {}
  end
  M.whichkey(
    maps,
    vim.tbl_extend("keep", opts, {
      prefix = "<localleader>",
      buffer = 0,
    })
  )
end
function M.ftleader(maps, opts)
  if opts == nil then
    opts = {}
  end
  M.whichkey(
    maps,
    vim.tbl_extend("keep", opts, {
      prefix = "<leader>",
      buffer = 0,
    })
  )
end
function M.vlocalleader(maps, opts)
  if opts == nil then
    opts = {}
  end
  M.localleader(maps, vim.tbl_extend("keep", opts, { mode = "v" }))
end

return setmetatable(M, {
  __call = function(tbl, ...)
    return map(unpack(...))
  end,
})
