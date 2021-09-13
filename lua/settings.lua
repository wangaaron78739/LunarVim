---  HELPERS  ---
local cmd = vim.cmd
local opt = vim.opt

---  VIM ONLY COMMANDS  ---

cmd "filetype plugin on"
cmd "set iskeyword+=-"
cmd "set sessionoptions+=globals"
cmd "set whichwrap+=<,>,[,],h,l"
if vim.g.nvui then
  cmd "NvuiFrameless v:false"
end
if O.transparent_window then
  cmd "au ColorScheme * hi Normal ctermbg=none guibg=none"
  cmd "au ColorScheme * hi SignColumn ctermbg=none guibg=none"
end

---  SETTINGS  ---
-- https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
opt.shell = O.shell
-- opt.shell = O.termshell
opt.inccommand = O.inc_subs -- Incremental substitution style
opt.backspace = "indent,eol,start"
opt.backup = false -- creates a backup file
opt.clipboard = O.clipboard -- allows neovim to access the system clipboard
opt.cmdheight = O.cmdheight -- more space in the neovim command line for displaying messages
opt.colorcolumn = O.colorcolumn
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.hidden = O.hidden_files -- required to keep multiple buffers and open multiple buffers
opt.hlsearch = O.hl_search -- highlight all matches on previous search pattern
opt.ignorecase = O.ignore_case -- ignore case in search patterns
opt.mouse = "nhr" -- allow the mouse to be used in neovim
opt.pumheight = 10 -- pop up menu height
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2 -- always show tabs
opt.smartcase = O.smart_case -- smart case
opt.smartindent = true -- make indenting smarter again
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.swapfile = false -- creates a swapfile
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.timeoutlen = O.timeoutlen -- time to wait for a mapped sequence to complete (in milliseconds)
opt.title = true -- set the title of window to the value of the titlestring
opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
opt.updatetime = 300 -- faster completion
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.expandtab = true -- convert tabs to spaces
opt.shiftwidth = O.shift_width -- the number of spaces inserted for each indentation
opt.shortmess:append "c"
opt.shortmess:append "F"
opt.tabstop = O.tab_stop -- insert 4 spaces for a tab
opt.cursorline = O.cursorline -- highlight the current line
opt.number = O.number -- set numbered lines
opt.relativenumber = O.relative_number -- set relative numbered lines
opt.numberwidth = O.number_width -- set number column width to 2 {default 4}
opt.signcolumn = (O.signcolumn == "number" and not (O.number or O.relative_number)) and "yes" or O.signcolumn --
opt.wrap = O.wrap_lines -- display lines as one long line
opt.linebreak = true -- dont linebreak in the middle of words
opt.spell = O.spell
opt.spelllang = O.spelllang
opt.scrolloff = O.scrolloff -- Scrolloffset to block the cursor from reaching the top/bottom
opt.breakindent = true -- Apply indentation for wrapped lines
opt.breakindentopt = "sbr" -- Apply indentation for wrapped lines
opt.pastetoggle = "<F3>" -- Enter Paste Mode with
opt.foldlevelstart = 99 -- Don't fold on startup
opt.foldcolumn = O.fold_columns -- Add fold indicators to number column
opt.foldmethod = "indent" -- Set default fold method as indent, although will be overriden by treesitter soon anyway
opt.lazyredraw = true -- When running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen, which greatly speeds it up, upto 6-7x faster
opt.autowriteall = true -- auto write on focus lost
opt.sidescroll = 1
opt.sidescrolloff = 10
opt.listchars = { extends = ">", precedes = "<", trail = "_" }
opt.background = "dark"
vim.g.python3_host_prog = O.python_interp

-- opt.undodir = CACHE_PATH .. "/undo" -- set an undo directory
local undodir = "/tmp/.undodir_" .. vim.env.USER
if not vim.fn.isdirectory(undodir) then
  vim.fn.mkdir(undodir, "", 0700)
end
opt.undodir = undodir
opt.undofile = true -- enable persistent undo

-- Default autocommands
require("lv-utils").define_augroups {
  _general_settings = {
    { "TextYankPost", "*", "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})" },
    { "BufWinEnter", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
    { "BufRead", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
    { "BufRead", "*", "set hlsearch" },
    -- { "CursorMoved,InsertEnter", "*", "nohlsearch" },
    { "BufNewFile", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
    { "FileType", "qf", "set nobuflisted" },
    -- TODO: Test This -- { "BufWritePost", "lv-config.lua", "lua require('lv-utils').reload_lv_config()" },
    -- { "VimLeavePre", "*", "set title set titleold=" },
  },
  _packer_compile = { { "User", "PackerComplete", "++once PackerCompile" } },
  _buffer_bindings = { { "FileType", "dashboard", "nnoremap <silent> <buffer> q :q<CR>" } },
  _terminal_insert = { { "BufEnter", "term://*", "startinsert" } },
  -- will check for external file changes on cursor hold
  _auto_reload = { { "CursorHold", "*", "silent! checktime" } },
  -- will cause split windows to be resized evenly if main window is resized
  _auto_resize = { { "VimResized", "*", "wincmd =" } },
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
  -- Add position to jump list on cursorhold -- FIXME: slightly buggy
  -- _hold_jumplist = { { "CursorHold", "*", "normal m'" } },
}

if O.format_on_save then
  require("lv-utils").define_augroups {
    autoformat = {
      { "BufWritePre", "*", "lua vim.lsp.buf.formatting_sync(nil, " .. O.format_on_save_timeout .. ")" },
    },
  }
end

-- neovide settings
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_refresh_rate=120
require("lv-utils").set_guifont(O.fontsize, "FiraCode Nerd Font")
