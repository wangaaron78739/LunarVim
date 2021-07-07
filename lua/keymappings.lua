local map = vim.api.nvim_set_keymap
local sile = { silent = true }
local nore = { noremap = true, silent = true }
local expr = { noremap = true, silent = true, expr = true }

-- Set leader
if O.leader_key == " " or O.leader_key == "space" then
  vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })
  vim.g.mapleader = " "
else
  vim.api.nvim_set_keymap("n", O.leader_key, "<NOP>", { noremap = true, silent = true })
  vim.g.mapleader = O.leader_key
end

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
map("n", "<C-S>", "<esc>:update<cr>", sile)
map("v", "<C-S>", "<esc>:update<cr>", sile)
map("i", "<C-S>", "<esc>:update<cr>", sile)

-- map('n', '-', ':RnvimrToggle<CR>', nore)

-- better window movement -- tmux_navigator supplies these if installed
if not O.plugin.tmux_navigator.active then
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
  resize_prefix = "<A-"
end
vim.api.nvim_set_keymap("n", resize_prefix .. "Up>", ":resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", resize_prefix .. "Down>", ":resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", resize_prefix .. "Left>", ":vertical resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", resize_prefix .. "Right>", ":vertical resize +2<CR>", { silent = true })

-- Move current line / block with Alt-j/k ala vscode.
map("n", "<C-A-j>", ":m .+1<CR>==", nore)
map("n", "<C-A-k>", ":m .-2<CR>==", nore)
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", nore)
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", nore)
map("x", "<A-j>", ":m '>+1<CR>gv-gv", nore)
map("x", "<A-k>", ":m '<-2<CR>gv-gv", nore)
-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv=gv", nore)
map("x", "J", ":move '>+1<CR>gv=gv", nore)

-- better indenting
map("n", "<", "v<", nore)
map("n", ">", "v>", nore)
map("n", "g<", "<", nore)
map("n", "g>", ">", nore)
map("v", "<", "<gv", nore)
map("v", ">", ">gv", nore)

-- I hate escape
map("i", "jk", "<ESC>", nore)
map("i", "kj", "<ESC>", nore)

-- Tab switch buffer
-- map('n', '<TAB>', ':bnext<CR>', nore)
-- map('n', '<S-TAB>', ':bprevious<CR>', nore)
map("n", "<TAB>", "<cmd>b#<cr>", nore)
map("n", "<S-TAB>", ":bnext<CR>", nore)

-- Preserve register on pasting in visual mode
map("v", "p", "pgvy", nore)
map("v", "P", "p", nore) -- for normal p behaviour

-- Non destructive delete/change
local function _op(m, c)
  map(m, "<M-" .. c .. ">", '"_' .. c, nore)
end
_op("n", "d")
_op("n", "c")
_op("n", "D")
_op("n", "C")
map("v", "x", '"_d', nore)
map("v", "r", '"_r', nore)
-- Original paste for when 'nvim-anywise-reg.lua' is installed
map("n", "<M-p>", "p", nore)
map("n", "<M-C-p>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pp]], nore) -- charwise paste
map("n", "<M-S-P>", "P", nore)
map("n", "<M-S-C-P>", [[<cmd>call setreg('p', getreg('+'), 'c')<cr>"pP]], nore) -- charwise paste
-- map("n", "<M-S-p>", [[<cmd>call setreg('p', getreg('+'), 'l')<cr>"pp]], nore) -- linewise paste

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
map("n", "<M-j>", "jV", sile)
map("n", "<M-k>", "kV", sile)
map("v", "<M-j>", "<Esc>jV", sile)
map("v", "<M-k>", "<Esc>kV", sile)

-- Charwise visual select line
map("v", "v", "^og_", sile)
map("v", "V", "0og_", sile)

-- Select last pasted/yanked text
map("n", "g<C-v>", "`[v`]", nore)

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

-- Search and Replace
-- 'c*' for word, '<leader>c*' for WORD
map("n", ",", [[*]], nore)
map("n", "g,", [[yiw/<C-R>+<CR>]], nore)
map("n", "c,", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], nore)
map("n", "<leader>c,", [[:%s/\<<C-r><C-a>\>//g<Left><Left>]], nore)

-- QuickFix
-- map('n', ']q', ':cnext<CR>', nore)
-- map('n', '[q', ':cprev<CR>', nore)
map("n", "<C-A-j>", ":cnext<CR>", nore)
map("n", "<C-A-k>", ":cprev<CR>", nore)
-- Toggle the QuickFix window -- FIXME: this function doesn't exist anymore
-- map('', '<C-q>', ':call QuickFixToggle()<CR>', nore)

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
map("n", "Y", "yg_", nore)

-- Go Back
map("n", "gb", "<c-o>", sile)

-- comment and copy
map("n", "gcy", "yygccp", sile)
map("n", "gcj", "gccjgcc", sile)
map("v", "gyc", "ygvgc`>p", sile)
-- map("v", "gjc", "gc", sile) -- Don't know how to implement this

-- Select Jupyter Cell
map("v", "ic", [[/#+\s*%+<cr>oN]], nore)

-- Toggle FTerm
map("n", "<M-i>", '<CMD>lua require("FTerm").toggle()<CR>', nore)
map("t", "<M-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', nore)
map("n", "<M-t>", ":T ", nore)
-- map("t", "<Esc>", '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>', nore)

-- Format buffer -- TODO: switch between neoformat and lsp
map("n", "gf", "<cmd>Neoformat<cr>", nore)
-- map("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<cr>", nore)
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", nore)

-- Spell checking
map("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u]]", nore)

-- Vscode style commenting in insert mode
map("i", "<C-/>", "<C-\\><C-n><CMD>CommentToggle", nore)

-- Visual mode start search (like *)
map("v", "*", '"ay/<C-R>a<cr>', nore)

-- peek definition
map("n", "gpd", ":Lspsaga preview_definition<cr>", sile)

-- Slightly easier commands
map("n", ";", ":", sile)

-- lsp keys
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", sile)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", sile)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", sile)
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", sile)
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", sile)
-- map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", sile)
vim.cmd 'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()'
-- scroll down hover doc or scroll in definition preview
--vim.cmd "nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>"
-- scroll up hover doc
--vim.cmd "nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>"

-- map('c', ';', "<CR>", sile)

if O.plugin.ts_hintobjects.active then
  map("o", "m", [[:<C-U>lua require('tsht').nodes()<CR>]], sile)
  map("v", "m", [[:lua require('tsht').nodes()<CR>]], nore)
end

if O.plugin.surround.active then
  map("x", "is", [[<Plug>(textobj-sandwich-query-i)]], sile)
  map("x", "as", [[<Plug>(textobj-sandwich-query-a)]], sile)
  map("o", "is", [[<Plug>(textobj-sandwich-query-i)]], sile)
  map("o", "as", [[<Plug>(textobj-sandwich-query-a)]], sile)
end
