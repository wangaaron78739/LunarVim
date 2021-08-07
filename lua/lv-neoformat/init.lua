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
end

M.format_range_operator = function()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "["))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, "]"))

    vim.fn.setpos(".", { 0, start_row, start_col + 1, 0 })
    vim.cmd "normal! v"
    -- Convert exclusive end position to inclusive
    if end_col == 1 then
      vim.fn.setpos(".", { 0, end_row - 1, -1, 0 })
    else
      vim.fn.setpos(".", { 0, end_row, end_col + 1, 0 })
    end

    vim.cmd "Neoformat"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", false) -- Exit visual mode

    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_formatting"
  vim.api.nvim_feedkeys("g@", "n", false)
end

return M
