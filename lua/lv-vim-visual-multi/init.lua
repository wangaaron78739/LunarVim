-- let g:VM_maps = {}
-- let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
-- let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n
-- let g:VM_maps["Select Cursor Down"] = '<M-C-Down>'      " start selecting down
-- let g:VM_maps["Select Cursor Up"]   = '<M-C-Up>'        " start selecting up

vim.g.VM_maps = nil
-- vim.g.VM_default_mappings = 0
vim.g.VM_maps = {
    ['Find Under'] = '<M-d>',
    ['Find Subword Under'] = '<M-d>',
    ['Select Cursor Down'] = '<M-C-Down>',
    ['Select Cursor Up'] = '<M-C-Up>'
}
