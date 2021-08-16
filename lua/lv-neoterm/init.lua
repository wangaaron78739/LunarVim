local M = {}

function M.config()
  vim.g.neoterm_default_mod = "vertical"
  vim.g.neoterm_autoinsert = 1
  vim.g.neoterm_autoscroll = 1
  vim.g.neoterm_bracketed_paste = 1
  vim.g.neoterm_repl_python = { "ipython" }
  vim.g.neoterm_repl_lua = { "croissant" }
  --vim.g.neoterm_repl_python = "['conda activate venv', 'clear', 'ipython']"
end

function M.Tmem(cmd)
  vim.cmd("Tmap " .. cmd)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.g.neoterm_automap_keys, true, true, true), "m", false)
end

function M.trepl_send_operator()
  require("lv-utils").operatorfunc_scaffold_keys("paste_over_operatorfunc", "p")
end

function M.keymaps()
  vim.cmd [[ command -nargs=+ Tmem :lua require("lv-neoterm").Tmem("<args>") ]]

  local remap = vim.api.nvim_set_keymap
  vim.g.neoterm_automap_keys = "<leader>te"
  -- remap("n", "gt", "<cmd>lua require('lv-neoterm').trepl_send_operator()<cr>", sile)
  -- remap("v", "gt", ":<C-u>TREPLSendSelection<CR>", { silent = true })
  -- remap("n", "gtt", "<cmd>TREPLSendLine<CR>", { silent = true })
  -- Use gt to send to terminal
  remap("n", "gt", "<Plug>(neoterm-repl-send)", {})
  remap("n", "gtt", "<Plug>(neoterm-repl-send-line)", {})
  remap("x", "gt", "<Plug>(neoterm-repl-send)", {})
  remap("n", "<M-t>", ":T ", {})
  remap("n", "<M-S-t>", ":Tmem ", {})
end

return M
