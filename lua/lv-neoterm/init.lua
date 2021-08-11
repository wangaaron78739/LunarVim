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

function M.keymaps()
  vim.cmd [[ command -nargs=+ Tmem :lua require("lv-neoterm").Tmem("<args>") ]]

  local remap = vim.api.nvim_set_keymap
  vim.g.neoterm_automap_keys = "<leader>te"
  -- Use gx to send to terminal
  -- remap("n", "gx", "<Plug>(neoterm-repl-send)", {})
  -- remap("n", "gxx", "<Plug>(neoterm-repl-send-line)", {})
  -- remap("x", "gx", "<Plug>(neoterm-repl-send)", {})
  remap("n", "<M-t>", ":T ", {})
  remap("n", "<M-S-t>", ":Tmem ", {})
end

return M
