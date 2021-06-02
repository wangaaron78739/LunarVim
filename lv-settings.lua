--[[
O is the global options object

Formatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]]

-- general
O.auto_complete = true
O.colorscheme = 'snazzy'
O.auto_close_tree = 0
O.wrap_lines = false
O.timeoutlen = 100
O.document_highlight = true
O.extras = true

-- dashboard
-- O.dashboard.custom_header = {""}
-- O.dashboard.footer = {""}

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "all"
O.treesitter.ignore_install = {"haskell"}
O.treesitter.highlight.enabled = true


O.clang.diagnostics.virtual_text = false
O.clang.diagnostics.signs = false
O.clang.diagnostics.underline = false

-- python
-- add things like O.python.formatter.yapf.exec_path
-- add things like O.python.linter.flake8.exec_path
-- add things like O.python.formatter.isort.exec_path
O.python.formatter = 'black'
-- O.python.linter = 'flake8'
O.python.isort = true
O.python.autoformat = true
O.python.diagnostics.virtual_text = true
O.python.diagnostics.signs = true
O.python.diagnostics.underline = true
O.python.analysis.type_checking = "off"
O.python.analysis.auto_search_paths = true
O.python.analysis.use_library_code_types = true

-- lua
-- TODO look into stylua
O.lua.formatter = 'lua-format'
-- O.lua.formatter = 'lua-format'
O.lua.autoformat = false

-- javascript
O.tsserver.formatter = 'prettier'
O.tsserver.linter = 'eslint'
O.tsserver.autoformat = true

-- json
O.json.autoformat = true

-- ruby
O.ruby.autoformat = true

-- go
O.go.autoformat = true
-- create custom autocommand field (This would be easy with lua)

-- Turn off relative_numbers
-- O.relative_number = false

-- Aaron Custom Settings 
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 10

-- vimtex
vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=0
vim.g.vimtex_compiler_latexmk =  {
     ['options'] = {
       '-shell-escape',
       '-verbose',
       '-file-line-error',
       '-synctex=1',
       '-interaction=nonstopmode',
     },
}

-- quick-scope
vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}

-- sneak
vim.g["sneak#label"] = 1

-- vm
vim.g.VM_maps = {
    ['Find Under'] = '<M-d>',
    ['Find Subword Under'] = '<M-d>',
    ['Select Cursor Down'] = '<M-C-Down>',
    ['Select Cursor Up'] = '<M-C-Up>'
}

-- -- Floaterm (unused)
-- vim.g.floaterm_keymap_toggle = '<F4>'
-- -- vim.g.floaterm_keymap_next   = '<F2>'
-- -- vim.g.floaterm_keymap_prev   = '<F3>'
-- -- vim.g.floaterm_keymap_new    = '<F4>'
-- vim.g.floaterm_title=''
-- vim.g.floaterm_gitcommit='floaterm'
-- vim.g.floaterm_shell=O.shell
-- vim.g.floaterm_autoinsert=1
-- vim.g.floaterm_width=0.8
-- vim.g.floaterm_height=0.8
-- vim.g.floaterm_wintitle=0
-- vim.g.floaterm_autoclose=1

-- Ultisnips
vim.g.UltiSnipsExpandTrigger="<F5>"
vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"
