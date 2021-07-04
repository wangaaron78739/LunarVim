local map = vim.api.nvim_set_keymap
local opts = {silent = true}
local nore = {noremap = true, silent = true}
local expr = {noremap = true, silent = true, expr = true}

-- TODO: change all the vim.cmd to map

-- map('n', '-', ':RnvimrToggle<CR>', nore)

-- better window movement -- tmux_navigator supplies these if installed
if not O.plugin.tmux_navigator.active then
    map('n', '<C-h>', '<C-w>h', opts)
    map('n', '<C-j>', '<C-w>j', opts)
    map('n', '<C-k>', '<C-w>k', opts)
    map('n', '<C-l>', '<C-w>l', opts)
end
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

-- Move current line / block with Alt-j/k ala vscode.
map('n', '<C-A-j>', ':m .+1<CR>==', nore)
map('n', '<C-A-k>', ':m .-2<CR>==', nore)
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', nore)
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', nore)
map('x', '<A-j>', ':m \'>+1<CR>gv-gv', nore)
map('x', '<A-k>', ':m \'<-2<CR>gv-gv', nore)
-- Move selected line / block of text in visual mode
map('x', 'K', ':move \'<-2<CR>gv=gv', nore)
map('x', 'J', ':move \'>+1<CR>gv=gv', nore)

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
-- map('n', '<TAB>', ':bnext<CR>', nore)
-- map('n', '<S-TAB>', ':bprevious<CR>', nore)
map('n', '<TAB>', '<cmd>b#<cr>', nore)
map('n', '<S-TAB>', ':bnext<CR>', nore)

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

-- QuickFix
-- map('n', ']q', ':cnext<CR>', nore)
-- map('n', '[q', ':cprev<CR>', nore)
map('n', '<C-A-j>', ':cnext<CR>', nore)
map('n', '<C-A-k>', ':cprev<CR>', nore)
-- Toggle the QuickFix window -- FIXME: this function doesn't exist anymore
-- map('', '<C-q>', ':call QuickFixToggle()<CR>', nore)

-- Escape key clears search and spelling highlights
map('n', '<ESC>', ":nohls | :setlocal nospell<ESC>", {silent = true})

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

-- Format buffer -- TODO: switch between neoformat and lsp
map('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<cr>', nore)
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', nore)

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

-- Slightly easier commands
map('n', ';', ':', opts)

-- lsp keys
map('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
map('n', 'gD', "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
map('n', 'gr', "<cmd>lua vim.lsp.buf.references()<CR>", opts)
map('n', 'gi', "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
map('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
map('n', '<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

if O.plugin.ts_hintobjects.active then
    map('o', 'm', [[:<C-U>lua require('tsht').nodes()<CR>]], opts)
    map('v', 'm', [[:lua require('tsht').nodes()<CR>]], nore)
end

if O.plugin.surround.active then
    map('x', 'is', [[<Plug>(textobj-sandwich-query-i)]], opts)
    map('x', 'as', [[<Plug>(textobj-sandwich-query-a)]], opts)
    map('o', 'is', [[<Plug>(textobj-sandwich-query-i)]], opts)
    map('o', 'as', [[<Plug>(textobj-sandwich-query-a)]], opts)
end

-- map('i', '<C-TAB>', 'compe#complete()', {noremap = true, silent = true, expr = true})

-- vim.cmd([[
-- map p <Plug>(miniyank-autoput)
-- map P <Plug>(miniyank-autoPut)
-- map <leader>n <Plug>(miniyank-cycle)
-- map <leader>N <Plug>(miniyank-cycleback)
-- ]])
