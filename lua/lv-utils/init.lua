local M = {}

function M.reload_lv_config()
  -- FIXME: breaks things
  vim.cmd "source ~/.config/nvim/lv-config.lua"
  vim.cmd "source ~/.config/nvim/lua/plugins.lua"
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
function M.define_aucmd(name, aucmd)
  M.define_augroups { [name] = { aucmd } }
end

function M.quickfix_toggle()
  vim.cmd [[
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
]]
end
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

-- the font used in graphical neovim applications
function M.set_guifont(size)
  vim.opt.guifont = "FiraCode Nerd Font:h" .. size
  vim.g.guifontsize = size
end
function M.mod_guifont(diff)
  local size = vim.g.guifontsize
  M.set_guifont(size + diff)
end
vim.cmd [[
  command! FontUp lua require("lv-utils").mod_guifont(1)
  command! FontDown lua require("lv-utils").mod_guifont(-1)
]]

return M
