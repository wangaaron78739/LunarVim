local M = {}

-- Location information about the last message printed. The format is
-- `(did print, buffer number, line number)`.
local last_echo = { false, -1, -1 }
-- The timer used for displaying a diagnostic in the commandline.
local echo_timer = nil
-- The timer after which to display a diagnostic in the commandline.
local echo_timeout = 30
-- The highlight group to use for warning messages.
local warning_hlgroup = "WarningMsg"
-- The highlight group to use for error messages.
local error_hlgroup = "ErrorMsg"
-- If the first diagnostic line has fewer than this many characters, also add
-- the second line to it.
local short_line_limit = 20

-- Prints the first diagnostic for the current line.
-- Bind to CursorMoved to update live: vim.cmd [[autocmd CursorMoved * :lua require("lsp.functions").echo_diagnostic()]]
M.echo_diagnostic = function()
  if echo_timer then
    echo_timer:stop()
  end

  echo_timer = vim.defer_fn(function()
    local line = vim.fn.line "." - 1
    local bufnr = vim.api.nvim_win_get_buf(0)

    if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
      return
    end

    local diags = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line, { severity_limit = "Warning" })

    if #diags == 0 then
      -- If we previously echo'd a message, clear it out by echoing an empty
      -- message.
      if last_echo[1] then
        last_echo = { false, -1, -1 }

        vim.api.nvim_command 'echo ""'
      end

      return
    end

    last_echo = { true, bufnr, line }

    local diag = diags[1]
    local width = vim.api.nvim_get_option "columns" - 15
    local lines = vim.split(diag.message, "\n")
    local message = lines[1]
    local trimmed = false

    if #lines > 1 and #message <= short_line_limit then
      message = message .. " " .. lines[2]
    end

    if width > 0 and #message >= width then
      message = message:sub(1, width) .. "..."
    end

    local kind = "warning"
    local hlgroup = warning_hlgroup

    if diag.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
      kind = "error"
      hlgroup = error_hlgroup
    end

    local chunks = {
      { kind .. ": ", hlgroup },
      { message },
    }

    vim.api.nvim_echo(chunks, false, {})
  end, echo_timeout)
end

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
