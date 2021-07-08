local M = {}

-- Format a range using LSP
M.format_range_operator = function()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, "[")
    local finish = vim.api.nvim_buf_get_mark(0, "]")
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  vim.api.nvim_feedkeys("g@", "n", false)
end

-- Preview definitions and things
local function preview_location_callback(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1], {
    border = O.lsp.border,
  })
end

M.preview_location_at = function(name)
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/" .. name, params, preview_location_callback)
end

local diagnostics_show
M.toggle_diagnostics = function()
  diagnostics_show = not diagnostics_show

  local diagstyle = {
    virtual_text = false,
    signs = false,
    underline = false,
  }
  if diagnostics_show then
    -- TODO: How to preserve old diagnostics settings?
    vim.b.old_diagnostics = O.lsp.diagnostics
  else
    diagstyle = vim.b.old_diagnostics
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    diagstyle
  )

  -- Refresh diagnostics
  local clients = vim.lsp.buf_get_clients(0)
  for k, v in pairs(clients) do
    vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, k), 0, k, diagstyle)
  end
end

-- FIXME: figure this stuff out?
M.show_codelens = function()
  vim.cmd [[ autocmd BufEnter,CursorHold,InsertLeave * lua vim.lsp.codelens.refresh() ]]
  local clients = vim.lsp.buf_get_clients(0)
  for k, v in pairs(clients) do
    vim.lsp.codelens.display(vim.lsp.codelens.get(0, k), 0, k, O.lsp.codeLens)
  end
end
M.run_codelens = function()
  vim.lsp.codelens.run()
end

-- TODO: what is this?
-- vim.cmd 'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()'

return M
