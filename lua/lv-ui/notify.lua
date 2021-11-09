local M = {}
M.config = function()
  local notify = require "notify"
  notify.setup(O.notify)
  vim.notify = notify
end
return M
