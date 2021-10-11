local M = {}
M.dap = function()
  local dap = require "dap"
  vim.fn.sign_define("DapBreakpoint", O.breakpoint_sign)
  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
end
M.dapui = function()
  require("dapui").setup {}
end
return M
