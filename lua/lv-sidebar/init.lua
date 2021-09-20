local M = {}
M.config = function()
  local sidebar = require "sidebar-nvim"
  sidebar.setup {
    open = false,
    sections = {
      "datetime",
      "git-status",
      "lsp-diagnostics",
      "todos",
    },
  }
end
return M
