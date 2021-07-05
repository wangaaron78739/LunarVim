--[[
O is the global options object

Formatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- general
O.auto_complete = true
O.colorscheme = "snazzy"
O.auto_close_tree = 0
O.wrap_lines = false
O.timeoutlen = 100
O.document_highlight = true
O.extras = true
O.leader_key = " "
O.ignore_case = true
O.smart_case = true
O.shell = "fish"
O.lushmode = false
O.hlsearch = true

-- After changing plugin config it is recommended to run :PackerCompile
local disable_plugins = {
  "lsp_rooter",
  "snap",
  "lush",
  "fzf",
  "tabnine",
  "tmux_navigator",
  "git_blame",
  "hop",
  "bracey",
}
for _, v in ipairs(disable_plugins) do
  O.plugin[v].active = false
end
-- O.plugin.lsp_rooter.active = false -- This is actually more confusing sometimes
-- O.plugin.snap.active = false
-- O.plugin.octo.active = false
-- O.plugin.lush.active = false
-- O.plugin.fzf.active = false
-- O.plugin.tabnine.active = false

-- dashboard
-- O.dashboard.custom_header = {""}
O.dashboard.footer = { "Anshuman Medhi (IndianBoy42)" }

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "all"
-- O.treesitter.ignore_install = {"haskell"}
O.treesitter.enabled = true

O.lang.clang.active = true
-- O.lang.clang.diagnostics.virtual_text = true
O.lang.clang.diagnostics.signs = true
O.lang.clang.diagnostics.underline = true

-- python
-- add things like O.python.formatter.yapf.exec_path
-- add things like O.python.linter.flake8.exec_path
-- add things like O.python.formatter.isort.exec_path
O.lang.python.formatter = "black"
-- O.python.linter = 'flake8'
O.lang.python.isort = true
-- O.lang.python.diagnostics.virtual_text = true
O.lang.python.diagnostics.signs = true
O.lang.python.diagnostics.underline = true
O.lang.python.analysis.type_checking = "off"
O.lang.python.analysis.auto_search_paths = true
O.lang.python.analysis.use_library_code_types = true

-- lua
-- TODO look into stylua
O.lang.lua.formatter = "stylua"

-- javascript
O.lang.tsserver.formatter = "prettier"
O.lang.tsserver.linter = "eslint"

-- json

-- ruby

-- go

-- rust
O.lang.rust.active = true
O.lang.rust.rust_tools.active = true

-- latex
O.lang.latex.active = true
O.lang.latex.chktex.on_edit = true
O.lang.latex.chktex.on_open_and_save = true
-- TODO: use tectonic here
O.lang.latex.build.args = {
  "-pdf",
  "-interaction=nonstopmode",
  "-synctex=1",
  "%f",
}
O.lang.latex.build.executable = "latexmk"
-- O.lang.latex.chktex.build.on_save = true -- This is handled by vimtex?

-- create custom autocommand field (This would be easy with lua)

-- Turn off relative_numbers
-- O.relative_number = false

-- Turn off cursorline
-- O.cursorline = false

-- My settings
O.scrolloff = 10

-- TODO: Clean up and organize all of these below
-- quick-scope
-- vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}

-- sneak
vim.g["sneak#label"] = 1

vim.g.VM_maps = nil
-- Can these be moved to a new file?
vim.g.VM_maps = {
  ["Find Under"] = "<M-d>",
  ["Find Subword Under"] = "<M-d>",
  ["Add Cursor Down"] = "<M-j>",
  ["Add Cursor Up"] = "<M-k>",
  ["Select Cursor Down"] = "<M-S-j>",
  ["Select Cursor Up"] = "<M-S-k>",
  ["Visual Cursors"] = "<M-c>",
  ["Visual Regex"] = "/",
  -- FIXME: Some plugin is conflicting and making this not work, unless i type fast
  ["Find Operator"] = "m",
}
vim.g.VM_leader = [[\]]
vim.g.VM_theme = "neon"

-- vim.o.guifont = "JetBrains\\ Mono\\ Regular\\ Nerd\\ Font\\ Complete"

-- Floaterm
vim.g.floaterm_keymap_toggle = "<F4>"
-- vim.g.floaterm_keymap_next   = '<F2>'
-- vim.g.floaterm_keymap_prev   = '<F3>'
-- vim.g.floaterm_keymap_new    = '<F4>'
vim.g.floaterm_title = ""
vim.g.floaterm_gitcommit = "floaterm"
vim.g.floaterm_shell = O.shell
vim.g.floaterm_autoinsert = 1
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.floaterm_wintitle = 0
vim.g.floaterm_autoclose = 1

-- vim.cmd('set conceallevel=2')

-- TODO: figure out mappings for this that dont conflict with autocomplete
vim.g.UltiSnipsExpandTrigger = "<f5>"
-- vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
-- vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"

vim.g.slime_target = "neovim"

-- Neovim turns the default cursor to 'Block'
-- when switched back into terminal.
-- This below line fixes that. Uncomment if needed.
-- vim.cmd('autocmd VimLeave,VimSuspend * set guicursor=a:ver90') -- Beam
-- vim.cmd('autocmd VimLeave,VimSuspend * set guicursor=a:hor20') -- Underline
-- NOTE: Above code doesn't take a value from the terminal's cursor and
--       replace it. It hardcodes the cursor shape.
--       And I think `ver` means vertical and `hor` means horizontal.
--       The numbers didn't make a difference in alacritty. Please change
--       the number to something that suits your needs if it looks weird.

-- neovide settings
-- vim.g.neovide_cursor_vfx_mode = "railgun"
-- vim.g.neovide_refresh_rate=120

-- Autosave
vim.api.nvim_command "au FocusLost * silent! wa"
vim.api.nvim_command ":set autowriteall"
