local M = {}

function M.change_all_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_change_all_operator = function()
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "["))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, "]"))

    vim.fn.setpos(".", { 0, start_row, start_col + 1, 0 })
    vim.cmd "normal! v"
    if end_col == 1 then
      vim.fn.setpos(".", { 0, end_row - 1, -1, 0 })
    else
      vim.fn.setpos(".", { 0, end_row, end_col + 1, 0 })
    end

    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes([["ay:%s/<C-r>a//g<Left><Left>]], true, true, true),
      "n",
      false
    ) -- Exit visual mode

    vim.go.operatorfunc = old_func
    _G.op_func_change_all_operator = nil
  end
  vim.go.operatorfunc = "v:lua.op_func_change_all_operator"
  vim.api.nvim_feedkeys("g@", "n", false)
end

return M
