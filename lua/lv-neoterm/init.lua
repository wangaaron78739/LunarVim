local M = {}
local remap = vim.api.nvim_set_keymap

function M.config()
  vim.g.neoterm_default_mod = "vertical"
  vim.g.neoterm_autoinsert = 1
  vim.g.neoterm_autoscroll = 1
  vim.g.neoterm_bracketed_paste = 1
  vim.g.neoterm_repl_python = { "ipython" }
  vim.g.neoterm_repl_lua = { "croissant" }
  --vim.g.neoterm_repl_python = "['conda activate venv', 'clear', 'ipython']"

  remap("n", "<M-x>", "<Plug>(neoterm-repl-send)", { silent = true })
  remap("n", "<M-x><M-x>", "<Plug>(neoterm-repl-send-line)", { silent = true })
  remap("x", "<M-x>", "<Plug>(neoterm-repl-send)", { silent = true })
  -- remap("n", "gt","<Plug>(neoterm-repl-send)", { silent = true })
  -- remap("v", "gt","<Plug>(neoterm-repl-send-line)", { silent = true })
  -- remap("n", "gtt","<Plug>(neoterm-repl-send)", { silent = true })
end

function M.Tmem(cmd)
  vim.cmd("Tmap " .. cmd)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.g.neoterm_automap_keys, true, true, true), "m", false)
end

function M.keymaps()
  vim.cmd [[ command -nargs=+ Tmem :lua require("lv-neoterm").Tmem("<args>") ]]

  vim.g.neoterm_automap_keys = "<leader>te"
  -- Use gt to send to terminal
  remap("n", "<M-t>", ":T ", {})
  remap("n", "<M-S-t>", ":Tmem ", {})
end

return M
