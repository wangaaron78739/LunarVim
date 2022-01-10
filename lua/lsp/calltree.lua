local M = {}
function M.config()
  require("litee.lib").setup {}
  require("litee.calltree").setup {
    layout = "right",
    icons = "nerd",
  }

  utils.define_augroups {
    _calltree_callview = {
      { "FileType", "Calltree", "lua require'lsp.calltree'.ftplugin()" },
    },
  }
end

local down = "▼"
local right = "▶"
function M.ftplugin()
  local map = vim.keymap.setl
  local opts = { silent = true }
  map("n", "<CR>", "<cmd>CTJump<CR>", opts)
  map("n", "gh", "<cmd>CTHover<CR>", opts)
  map("n", "<Left>", "<cmd>CTCollapse<cr>", opts)
  map("n", "<Tab>", "<cmd>CTExpand<cr>", opts)
  map("n", "<Right>", "<cmd>CTExpand<cr>", opts)
  map("n", "j", "j^", opts)
  map("n", "k", "k^", opts)
  map("n", "h", "<cmd>CTCollapse<cr>", opts)
  map("n", "l", "<cmd>CTExpand<cr>", opts)
  mappings.localleader {
    ["s"] = { "<cmd>CTSwitch<CR>", "Invert Calltree" },
    ["f"] = { "<cmd>CTFocus<CR>", "Focus this Node" },
  }
end

return M
