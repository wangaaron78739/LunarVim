local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end
-- require "dap"
vim.fn.sign_define("DapBreakpoint", O.breakpoint_sign)
dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
