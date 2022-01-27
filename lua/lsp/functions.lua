local M = {}
local api = vim.api
local cmd = vim.cmd
local vfn = vim.fn
local lsp = vim.lsp
-- local diags = lsp.diagnostic
local diags = vim.diagnostic
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
function M.echo_diagnostic()
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
function M.simple_echo_diagnostic()
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
local termcodes = vim.api.nvim_replace_termcodes
local function t(k)
  return termcodes(k, true, true, true)
end
-- Format a range using LSP
function M.format_range_operator()
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
function M.range_diagnostics(opts, buf_nr, start, finish)
  start = start or getmark(0, "[")
  finish = finish or getmark(0, "]")

  opts = opts or {}
  opts.focus_id = "position_diagnostics"
  buf_nr = buf_nr or 0
  local function match_position_predicate(diag)
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
local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  lsp.util.preview_location(result[1], {
    border = O.lsp.border,
  })
end

function M.preview_location_at(name)
  local params = lsp.util.make_position_params()
  return lsp.buf_request(0, "textDocument/" .. name, params, preview_location_callback)
end

function M.view_location_split_callback(split_cmd)
  local util = vim.lsp.util
  local log = require "vim.lsp.log"
  local api = vim.api

  -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
  local function handler(_, result, ctx)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end

    if split_cmd then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command "copen"
        api.nvim_command "wincmd p"
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end

function M.view_location_split(name, split_cmd)
  local cb = M.view_location_split_callback(split_cmd)
  return function()
    local params = lsp.util.make_position_params()
    return lsp.buf_request(0, "textDocument/" .. name, params, cb)
  end
end

function M.toggle_diagnostics()
  vim.b.lsp_diagnostics_hide = not vim.b.lsp_diagnostics_hide
  if vim.b.lsp_diagnostics_hide then
    diags.enable()
  else
    diags.disable()
  end
end

-- TODO: Implement codeLens handlers
function M.show_codelens()
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

-- Jump between diagnostics
-- TODO: clean up and remove the deprecate functions
local popup_diagnostics_opts = {
  header = false,
  border = O.lsp.border,
}
function M.diag_line()
  diags.open_float(0, vim.tbl_deep_extend("keep", { scope = "line" }, popup_diagnostics_opts))
end
function M.diag_cursor()
  diags.open_float(0, vim.tbl_deep_extend("keep", { scope = "cursor" }, popup_diagnostics_opts))
end
function M.diag_buffer()
  diags.open_float(0, vim.tbl_deep_extend("keep", { scope = "buffer" }, popup_diagnostics_opts))
end
function M.diag_next()
  diags.goto_next { enable_popup = true, float = popup_diagnostics_opts }
end
function M.diag_prev()
  diags.goto_prev { enable_popup = true, float = popup_diagnostics_opts }
end

function M.common_on_attach(client, bufnr)
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
          autocmd InsertLeave,BufWritePost <buffer> lua vim.lsp.codelens.refresh()
          autocmd CursorHold <buffer> lua vim.lsp.codelens.refresh()
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
M.rename = (function()
  local function handler(...)
    local result
    local method
    local err = select(1, ...)
    local is_new = not select(4, ...) or type(select(4, ...)) ~= "number"
    if is_new then
      method = select(3, ...).method
      result = select(2, ...)
    else
      method = select(2, ...)
      result = select(3, ...)
    end

    if O.lsp.rename_notification then
      if err then
        vim.notify(("Error running LSP query '%s': %s"):format(method, err), vim.log.levels.ERROR)
        return
      end

      -- echo the resulting changes
      local new_word = ""
      if result and result.changes then
        local msg = {}
        for f, c in pairs(result.changes) do
          new_word = c[1].newText
          table.insert(msg, ("%d changes -> %s"):format(#c, utils.get_relative_path(f)))
        end
        local currName = vim.fn.expand "<cword>"
        vim.notify(msg, vim.log.levels.INFO, { title = ("Rename: %s -> %s"):format(currName, new_word) })
      end
    end

    vim.lsp.handlers[method](...)
  end

  local function do_rename()
    local new_name = vim.trim(vim.fn.getline("."):sub(5, -1))
    vim.cmd [[q!]]
    local params = lsp.util.make_position_params()
    local curr_name = vim.fn.expand "<cword>"
    if not (new_name and #new_name > 0) or new_name == curr_name then
      return
    end
    params.newName = new_name
    lsp.buf_request(0, "textDocument/rename", params, handler)
  end

  return function()
    require("lv-ui/input").inline_text_input {
      border = O.lsp.rename_border,
      -- enter = do_rename,
      enter = vim.lsp.buf.rename,
      startup = function()
        feedkeys(t "viw<C-G>", "n", false)
      end,
      init_cword = true,
      at_begin = true, -- FIXME: What happened to this?
      minwidth = true,
    }
  end
end)()

M.renamer = (function()
  local function mk_keymaps(old)
    local enter = "<cmd>lua require'lsp.functions'.renamer.enter_cb('"
      .. old
      .. "', vim.api.nvim_win_get_cursor(0))<cr>"
    local cancel = "<cmd>lua require'lsp.functions'.renamer.cancel_cb('" .. old .. "')<cr>"
    vim.keymap.setl("i", "<CR>", enter, { silent = true })
    vim.keymap.setl("i", "<M-CR>", enter, { silent = true })
    vim.keymap.setl("i", "<ESC><ESC>", cancel, { silent = true })
  end
  local function del_keymaps()
    vim.keymap.del("i", "<CR>")
    vim.keymap.del("i", "<ESC><ESC>")
  end
  return {
    enter_cb = function(old, oldpos)
      -- local cword = vim.fn.expand "<cword>"
      -- utils.dump(cword)
      vim.cmd "stopinsert"
      vim.defer_fn(function()
        -- vim.api.nvim_win_set_cursor(0, oldpos)
        local cword = vim.fn.expand "<cword>"
        utils.dump(cword)
        feedkeys(t("ciw" .. old .. "<ESC>"), "n", false)

        del_keymaps()

        vim.lsp.buf.rename(cword)
      end, 1)
    end,
    cancel_cb = function(old)
      vim.cmd "stopinsert"
      -- feedkeys(t "u", "n", false)
      feedkeys(t("ciw" .. old .. "<ESC>"), "n", false)
      del_keymaps()
    end,
    keymap = function()
      local old = vim.fn.expand "<cword>"
      feedkeys(t "viw<C-G>", "n", false) -- Go select mode
      mk_keymaps(old)
    end,
  }
end)()
-- M.rename = M.renamer.keymap

M.format_on_save = function(disable)
  local augroup = {
    {
      "BufWritePre",
      "*",
      "lua vim.lsp.buf.formatting_seq_sync(nil, " .. O.format_on_save_timeout .. ")",
    },
  }
  if disable then
    augroup = {}
  end
  require("lv-utils").define_augroups {
    autoformat = augroup,
  }
end

vim.lsp.buf.cancel_formatting = function(bufnr)
  vim.schedule(function()
    bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
    for _, client in ipairs(vim.lsp.buf_get_clients(bufnr)) do
      for id, request in pairs(client.requests or {}) do
        if request.type == "pending" and request.bufnr == bufnr and request.method == "textDocument/formatting" then
          client.cancel_request(id)
        end
      end
    end
  end)
end

return M
