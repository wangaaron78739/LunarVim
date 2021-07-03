-- TODO: change all the vim.cmd to vim.api.nvim_set_keymap
-- vim.api.nvim_set_keymap('n', '-', ':RnvimrToggle<CR>', {noremap = true, silent = true})
-- better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})
-- TODO fix this
-- Terminal window navigation
vim.cmd([[
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l
  inoremap <C-h> <C-\><C-N><C-w>h
  inoremap <C-j> <C-\><C-N><C-w>j
  inoremap <C-k> <C-\><C-N><C-w>k
  inoremap <C-l> <C-\><C-N><C-w>l
  tnoremap <Esc> <C-\><C-n>
]])

-- TODO fix this
-- resize with arrows
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize +2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>',
                        {silent = true})
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>',
                        {silent = true})

-- better indenting
vim.api.nvim_set_keymap('n', '<', 'v<', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '>', 'v>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'g<', '<', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'g>', '>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

-- I hate escape
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', {noremap = true, silent = true})

-- Tab switch buffer
vim.api.nvim_set_keymap('n', '<TAB>', ':bnext<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-TAB>', ':bprevious<CR>',
                        {noremap = true, silent = true})

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<CR>gv=gv',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<CR>gv=gv',
                        {noremap = true, silent = true})

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')

-- Preserve register on pasting in visual mode
vim.api.nvim_set_keymap('v', 'p', 'pgvy', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'P', 'p', {noremap = true, silent = true}) -- for normal p behaviour
-- vim.cmd('vnoremap P "0P')
-- vim.api.nvim_set_keymap('v', 'p', '"0p', {silent = true})
-- vim.api.nvim_set_keymap('v', 'P', '"0P', {silent = true})

-- Completion window navigation
vim.cmd('inoremap <expr> <TAB> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <S-TAB> (\"\\<C-p>\")')

-- vim.api.nvim_set_keymap('i', '<C-TAB>', 'compe#complete()', {noremap = true, silent = true, expr = true})

-- vim.cmd([[
-- map p <Plug>(miniyank-autoput)
-- map P <Plug>(miniyank-autoPut)
-- map <leader>n <Plug>(miniyank-cycle)
-- map <leader>N <Plug>(miniyank-cycleback)
-- ]])

-- Toggle the QuickFix window
vim.api.nvim_set_keymap('', '<C-q>', ':call QuickFixToggle()<CR>',
                        {noremap = true, silent = true})

-- Yank till end of the line 
vim.api.nvim_set_keymap('n', 'Y', 'yg_', {noremap = true, silent = true})

-- Go Back
vim.api.nvim_set_keymap('n', 'gb', '<c-o>', {silent = true})

-- comment and copy
vim.api.nvim_set_keymap('n', 'gyy', 'yy:CommentToggle<cr>p',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'gy',
                        'ygv:<c-u>call CommentOperator(visualmode())<cr>`>p',
                        {noremap = true, silent = true})

-- Select Jupyter Cell
vim.api.nvim_set_keymap('v', 'ic', [[/#+\s*%+<cr>oN]],
                        {noremap = true, silent = true})

-- Close FTerm
vim.api.nvim_set_keymap('t', '<A-q>',
                        '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>',
                        {noremap = true, silent = true})

-- Format buffer
vim.api.nvim_set_keymap('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<cr>',
                        {noremap = true, silent = true})

-- Spell checking
vim.api.nvim_set_keymap('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u]]',
                        {noremap = true, silent = true})

-- Vscode style commenting in insert mode
vim.api.nvim_set_keymap('i', '<C-/>', '<C-\\><C-n><CMD>CommentToggle',
                        {noremap = true, silent = true})

-- Fix gcc keymapping
-- vim.api.nvim_del_keymap('n', 'gc')
vim.api.nvim_set_keymap('n', 'gcc', '<cmd>CommentToggle<cr>',
                        {noremap = true, silent = true})

-- Visual mode start search (like *)
vim.api.nvim_set_keymap('v', '*', '"ay/<C-R>a<cr>',
                        {noremap = true, silent = true})

-- peek definition
vim.api.nvim_set_keymap('n', 'gpd', ':Lspsaga preview_definition<cr>',
                        {silent = true})

