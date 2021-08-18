local M = {}

if not O.plugin.neoformat.active then
  return M
end

M.config = function()
  vim.g.neoformat_run_all_formatters = 0

  -- vim.g.neoformat_python_autopep8 = {
  --   ["exe"] = "julia",
  --   ["args"] = { "-e", [[using JuliaFormatter
  --   ]] },
  --   ["replace"] = 1, -- replace the file, instead of updating buffer (default: 0),
  --   ["valid_exit_codes"] = { 0, 23 },
  -- }

  vim.g.neoformat_enabled_python = { "black", "autopep8", "yapf", "docformatter" }
  vim.g.neoformat_enabled_javascript = { "prettier" }
  vim.g.neoformat_enabled_lua = { "stylua", "luaformat" }

  -- -- Enable alignment
  -- vim.g.neoformat_basic_format_align = 1
  -- -- Enable tab to spaces conversion
  -- vim.g.neoformat_basic_format_retab = 1
  -- -- Enable trimmming of trailing whitespace
  -- vim.g.neoformat_basic_format_trim = 1

  -- autoformat
  if O.format_on_save then
    require("lv-utils").define_augroups {
      autoformat = {
        {
          "BufWritePre",
          "*",
          -- FIXME: cannot undojoin after undo
          -- [[undojoin | Neoformat]],
          -- [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]],
          [[Neoformat]],
        },
      },
    }
  end
end

M.keymaps = function()
  local format_range_operator = require("lv-utils").operatorfunc_scaffold("format_range", true, function()
    vim.cmd "Neoformat"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", false) -- Exit visual mode
  end)

  noremap("n", "gq", format_range_operator)
  -- noremap("n", "=", format_range_operator)
  noremap("v", "gq", "<cmd>Neoformat<cr>")
  -- noremap("v", "=", require("lv-utils").operatorfunc_keys "<cmd>Neoformat<cr>")
  noremap("n", "gf", "<cmd>Neoformat<cr>")
  -- noremap("n", "==", "<cmd>Neoformat<cr>")
end

return M
