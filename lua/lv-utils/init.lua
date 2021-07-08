local lv_utils = {}

function lv_utils.reload_lv_config()
  vim.cmd "source ~/.config/nvim/lv-config.lua"
  vim.cmd "source ~/.config/nvim/lua/plugins.lua"
  vim.cmd "source ~/.config/nvim/lua/lv-neoformat/init.lua"
  vim.cmd ":PackerCompile"
  vim.cmd ":PackerInstall"
end

function lv_utils.check_lsp_client_active(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return true
    end
  end
  return false
end

function lv_utils.define_augroups(definitions) -- {{{1
  -- Create autocommand groups based on the passed definitions
  --
  -- The key will be the name of the group, and each definition
  -- within the group should have:
  --    1. Trigger
  --    2. Pattern
  --    3. Text
  -- just like how they would normally be defined from Vim itself
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    vim.cmd "autocmd!"

    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.cmd(command)
    end

    vim.cmd "augroup END"
  end
end

lv_utils.define_augroups {
  _user_autocmds = O.user_autocommands,
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
    { "VimLeavePre", "*", "set title set titleold=" },
    { "FileType", "qf", "set nobuflisted" },
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
    { "TabLeave,BufLeave", "*", [[if &buftype == '' | :stopinsert | endif]] },
  },
}

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
endfunction
]]

return lv_utils
