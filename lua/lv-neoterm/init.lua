local remap = vim.api.nvim_set_keymap

vim.g.neoterm_default_mod = "vertical"
vim.g.neoterm_autoinsert = 0
vim.g.neoterm_bracketed_paste = 1
vim.g.neoterm_repl_python = { "ipython" }
vim.g.neoterm_automap_keys = " te"
--vim.g.neoterm_repl_python = "['conda activate venv', 'clear', 'ipython']"

-- Use gx{text-object} in normal mode
remap("n", "gx", "<Plug>(neoterm-repl-send)", {})
remap("n", "gxx", "<Plug>(neoterm-repl-send-line)", {})
-- Send selected contents in visual mode.
remap("x", "gx", "<Plug>(neoterm-repl-send)", {})
