local M = {}

function M.config()
  vim.cmd [[ autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * silent! TroubleRefresh ]]

  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    position = "right",
    auto_preview = false,
    hover = "h",
  }

  local trouble = require "trouble.providers.telescope"

  local telescope = require "telescope"

  telescope.setup {
    defaults = {
      mappings = {
        i = { ["<c-t>"] = trouble.open_with_trouble },
        n = { ["<c-t>"] = trouble.open_with_trouble },
      },
    },
  }
end

return M
