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
-- O.shell = "fish"
O.termshell = "fish"
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

-- TODO: figure out mappings for this that dont conflict with autocomplete
vim.g.UltiSnipsExpandTrigger = "<f5>"
-- vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
-- vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"

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
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_refresh_rate=120
vim.opt.guifont = "FiraCode Nerd Font:h10" -- the font used in graphical neovim applications

require("lv-utils").define_augroups {
  _general_settings = {
    {
      "TextYankPost",
      "*",
      "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
    },
    {
      "BufWinEnter",
      "*",
      "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    },
    {
      "BufRead",
      "*",
      "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    },
    {
      "BufRead",
      "*",
      "set hlsearch",
    },
    {
      "BufNewFile",
      "*",
      "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    },
    { "FileType", "qf", "set nobuflisted" },
    -- TODO: Test This -- { "BufWritePost", "lv-config.lua", "lua require('lv-utils').reload_lv_config()" },
    -- { "VimLeavePre", "*", "set title set titleold=" },
  },
  -- _solidity = {
  --     {'BufWinEnter', '.sol', 'setlocal filetype=solidity'}, {'BufRead', '*.sol', 'setlocal filetype=solidity'},
  --     {'BufNewFile', '*.sol', 'setlocal filetype=solidity'}
  -- },
  -- _gemini = {
  --     {'BufWinEnter', '.gmi', 'setlocal filetype=markdown'}, {'BufRead', '*.gmi', 'setlocal filetype=markdown'},
  --     {'BufNewFile', '*.gmi', 'setlocal filetype=markdown'}
  -- },
  -- _latex = {
  --     {'FileType', 'latex', 'VimtexCompile'},
  --     {'FileType', 'latex', 'setlocal wrap'},
  --     {'FileType', 'latex', 'setlocal spell'}
  --     -- {'FileType', 'latex', 'set guifont "FiraCode Nerd Font:h15'},
  -- },
  _packer_compile = { { "User", "PackerComplete", "++once PackerCompile" } },
  _buffer_bindings = {
    { "FileType", "dashboard", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>" },
  },
  _terminal_insert = {
    { "BufEnter", "*", [[if &buftype == 'terminal' | :startinsert | endif]] },
  },
  _auto_reload = {
    -- will check for external file changes on cursor hold
    { "CursorHold", "*", "silent! checktime" },
  },
  _auto_resize = {
    -- will cause split windows to be resized evenly if main window is resized
    { "VimResized", "*", "wincmd =" },
  },
  _mode_switching = {
    -- will switch between absolute and relative line numbers depending on mode
    {
      "InsertEnter",
      "*",
      "if &relativenumber | let g:ms_relativenumberoff = 1 | setlocal number norelativenumber | endif",
    },
    { "InsertLeave", "*", 'if exists("g:ms_relativenumberoff") | setlocal relativenumber | endif' },
    --[[ { "InsertEnter", "*", "if &cursorline | let g:ms_cursorlineoff = 1 | setlocal nocursorline | endif" },
    { "InsertLeave", "*", 'if exists("g:ms_cursorlineoff") | setlocal cursorline | endif' }, ]]
  },
  _focus_lost = {
    { "FocusLost,TabLeave,BufLeave", "*", [[if &buftype == '' | :update | endif]] },
    -- { "FocusLost", "*", [[silent! call feedkeys("\<C-\>\<C-n>")]] },
    -- { "TabLeave,BufLeave", "*", [[if &buftype == '' | :stopinsert | endif]] }, -- FIXME: This breaks compe
  },
}
