local M = {}
local api = vim.api
local cmd = vim.cmd
local vfn = vim.fn
local lsp = vim.lsp
local diags = lsp.diagnostic
-- TODO: reduce nested lookups for performance (\w+\.)?(\w+\.)?\w+\.\w+\(

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
-- Bind to CursorMoved to update live: cmd [[autocmd CursorMoved * :lua require("lsp.functions").echo_diagnostic()]]
M.echo_diagnostic = function()
  if echo_timer then
    echo_timer:stop()
  end

  echo_timer = vim.defer_fn(function()
    local line = vfn.line "." - 1
    local bufnr = api.nvim_win_get_buf(0)

    if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
      return
    end

    local ldiags = diags.get_line_diagnostics(bufnr, line, { severity_limit = "Warning" })

    if #ldiags == 0 then
      -- If we previously echo'd a message, clear it out by echoing an empty
      -- message.
      if last_echo[1] then
        last_echo = { false, -1, -1 }

        vim.cmd 'echo ""'
      end

      return
    end

    last_echo = { true, bufnr, line }

    local diag = ldiags[1]
    local width = api.nvim_get_option "columns" - 15
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

    if diag.severity == lsp.protocol.DiagnosticSeverity.Error then
      kind = "error"
      hlgroup = error_hlgroup
    end

    local chunks = {
      { kind .. ": ", hlgroup },
      { message },
    }

    api.nvim_echo(chunks, false, {})
  end, echo_timeout)
end
M.simple_echo_diagnostic = function()
  local line_diagnostics = diags.get_line_diagnostics()
  if vim.tbl_isempty(line_diagnostics) then
    cmd [[echo ""]]
    return
  end
  for _, diagnostic in ipairs(line_diagnostics) do
    cmd("echo '" .. diagnostic.message .. "'")
  end
end

local getmark = api.nvim_buf_get_mark
local range_formatting = lsp.buf.range_formatting
local feedkeys = api.nvim_feedkeys
-- Format a range using LSP
M.format_range_operator = function()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = getmark(0, "[")
    local finish = getmark(0, "]")
    range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  feedkeys("g@", "n", false)
end

-- TODO: Wait for diags.show_diagnostics to be public
local lsputil = require "vim.lsp.util"
local if_nil = vim.F.if_nil
M.range_diagnostics = function(opts, buf_nr, start, finish)
  start = start or getmark(0, "[")
  finish = finish or getmark(0, "]")

  opts = opts or {}
  opts.focus_id = "position_diagnostics"
  buf_nr = buf_nr or api.nvim_get_current_buf()
  local match_position_predicate = function(diag)
    -- FIXME: this is wrong sometimes?
    if finish[1] < diag.range["start"].line then
      return false
    else
      return start[1] <= diag.range["end"].line
    end
    return ((finish[1] >= diag.range["start"].line) and (start[1] <= diag.range["end"].line))
  end
  local diagnostics = diags.get(buf_nr, nil, match_position_predicate)
  -- if opts.severity then
  --   range_diagnostics = filter_to_severity_limit(opts.severity, range_diagnostics)
  -- elseif opts.severity_limit then
  --   range_diagnostics = filter_by_severity_limit(opts.severity_limit, range_diagnostics)
  -- end
  table.sort(diagnostics, function(a, b)
    return a.severity < b.severity
  end)

  -- diags.show_diagnostics
  -- return diags.show_diagnostics(opts, range_diagnostics)
  if vim.tbl_isempty(diagnostics) then
    return
  end
  local lines = {}
  local highlights = {}
  local show_header = if_nil(opts.show_header, true)
  local ins = table.insert
  if show_header then
    ins(lines, "Diagnostics:")
    ins(highlights, { 0, "Bold" })
  end

  for i, diagnostic in ipairs(diagnostics) do
    local prefix = string.format("%d. ", i)
    local hiname = diags._get_floating_severity_highlight_name(diagnostic.severity)
    assert(hiname, "unknown severity: " .. tostring(diagnostic.severity))

    local message_lines = vim.split(diagnostic.message, "\n", true)
    ins(lines, prefix .. message_lines[1])
    ins(highlights, { #prefix, hiname })
    for j = 2, #message_lines do
      ins(lines, string.rep(" ", #prefix) .. message_lines[j])
      ins(highlights, { 0, hiname })
    end
  end

  local popup_bufnr, winnr = lsputil.open_floating_preview(lines, "plaintext", opts)
  for i, hi in ipairs(highlights) do
    local prefixlen, hiname = unpack(hi)
    -- Start highlight after the prefix
    api.nvim_buf_add_highlight(popup_bufnr, -1, hiname, i - 1, prefixlen, -1)
  end

  return popup_bufnr, winnr
end

-- Preview definitions and things
local function preview_location_callback(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  lsp.util.preview_location(result[1], {
    border = O.lsp.border,
  })
end

M.preview_location_at = function(name)
  local params = lsp.util.make_position_params()
  return lsp.buf_request(0, "textDocument/" .. name, params, preview_location_callback)
end

M.toggle_diagnostics = function()
  vim.b.lsp_diagnostics_hide = not vim.b.lsp_diagnostics_hide
  if vim.b.lsp_diagnostics_hide then
    diags.enable()
  else
    diags.disable()
  end
end

-- TODO: Implement codeLens handlers
M.show_codelens = function()
  -- cmd [[ autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh() ]]
  -- cmd(
  --   [[
  --   augroup lsp_codelens_refresh
  --     autocmd! * <buffer>
  --     autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
  --   augroup END
  --   ]],
  --   false
  -- )

  local clients = lsp.buf_get_clients(0)
  local codelens = lsp.codelens
  for k, v in pairs(clients) do
    codelens.display(codelens.get(0, k), 0, k, O.lsp.codeLens)
    -- lsp.codelens.display(nil, 0, k, O.lsp.codeLens)
  end
end

-- TODO: what is this?
-- cmd 'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()'

-- Jump between diagnostics
local popup_diagnostics_opts = {
  show_header = false,
  border = O.lsp.border,
}
M.diag_line = function()
  diags.show_line_diagnostics(popup_diagnostics_opts)
end
M.diag_cursor = function()
  diags.show_cursor_diagnostics(popup_diagnostics_opts)
end
M.diag_next = function()
  diags.goto_next { popup_opts = popup_diagnostics_opts }
end
M.diag_prev = function()
  diags.goto_prev { popup_opts = popup_diagnostics_opts }
end

M.common_on_attach = function(client, bufnr)
  local lsp_status = require "lsp-status"
  lsp_status.on_attach(client)

  -- Handle document highlighting
  if O.lsp.document_highlight then
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
      cmd(
        [[
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

  if O.lsp.live_codelens then
    if client.resolved_capabilities.code_lens then
      cmd(
        [[
        augroup lsp_codelens_refresh
          autocmd! * <buffer>
          autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
        augroup END
        ]],
        false
      )
    end
  end

  if O.lsp.autoecho_line_diagnostics then
    -- if client.resolved_capabilities.document_highlight then
    -- autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help()
    cmd(
      [[ augroup lsp_au
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua require("lsp.functions").echo_diagnostic()
      augroup END ]],
      false
    )
    -- end
  end
end

-- Helper for better renaming interface
M.rename = function()
  require("lv-utils").inline_text_input {
    border = O.lsp.rename_border,
    enter = lsp.buf.rename,
    init_cword = true,
    at_begin = true,
    minwidth = true,
  }
end

return M
