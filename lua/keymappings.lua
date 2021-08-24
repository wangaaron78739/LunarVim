local utils = require "lv-utils"
local map = vim.api.nvim_set_keymap
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

  map("o", lhs, ":normal v" .. rhs .. "<cr>", opts)
end
local function sel_map(lhs, rhs, opts)
  if opts == nil then
    opts = nore
  end
  map("v", lhs, rhs, opts)
  op_from(lhs, rhs, opts)
end

function silemap(mode, from, to)
  map(mode, from, to, sile)
end
function noremap(mode, from, to)
  map(mode, from, to, nore)
end
function exprmap(mode, from, to)
  map(mode, from, to, expr)
end

-- Set leader
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
map("n", "<C-s>", "<cmd>write<cr>", sile)
map("v", "<C-s>", "<cmd>write<cr>", sile)
map("i", "<C-s>", "<cmd>write<cr>", sile)
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
map("n", resize_prefix .. "Up>", ":resize -2<CR>", sile)
map("n", resize_prefix .. "Down>", ":resize +2<CR>", sile)
map("n", resize_prefix .. "Left>", ":vertical resize -2<CR>", sile)
map("n", resize_prefix .. "Right>", ":vertical resize +2<CR>", sile)

-- Move current line / block with Alt-j/k ala vscode.
map("n", "<C-M-j>", ":m .+1<CR>==", nore)
map("n", "<C-M-k>", ":m .-2<CR>==", nore)
map("i", "<M-j>", "<Esc>:m .+1<CR>==gi", nore)
map("i", "<M-k>", "<Esc>:m .-2<CR>==gi", nore)
map("x", "<M-j>", ":m '>+1<CR>gv-gv", nore)
map("x", "<M-k>", ":m '<-2<CR>gv-gv", nore)
-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv=gv", nore)
map("x", "J", ":move '>+1<CR>gv=gv", nore)

-- better indenting
map("n", "<", "<<", { silent = true, noremap = true, nowait = true })
map("n", ">", ">>", { silent = true, noremap = true, nowait = true })
map("n", "<<", "<nop>", { silent = true, noremap = true, nowait = true })
map("n", ">>", "<nop>", { silent = true, noremap = true, nowait = true })
map("n", "g<", "<", nore)
map("n", "g>", ">", nore)
map("v", "<", "<gv", nore)
map("v", ">", ">gv", nore)

-- I hate escape
map("i", "jk", "<ESC>", nore)
map("i", "kj", "<ESC>", nore)
-- map("v", "jk", "<ESC>", nore)
-- map("v", "kj", "<ESC>", nore)

-- Tab switch buffer
-- map('n', '<TAB>', ':bnext<CR>', nore)
-- map('n', '<S-TAB>', ':bprevious<CR>', nore)
map("n", "<TAB>", "<cmd>b#<cr>", nore)
map("n", "<S-TAB>", ":bnext<CR>", nore)

-- Preserve register on pasting in visual mode
map("v", "p", "pgvy", nore)
map("v", "P", "p", nore) -- for normal p behaviour

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
noclobber_default("v", "c")
noclobber_default("v", "C")

-- Preserve cursor on yank in visual mode
map("v", "y", "myy`y", nore)
map("v", "Y", "myY`y", nore) -- copy linewise
map("v", "<M-y>", "y", nore)

