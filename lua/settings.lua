---  HELPERS  --- 
local cmd = vim.cmd
local opt = vim.opt

---  VIM ONLY COMMANDS  ---

cmd('filetype plugin on') -- filetype detection
cmd('let &titleold="' .. TERMINAL .. '"')
cmd('set inccommand=split') -- show what you are substituting in real time
cmd('set iskeyword+=-') -- treat dash as a separate word
cmd('set sessionoptions+=globals') -- Track global variables in sessionopts
cmd('set whichwrap+=<,>,[,],h,l') -- move to next line with theses keys
if O.transparent_window then
    cmd('au ColorScheme * hi Normal ctermbg=none guibg=none')
end

--- COLORSCHEME ---

vim.g.colors_name = O.colorscheme

---  SETTINGS  ---

-- LuaFormatter off
opt.backup          = false                     -- creates a backup file
opt.clipboard       = "unnamedplus"             -- allows neovim to access the system clipboard
opt.cmdheight       = 2                         -- more space in the neovim command line for displaying messages
opt.colorcolumn     = "99999"                   -- fix indentline for now
opt.completeopt     = {'menuone', 'noselect'}
opt.conceallevel    = 0                         -- so that `` is visible in markdown files
opt.fileencoding    = "utf-8"                   -- the encoding written to a file
opt.guifont         = "FiraCode Nerd Font:h14"  -- the font used in graphical neovim applications
opt.hidden          = O.hidden_files            -- required to keep multiple buffers and open multiple buffers
opt.hlsearch        = O.hl_search               -- highlight all matches on previous search pattern
opt.ignorecase      = O.ignore_case             -- ignore case in search patterns
opt.mouse           = "a"                       -- allow the mouse to be used in neovim
opt.pumheight       = 10                        -- pop up menu height
opt.showmode        = false                     -- we don't need to see things like -- INSERT -- anymore
opt.showtabline     = 2                         -- always show tabs
opt.smartcase       = O.smart_case              -- smart case
opt.smartindent     = true                      -- make indenting smarter again
opt.splitbelow      = true                      -- force all horizontal splits to go below current window
opt.splitright      = true                      -- force all vertical splits to go to the right of current window
opt.swapfile        = false                     -- creates a swapfile
opt.termguicolors   = true                      -- set term gui colors (most terminals support this)
opt.timeoutlen      = O.timeoutlen              -- time to wait for a mapped sequence to complete (in milliseconds)
opt.title           = true                      -- set the title of window to the value of the titlestring
opt.titlestring     = "%<%F%=%l/%L - nvim"      -- what the title of the window will be set to
opt.undodir         = CACHE_PATH .. '/undo'     -- set an undo directory
opt.undofile        = true                      -- enable persisten undo
opt.updatetime      = 300                       -- faster completion
opt.writebackup     = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.expandtab       = true                      -- convert tabs to spaces
opt.shiftwidth      = 4                         -- the number of spaces inserted for each indentation
opt.shortmess:append("c")                       -- don't pass messages to |ins-completion-menu|
opt.tabstop         = 4                         -- insert 4 spaces for a tab
opt.cursorline      = O.cursorline              -- highlight the current line
opt.number          = O.number                  -- set numbered lines
opt.relativenumber  = O.relative_number         -- set relative numbered lines
opt.signcolumn      = "yes"                     -- always show the sign column, otherwise it would shift the text each time
opt.wrap            = O.wrap_lines              -- display lines as one long line
opt.scrolloff       = O.scrolloff               -- Scrolloffset to block the cursor from reaching the top/bottom

-- LuaFormatter on

-- TODO: Clean up and organize all of these below
-- quick-scope
-- vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}

-- sneak
vim.g["sneak#label"] = 1

vim.g.VM_maps = nil
-- Can these be moved to a new file?
-- TODO: why these are broken??
vim.g.VM_maps = {
    ['Find Under'] = '<M-d>',
    ['Find Subword Under'] = '<M-d>',
    ['Add Cursor Down'] = '<M-j>',
    ['Add Cursor Up'] = '<M-k>',
    ['Select Cursor Down'] = '<M-S-j>',
    ['Select Cursor Up'] = '<M-S-k>',
    ['Visual Cursors'] = '<M-c>',
    ['Visual Regex'] = 'm',
    ['Find Operator'] = 'm' -- FIXME: Some plugin is conflicting and making this not work, unless i type fast
}
vim.g.VM_leader = '\\'
vim.g.VM_theme = 'neon'

-- vim.o.guifont = "JetBrains\\ Mono\\ Regular\\ Nerd\\ Font\\ Complete"

-- Floaterm
vim.g.floaterm_keymap_toggle = '<F4>'
-- vim.g.floaterm_keymap_next   = '<F2>'
-- vim.g.floaterm_keymap_prev   = '<F3>'
-- vim.g.floaterm_keymap_new    = '<F4>'
vim.g.floaterm_title = ''
vim.g.floaterm_gitcommit = 'floaterm'
vim.g.floaterm_shell = O.shell
vim.g.floaterm_autoinsert = 1
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.floaterm_wintitle = 0
vim.g.floaterm_autoclose = 1

-- vim.cmd('set conceallevel=2')

-- TODO: figure out mappings for this that dont conflict with autocomplete
vim.g.UltiSnipsExpandTrigger = '<f5>'
-- vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
-- vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"

vim.g.slime_target = 'neovim'

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

