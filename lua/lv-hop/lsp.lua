local M = {}
local hop = require "hop"
local get_window_context = require("hop.window").get_window_context
local hint_with = hop.hint_with
local get_command_opts = hop.get_command_opts
local teutils = require "telescope.utils"

local function lsp_filter_window(node, context, nodes_set)
  local line = node.lnum - 1
  local col = node.col
  if line <= context.bot_line and line >= context.top_line then
    nodes_set[line .. col] = {
      line = line,
      col = col + 1,
    }
  end
end

local lsp_diagnostics = {
  get_hint_list = function(_, hint_opts)
    local context = get_window_context(hint_opts)
    local diags = teutils.diagnostics_to_tbl()
    local out = {}
    for _, diag in ipairs(diags) do
      lsp_filter_window(diag, context, out)
    end
    return vim.tbl_values(out)
  end,
}

local lsp_symbols = {
  get_hint_list = function(_, hint_opts)
    local context = get_window_context(hint_opts)
    local telescope_opts = {}
    local params = vim.lsp.util.make_position_params()
    local results_lsp, err = vim.lsp.buf_request_sync(
      0,
      "textDocument/documentSymbol",
      params,
      telescope_opts.timeout or 10000
    )
    if err then
      vim.api.nvim_err_writeln("Error when finding document symbols: " .. err)
      return
    end

    if not results_lsp or vim.tbl_isempty(results_lsp) then
      print "No results from textDocument/documentSymbol"
      return
    end

    local locations = {}
    for _, server_results in pairs(results_lsp) do
      vim.list_extend(locations, vim.lsp.util.symbols_to_items(server_results.result, 0) or {})
    end

    locations = teutils.filter_symbols(locations, telescope_opts)
    if locations == nil then
      -- error message already printed in `utils.filter_symbols`
      return
    end

    if vim.tbl_isempty(locations) then
      return
    end

    local out = {}
    for _, loc in ipairs(locations) do
      lsp_filter_window(loc, context, out)
    end
    return vim.tbl_values(out)
  end,
}

-- TODO: references, definitions, etc (everything in https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/lsp.lua)

M.hop_diagnostics = function(opts)
  hint_with(lsp_diagnostics, get_command_opts(opts))
end
M.hop_symbols = function(opts)
  hint_with(lsp_symbols, get_command_opts(opts))
end

return M
