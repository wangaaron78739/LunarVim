--[[
O is the global options object

Formatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]] -- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- general
O.auto_complete = true
O.colorscheme = 'snazzy'
O.auto_close_tree = 0
O.wrap_lines = false
O.timeoutlen = 100
O.document_highlight = true
O.extras = true
O.leader_key = ' '
O.ignore_case = true
O.smart_case = true
O.shell = 'fish'
O.lushmode = false

-- After changing plugin config it is recommended to run :PackerCompile
O.plugin.lsp_rooter.active = false -- This is actually more confusing sometimes
O.plugin.snap.active = false
O.plugin.octo.active = false

-- dashboard
-- O.dashboard.custom_header = {""}
O.dashboard.footer = {"Anshuman Medhi (IndianBoy42)"}

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "all"
-- O.treesitter.ignore_install = {"haskell"}
O.treesitter.enabled = true

O.lang.clang.active = true
O.lang.clang.autoformat = true
O.lang.clang.diagnostics.virtual_text = true
O.lang.clang.diagnostics.signs = true
O.lang.clang.diagnostics.underline = true

-- python
-- add things like O.python.formatter.yapf.exec_path
-- add things like O.python.linter.flake8.exec_path
-- add things like O.python.formatter.isort.exec_path
O.lang.python.formatter = 'black'
-- O.python.linter = 'flake8'
O.lang.python.isort = true
O.lang.python.autoformat = true
O.lang.python.diagnostics.virtual_text = true
O.lang.python.diagnostics.signs = true
O.lang.python.diagnostics.underline = true
O.lang.python.analysis.type_checking = "off"
O.lang.python.analysis.auto_search_paths = true
O.lang.python.analysis.use_library_code_types = true

-- lua
-- TODO look into stylua
O.lang.lua.formatter = 'lua-format'
O.lang.lua.autoformat = true

-- javascript
O.lang.tsserver.formatter = 'prettier'
O.lang.tsserver.linter = 'eslint'
O.lang.tsserver.autoformat = true

-- json
O.lang.json.autoformat = true

-- ruby
O.lang.ruby.autoformat = true

-- go
O.lang.go.autoformat = true

-- rust
O.lang.rust.active = true
O.lang.rust.rust_tools.active = true
O.lang.rust.autoformat = true

-- latex
O.lang.latex.active = true
O.lang.latex.autoformat = true

-- create custom autocommand field (This would be easy with lua)

-- Turn off relative_numbers
-- O.relative_number = false

-- Turn off cursorline
-- O.cursorline = false

-- My settings
O.scrolloff = 10

-- Turn off cursorline
-- O.cursorline = false

