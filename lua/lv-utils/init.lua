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

function M.command(name, fn)
  vim.cmd("command! " .. name .. " " .. fn)
end

_G.lv_utils_functions = {}
local to_cmd_counter = 0
function M.to_cmd(luafunction, opts)
  if opts == nil then
    opts = ""
  end
  local name = "fn" .. to_cmd_counter
  to_cmd_counter = to_cmd_counter + 1
  _G.lv_utils_functions[name] = luafunction
  return "<cmd>call v:lua.lv_utils_functions." .. name .. "(" .. opts .. ")<cr>"
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

_G.lv_utils_operatorfuncs = {}
-- wrapper for making operators easily
function M.operatorfunc_scaffold(name, lines, operatorfunc)
  local old_func = vim.go.operatorfunc

  _G.lv_utils_operatorfuncs[name] = function()
    M.operatorfunc_helper_select(lines)

    operatorfunc()

    M.post_operatorfunc(old_func)
  end

  return M.to_cmd(function()
    vim.go.operatorfunc = "v:lua.lv_utils_operatorfuncs." .. name
    vim.api.nvim_feedkeys("g@", "n", false)
  end)
end

-- keys linewise
function M.operatorfuncV_keys(name, verbkeys)
  return M.operatorfunc_scaffold(name, true, function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(verbkeys, true, true, true), "m", false)
  end)
end

-- charwise linewise
function M.operatorfunc_keys(name, verbkeys)
  return M.operatorfunc_scaffold(name, false, function()
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
