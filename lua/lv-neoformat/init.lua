local M = {}

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

  --[[ -- Enable alignment
  vim.g.neoformat_basic_format_align = 1
  -- Enable tab to spaces conversion
  vim.g.neoformat_basic_format_retab = 1
  -- Enable trimmming of trailing whitespace
  vim.g.neoformat_basic_format_trim = 1 ]]

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

  vim.api.nvim_set_keymap("n", "gm", [[<cmd>lua require("lv-neoformat").format_range_operator()<CR>]], nore)
  vim.api.nvim_set_keymap("n", "=", [[<cmd>lua require("lv-neoformat").format_range_operator()<CR>]], nore)
end

M.format_range_operator = function()
  require("lv-utils").operatorfunc_scaffold("format_range_operatorfunc", true, function()
    vim.cmd "Neoformat"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", false) -- Exit visual mode
  end)
end

return M
