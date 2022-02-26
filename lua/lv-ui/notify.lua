local M = {}
function M.config()
  local notify = require "notify"
  notify.setup(O.notify)
  vim.notify = notify
end
return M
