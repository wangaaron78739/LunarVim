local M = {}
function M.config()
  local remap = vim.api.nvim_set_keymap
  remap("n", "gx", ":MagmaEvaluateOperator<CR>", { expr = true, silent = true })
  remap("v", "gx", ":<C-u>MagmaEvaluateVisual<CR>", { silent = true })
  remap("n", "gxx", "<cmd>MagmaEvaluateLine<CR>", { silent = true })
  vim.g.magma_automatically_open_output = false
  -- TODO: add autocommands to initialize the kernel?
end
return M
