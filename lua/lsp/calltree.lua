local M = {}
function M.config()
  require("calltree").setup {
    layout = "right",
    icons = "nerd",
  }

  utils.define_augroups {
    _calltree_callview = {
      { "FileType", "Calltree", "lua require'lsp.calltree'.keymaps()" },
    },
  }
end

local down = "▼"
local right = "▶"
function M.keymaps()
  local map = vim.api.nvim_buf_set_keymap
  local opts = { silent = true, noremap = true }
  map(0, "n", "<CR>", "<cmd>CTJump<CR>", opts)
  map(0, "n", "gh", "<cmd>CTHover<CR>", opts)
  map(0, "n", "<Left>", "<cmd>CTCollapse<cr>", opts)
  map(0, "n", "<Tab>", "<cmd>CTExpand<cr>", opts)
  map(0, "n", "<Right>", "<cmd>CTExpand<cr>", opts)
  map(0, "n", "j", "j^", opts)
  map(0, "n", "k", "k^", opts)
  map(0, "n", "h", "<cmd>CTCollapse<cr>", opts)
  map(0, "n", "l", "<cmd>CTExpand<cr>", opts)
  mappings.localleader {
    ["s"] = { "<cmd>CTSwitch<CR>", "Invert Calltree" },
    ["f"] = { "<cmd>CTFocus<CR>", "Focus this Node" },
  }
end

return M
