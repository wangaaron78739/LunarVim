local M = {}
function M.dap()
  local dap = require "dap"
  vim.fn.sign_define("DapBreakpoint", O.breakpoint_sign)
  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
end
function M.dapui()
  require("dapui").setup {}
end
return M
