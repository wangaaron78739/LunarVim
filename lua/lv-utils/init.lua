local M = {}

function M.reload_lv_config()
  vim.cmd "source ~/.config/nvim/lv-config.lua"
  vim.cmd "source ~/.config/nvim/lua/plugins.lua"
  vim.cmd "source ~/.config/nvim/lua/lv-neoformat/init.lua"
  vim.cmd ":PackerCompile"
  vim.cmd ":PackerInstall"
end

function M.check_lsp_client_active(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return true
    end
  end
  return false
end

function M.define_augroups(definitions) -- {{{1
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

M.define_augroups {
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

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
endfunction
]]

function M.operatorfunc_helper_select(lines)
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "["))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, "]"))

  vim.fn.setpos(".", { 0, start_row, start_col + 1, 0 })
  if lines then
    vim.cmd "normal! V"
  else
    vim.cmd "normal! v"
  end
  if end_col == 1 then
    vim.fn.setpos(".", { 0, end_row - 1, -1, 0 })
  else
    vim.fn.setpos(".", { 0, end_row, end_col + 1, 0 })
  end
end

function M.post_operatorfunc(old_func)
  vim.go.operatorfunc = old_func
  _G.op_func_change_all_operator = nil
end

function M.operatorfunc_scaffold(name, lines, operatorfunc)
  local old_func = vim.go.operatorfunc

  _G[name] = function()
    M.operatorfunc_helper_select(lines)

    operatorfunc()

    M.post_operatorfunc(old_func)
  end

  vim.go.operatorfunc = "v:lua." .. name
  vim.api.nvim_feedkeys("g@", "n", false)
end

function M.operatorfunc_scaffoldV_keys(name, verbkeys)
  M.operatorfunc_scaffold(name, true, function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(verbkeys, true, true, true), "m", false)
  end)
end

function M.operatorfunc_scaffold_keys(name, verbkeys)
  M.operatorfunc_scaffold(name, false, function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(verbkeys, true, true, true), "m", false)
  end)
end

return M
