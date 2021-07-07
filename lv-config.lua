--[[
O is the global options object

Formatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- general
O.colorscheme = "snazzy"
O.shell = "fish"
O.lushmode = false
O.hlsearch = true -- This has a bug

-- After changing plugin config it is recommended to run :PackerCompile
local disable_plugins = {
  "lsp_rooter",
  "snap",
  "lush",
  "fzf",
  "tabnine",
  "tmux_navigator",
  "hop",
  "lazygit",
  "anywise_reg",
  "quickscope",
}
for _, v in ipairs(disable_plugins) do
  O.plugin[v].active = false
end

-- dashboard
-- O.dashboard.custom_header = {""}
O.dashboard.footer = { "Anshuman Medhi (IndianBoy42)" }

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ignore_install = {}
O.treesitter.enabled = true

-- Clang
-- O.lang.clang.diagnostics.virtual_text = true
O.lang.clang.diagnostics.signs = true
O.lang.clang.diagnostics.underline = true

-- python
O.lang.python.formatter = "black"
-- O.python.linter = 'flake8'
O.lang.python.isort = true
O.lang.python.analysis.type_checking = "off"

-- javascript
O.lang.tsserver.linter = "eslint"
O.lang.tsserver.formatter = "prettier"

-- rust
O.lang.rust.rust_tools.active = true

-- latex
O.lang.latex.vimtex.active = true
O.lang.latex.chktex.on_edit = true
O.lang.latex.chktex.on_open_and_save = true
-- TODO: use tectonic here
-- O.lang.latex.build.args =
-- O.lang.latex.build.executable =
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

vim.g.VM_maps = nil
-- Can these be moved to a new file?
vim.g.VM_maps = {
  ["Find Under"] = "<M-n>",
  ["Find Subword Under"] = "<M-n>",
  ["Add Cursor Down"] = "<M-j>",
  ["Add Cursor Up"] = "<M-k>",
  ["Select Cursor Down"] = "<M-S-j>",
  ["Select Cursor Up"] = "<M-S-k>",
  ["Visual Cursors"] = "<M-c>",
  ["Visual Add"] = "<M-a>", -- Turn visual selection into a multiple regions
  ["Visual Regex"] = "/",
  -- FIXME: Some plugin is conflicting and making this not work, unless i type fast
  ["Find Operator"] = "m",
}
vim.g.VM_leader = [[\]]
vim.g.VM_theme = "neon"

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
require("lv-utils").define_augroups {
  _focus_lost = {
    { "FocusLost", "*", "silent! w" },
    { "TabLeave,BufLeave", "*", "silent! w" },
    -- TODO: Make this only for File buffers not Terminals and Telescope
    -- { "FocusLost", "*", [[silent! call feedkeys("\<C-\>\<C-n>")]] },
    -- { "TabLeave,BufLeave", "*", "stopinsert" },
  },
}
vim.opt.autowriteall = true
-- vim.api.nvim_command "au FocusLost * silent! wa"
-- vim.api.nvim_command "au TabLeave * silent! w"
-- vim.api.nvim_command "au TabLeave * silent! stopinsert"
-- vim.api.nvim_command [[au FocusLost * silent! call feedkeys("\<C-\>\<C-n>")]]
-- vim.api.nvim_command ":set autowriteall"

vim.g.gitblame_enabled = 0
