local map = vim.api.nvim_set_keymap
local opts = {silent = true}
local nore = {noremap = true, silent = true}
local expr = {noremap = true, silent = true, expr = true}

-- TODO: change all the vim.cmd to vim.api.nvim_set_keymap
-- vim.api.nvim_set_keymap('n', '-', ':RnvimrToggle<CR>', nore)
-- better window movement
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)
-- TODO fix this
-- Terminal window navigation
map('t', '<C-h>', [[<C-\><C-N><C-w>h]], nore)
map('t', '<C-j>', [[<C-\><C-N><C-w>j]], nore)
map('t', '<C-k>', [[<C-\><C-N><C-w>k]], nore)
map('t', '<C-l>', [[<C-\><C-N><C-w>l]], nore)
map('i', '<C-h>', [[<C-\><C-N><C-w>h]], nore)
map('i', '<C-j>', [[<C-\><C-N><C-w>j]], nore)
map('i', '<C-k>', [[<C-\><C-N><C-w>k]], nore)
map('i', '<C-l>', [[<C-\><C-N><C-w>l]], nore)
map('t', '<Esc>', [[<C-\><C-n>]], nore)
-- vim.cmd([[
--   tnoremap <C-h> <C-\><C-N><C-w>h
--   tnoremap <C-j> <C-\><C-N><C-w>j
--   tnoremap <C-k> <C-\><C-N><C-w>k
--   tnoremap <C-l> <C-\><C-N><C-w>l
--   inoremap <C-h> <C-\><C-N><C-w>h
--   inoremap <C-j> <C-\><C-N><C-w>j
--   inoremap <C-k> <C-\><C-N><C-w>k
--   inoremap <C-l> <C-\><C-N><C-w>l
--   tnoremap <Esc> <C-\><C-n>
-- ]])

-- TODO fix this
-- resize with arrows
map('n', '<C-Up>', ':resize -2<CR>', opts)
map('n', '<C-Down>', ':resize +2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- better indenting
map('n', '<', 'v<', nore)
map('n', '>', 'v>', nore)
map('n', 'g<', '<', nore)
map('n', 'g>', '>', nore)
map('v', '<', '<gv', nore)
map('v', '>', '>gv', nore)

-- I hate escape
map('i', 'jk', '<ESC>', nore)
map('i', 'kj', '<ESC>', nore)

-- Tab switch buffer
map('n', '<TAB>', ':bnext<CR>', nore)
map('n', '<S-TAB>', ':bprevious<CR>', nore)

-- Move selected line / block of text in visual mode
map('x', 'K', ':move \'<-2<CR>gv=gv', nore)
map('x', 'J', ':move \'>+1<CR>gv=gv', nore)

-- Preserve register on pasting in visual mode
map('v', 'p', 'pgvy', nore)
map('v', 'P', 'p', nore) -- for normal p behaviour

-- Better nav for omnicomplete
map('i', '<c-j>', '(\"\\<C-n>\")', expr)
-- vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
map('i', '<TAB>', '(\"\\<C-n>\")', expr)
-- vim.cmd('inoremap <expr> <TAB> (\"\\<C-n>\")')
map('i', '<c-k>', '(\"\\<C-p>\")', expr)
-- vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')
map('i', '<S-TAB>', '(\"\\<C-p>\")', expr)
-- vim.cmd('inoremap <expr> <S-TAB> (\"\\<C-p>\")')

-- map('i', '<C-TAB>', 'compe#complete()', {noremap = true, silent = true, expr = true})

-- vim.cmd([[
-- map p <Plug>(miniyank-autoput)
-- map P <Plug>(miniyank-autoPut)
-- map <leader>n <Plug>(miniyank-cycle)
-- map <leader>N <Plug>(miniyank-cycleback)
-- ]])

-- Toggle the QuickFix window
map('', '<C-q>', ':call QuickFixToggle()<CR>', nore)

-- Yank till end of the line 
map('n', 'Y', 'yg_', nore)

-- Go Back
map('n', 'gb', '<c-o>', opts)

-- comment and copy
map('n', 'gyy', 'yy:CommentToggle<cr>p', nore)
map('v', 'gy', 'ygv:<c-u>call CommentOperator(visualmode())<cr>`>p', nore)

-- Select Jupyter Cell
map('v', 'ic', [[/#+\s*%+<cr>oN]], nore)

-- Close FTerm
map('t', '<A-q>', '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>', nore)

-- Format buffer
map('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<cr>', nore)

-- Spell checking
map('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u]]', nore)

-- Vscode style commenting in insert mode
map('i', '<C-/>', '<C-\\><C-n><CMD>CommentToggle', nore)

-- Fix gcc keymapping
-- vim.api.nvim_del_keymap('n', 'gc')
map('n', 'gcc', '<cmd>CommentToggle<cr>', nore)

-- Visual mode start search (like *)
map('v', '*', '"ay/<C-R>a<cr>', nore)

-- peek definition
map('n', 'gpd', ':Lspsaga preview_definition<cr>', opts)

if O.plugin.ts_hintobjects.active then
    map('o', 'm', [[:<C-U>lua require('tsht').nodes()<CR>]], opts)
    map('v', 'm', [[:lua require('tsht').nodes()<CR>]], nore)
end
