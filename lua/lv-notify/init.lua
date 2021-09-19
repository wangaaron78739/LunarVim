local M = {}
local notify = require "notify"
local color = {
  DEBUG = "NotifyDEBUGTitle",
  TRACE = "NotifyTRACETitle",
  INFO = "NotifyINFOTitle",
  WARN = "NotifyWARNTitle",
  ERROR = "NotifyERRORTitle",
}
M.print_history = function()
  local echo = vim.api.nvim_echo
  local strftime = vim.fn.strftime
  local concat = table.concat
  for _, m in ipairs(notify.history()) do
    echo({
      { strftime("%FT%T", m.time), "Identifier" },
      { " ", "Normal" },
      { m.level, color[m.level] or "Title" },
      { " ", "Normal" },
      { concat(m.message, " "), "Normal" },
    }, false, {})
  end
end
M.config = function()
  vim.cmd [[command! Message :lua require'lv-notify'.print_history()<CR>]]
  vim.cmd [[command! Mess :lua require'lv-notify'.print_history()<CR>]]
  notify.setup(O.notify)

  -- vim.notify = notify
  if not vim.g.neovide then -- TODO: neovide can't animate
    vim.notify = notify
  end
end
return M