-- -- Original paste for when 'nvim-anywise-reg.lua' is installed
-- if O.plugin.anywise_reg then
--   map("n", "<M-p>", "p", nore)
--   map("n", "<M-S-P>", "P", nore)
--   map("n", "<M-C-p>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pp]], nore) -- charwise paste
--   map("n", "<M-S-C-P>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pP]], nore) -- charwise paste
-- else

-- Paste over textobject
map("n", "r", utils.operatorfunc_keys("paste_over", "p"), sile)
-- map("n", "rr", "vvr", sile)
map("n", "<M-C-p>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pp]], nore) -- charwise paste
map("n", "<M-S-C-P>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pP]], nore) -- charwise paste
-- map("n", "<M-S-p>", [[<cmd>call setreg('p', getreg('+'), 'l')<cr>"pp]], nore) -- linewise paste

if false then
  -- Select next/previous text object
  map("n", "<M-w>", "wviw", sile)
  map("n", "<M-b>", "bviwo", sile)
  map("v", "<M-w>", "eowo", sile)
  map("v", "<M-b>", "oboge", sile)
  -- map("v", "<M-w>", "<Esc>wviw", sile)
  -- map("v", "<M-b>", "<Esc>bviwo", sile)
  map("n", "<M-S-W>", "WviW", sile)
  map("n", "<M-S-B>", "BviWo", sile)
  map("v", "<M-S-W>", "EOWO", sile)
  map("v", "<M-S-B>", "OBOGE", sile)
  --[[ map("v", "<M-S-W>", "<Esc>WviW", sile)
map("v", "<M-S-B>", "<Esc>BviWo", sile) ]]
  map("n", "<M-)>", "f(va(", sile)
  map("n", "<M-(>", "F)va)o", sile)
  map("v", "<M-)>", "<Esc>f(vi(", sile)
  map("v", "<M-(>", "<Esc>F)vi)", sile)
  -- map("n", "<M-j>", "jV", sile)
  -- map("n", "<M-k>", "kV", sile)
  -- map("v", "<M-j>", "<Esc>jV", sile)
  -- map("v", "<M-k>", "<Esc>kV", sile)
end

-- Start selecting
map("v", "<M-l>", "l", sile)
map("n", "<M-l>", "<c-v>l", sile)
map("v", "<M-h>", "h", sile)
map("n", "<M-h>", "<c-v>h", sile)

-- Charwise visual select line
map("v", "v", "^og_", nore)
map("v", "V", "0o$", nore)

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
map("n", "<up>", "v:count == 0 ? 'gk' : '<up>'", expr)
map("v", "<up>", "v:count == 0 ? 'gk' : '<up>'", expr)
map("n", "<down>", "v:count == 0 ? 'gj' : '<down>'", expr)
map("v", "<down>", "v:count == 0 ? 'gj' : '<down>'", expr)

-- Better nav for omnicomplete
map("i", "<c-j>", '("\\<C-n>")', expr)
map("i", "<TAB>", '("\\<C-n>")', expr)
map("i", "<c-k>", '("\\<C-p>")', expr)
map("i", "<S-TAB>", '("\\<C-p>")', expr)

-- QuickFix
map("n", "]q", ":cnext<CR>", nore)
map("n", "[q", ":cprev<CR>", nore)
-- map("n", "<C-M-j>", ":cnext<CR>", nore)
-- map("n", "<C-M-k>", ":cprev<CR>", nore)

-- Diagnostics jumps
map("n", "]d", [[<cmd>lua require("lsp.functions").diag_next()<cr>]], nore)
map("n", "[d", [[<cmd>lua require("lsp.functions").diag_prev()<cr>]], nore)

-- Search and replace the current selection
map("v", "<leader>c", [["z<M-y>:%s/<C-r>z//g<Left><Left>]], {})
map("n", "<leader>c", utils.operatorfunc_keys("change_all", "<leader>c"), {}) -- Search and replace textobject

-- Search for the current selection
map("v", "*", '"z<M-y>/<C-R>z<CR>', {}) -- Search for the current selection
map("n", "<M-s>", utils.operatorfunc_keys("search_for", "*"), {}) -- Search textobject

-- Search and Replace from registers
-- map("n", "<leader>C", [[:%s/<C-R>//g<Left><Left>]], {}) -- Search and replace register
map("n", "<leader>r+", [[:%s/<C-R>+//g<Left><Left>]], {}) -- Search and replace the current yank
map("n", "<leader>r/", [[:%s/<C-R>///g<Left><Left>]], {}) -- Search and replace last search
map("n", "<leader>r.", [[:%s/<C-R>.//g<Left><Left>]], {}) -- Search and replace last insert
map("n", "+", [[/<C-R>+<CR>]], {}) -- Search for the current yank register

-- Select last changed/yanked text
sel_map("+", "`[o`]")

-- Search and replace
map("n", "<leader>sr", [[:%s///g<Left><Left><Left>]], {})

-- Start search and replace from search
map("c", "<M-r>", [[<cr>:%s/<C-R>///g<Left><Left>]], {})

-- Continue the search and keep selecting (equivalent ish to doing `gn` in normal)
map("v", "n", "<esc>ngn", {})
map("v", "N", "<esc>NgN", {})

-- Double Escape key clears search and spelling highlights
-- map("n", "<Plug>ClearHighLights", ":nohls | :setlocal nospell | call minimap#vim#ClearColorSearch()<ESC>", nore)
map("n", "<Plug>ClearHighLights", ":nohls | :setlocal nospell<cr>", nore)
map("n", "<ESC>", "<Plug>ClearHighLights", sile)

-- Map `cp` to `xp` (transpose two adjacent chars)
-- as a **repeatable action** with `.`
-- (since the `@=` trick doesn't work
-- nmap cp @='xp'<CR>
-- http://vimcasts.org/transcripts/61/en/
map("n", "<Plug>TransposeCharacters", [[xp:call repeat#set("\<Plug>TransposeCharacters")<CR>]], nore)
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
map("v", "gy", '"z<M-y>gvgc`>"zp`[', sile)
map("n", "gy", utils.operatorfuncV_keys("comment_copy", "gy"), sile)
-- map("n", "gyy", "Vgy", sile)

-- Select Jupyter Cell
-- Change to onoremap
map("v", "ic", [[/#+\s*%+<cr>oN]], nore)

-- Spell checking
map("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u]]", nore)

-- Vscode style commenting in insert mode
map("i", "<C-/>", "<C-\\><C-n><CMD>CommentToggle", nore)

-- Slightly easier commands
map("n", ";", ":", {})
map("v", ";", ":", {})
-- map('c', ';', "<CR>", sile)

-- Add semicolon
map("i", ";;", "<esc>mzA;", nore)

-- lsp keys
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", sile)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", sile)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", sile)
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", sile)
map("n", "gK", "<cmd>lua vim.lsp.codelens.run()<CR>", sile)
-- map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", sile)
-- Preview variants
map("n", "gpd", [[<cmd>lua require("lsp.functions").preview_location_at("definition")<CR>]], sile)
map("n", "gpD", [[<cmd>lua require("lsp.functions").preview_location_at("declaration")<CR>]], sile)
map("n", "gpr", [[<cmd>lua require("lsp.functions").preview_location_at("references")<CR>]], sile)
map("n", "gpi", [[<cmd>lua require("lsp.functions").preview_location_at("implementation")<CR>]], sile)
-- Hover
-- map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", sile)
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", sile)
map("n", "K", "<cmd>lua vim.lsp.buf.code_action()<cr>", {})
map("v", "K", "<esc><cmd>'<,'>lua vim.lsp.buf.range_code_action()<cr>", {})

-- Format buffer using lsp
-- map("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<cr>", nore)
-- Format a range using lsp
-- vim.api.nvim_set_keymap("n", "gm", [[<cmd>lua require("lsp.functions").format_range_operator()<CR>]], nore)

-- TODO: Use more standard regex syntax
-- map("n", "/", "/\v", nore)

-- Open a new line in normal mode
map("n", "<cr>", "o<esc>", nore)
map("n", "<M-cr>", "O<esc>", nore)

-- Split line
map("n", "go", "i<CR><ESC>k:sil! keepp s/\v +$//<CR>:noh<CR>j^", nore)

-- Quick activate macro
map("n", "Q", "@q", nore)

-- Reselect visual linewise
map("n", "gV", "'<V'>", nore)
map("v", "gV", "<esc>'<V'>", nore)
-- Reselect visual block wise
map("n", "g<C-v>", "'<C-v>'>", nore)
map("v", "g<C-v>", "<esc>'<C-v>'>", nore)

-- Use reselect as an operator
op_from "gv"
op_from "gV"
op_from "g<C-v>"

local function undo_brkpt(key)
  -- map("i", key, key .. "<c-g>u", nore)
  map("i", key, "<c-g>u" .. key, nore)
end
local undo_brkpts = {
  "<CR>",
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
map("v", "I", "<M-a>i", sile)
map("v", "A", "<M-a>a", sile)

-- Select all matching regex search
-- map("n", "<M-S-/>", "<M-/><M-a>", {})

-- Multi select object
map("n", "<M-v>", utils.operatorfunc_keys("multiselect", "<M-n>"), sile)
-- Multi select all
map("n", "<M-S-v>", utils.operatorfunc_keys("multiselect_all", "<M-S-a>"), sile)

-- go to beginning and end of text object
-- map("n", "[[", "vmo<esc>", sile)
-- map("n", "]]", "vm<esc>", sile)
map("n", "[[", utils.operatorfunc_keys("gotobeg", "o<esc>"), sile)
map("n", "]]", utils.operatorfunc_keys("gotoend", "<esc>"), sile)

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
map("o", "ie", ":<c-u>normal! mzggVG<cr>`z", nore)
map("v", "ie", "gg0oG$", nore)

-- Operator for current line
-- sel_map("il", "g_o^")
-- sel_map("al", "$o0")

-- Make change line (cc) preserve indentation
map("n", "cc", "^cg_", sile)

-- add j and k with count to jumplist
map("n", "j", [[(v:count > 1 ? "m'" . v:count : '') . 'j']], expr)
map("n", "k", [[(v:count > 1 ? "m'" . v:count : '') . 'k']], expr)

require("lv-hop").keymaps()
require("lv-zen").keymaps()
require("lv-dial").keymaps()
require("lv-neoterm").keymaps()

map("t", "<ESC>", "<ESC>", nore)
map("t", "<ESC><ESC>", [[<C-\><C-n>]], nore)
