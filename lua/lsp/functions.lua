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
    local lineindex = 2

    if width == 0 then
      if #lines > 1 and #message <= short_line_limit then
        message = message .. " " .. lines[lineindex]
      end
    else
      while #message < width do
        message = message .. " " .. lines[lineindex]
        lineindex = lineindex + 1
      end
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
M.simple_echo_diagnostic = function()
  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
  if vim.tbl_isempty(line_diagnostics) then
    vim.cmd [[echo ""]]
    return
  end
  for i, diagnostic in ipairs(line_diagnostics) do
    vim.cmd("echo '" .. diagnostic.message .. "'")
  end
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

-- TODO: Implement codeLens handlers
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

-- Jump between diagnostics
local line_diagnostics_opts = {
  show_header = false,
  border = O.lsp.border,
}
M.diag_line = function()
  vim.lsp.diagnostic.show_line_diagnostics(line_diagnostics_opts)
end
M.diag_next = function()
  vim.lsp.diagnostic.goto_next { popup_opts = line_diagnostics_opts }
end
M.diag_prev = function()
  vim.lsp.diagnostic.goto_prev { popup_opts = line_diagnostics_opts }
end

M.common_on_attach = function(client, bufnr)
  -- Handle document highlighting
  if O.document_highlight then
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec(
        [[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
        hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]],
        false
      )
    end
  end

  if O.autoecho_line_diagnostics then
    -- if client.resolved_capabilities.document_highlight then
    -- autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()
    vim.api.nvim_exec(
      [[ augroup lsp_au
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua require("lsp.functions").echo_diagnostic()
      augroup END ]],
      false
    )
    -- end
  end
end

local calc_rename_window_size = function()
  local cword = vim.fn.expand "<cword>"
  if #cword == 0 then
    local cline = vim.fn.getline "."
    return #cline + 2
  else
    return #cword + 1 -- + vim.o.sidescrolloff
  end
end
M.rename_window_size = function(win)
  local wid = calc_rename_window_size()
  if wid > 1 then
    vim.api.nvim_win_set_width(win, wid)
  end
end
-- Helper for better renaming interface
M.rename = function()
  vim.cmd [[normal! wb]]
  local width = calc_rename_window_size()
  local cword = vim.fn.expand "<cword>"
  local opts = {
    relative = "cursor",
    row = 0,
    col = 0,
    width = width,
    height = 1,
    style = "minimal",
    -- border = O.lsp.border,
    border = "none",
    -- noautocmd = false
  }
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  local dorename = string.format("<cmd>lua require('lsp.functions').dorename(%d, %d)<CR>", win, buf)
  local dontrename = string.format("<cmd>lua require('lsp.functions').close_rename(%d, %d)<CR>", win, buf)
  vim.cmd(string.format([[autocmd InsertCharPre <buffer> lua require("lsp.functions").rename_window_size(%d)]], win))
  vim.cmd(string.format([[autocmd InsertLeave <buffer> lua require("lsp.functions").rename_window_size(%d)]], win))
  vim.opt_local.sidescrolloff = 0
  vim.b.width = width

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
  vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", dorename, { silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", dontrename, { silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "o", "<nop>", { silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "O", "<nop>", { silent = true })
end
M.close_rename = function(win, buf)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", false)
  vim.api.nvim_win_close(win, true)
  vim.api.nvim_buf_delete(buf, { force = true })
end
M.dorename = function(win, buf)
  local new_name = vim.trim(vim.fn.getline ".")
  M.close_rename(win, buf)
  vim.lsp.buf.rename(new_name)
end

return M
