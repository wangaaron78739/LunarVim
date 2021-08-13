local M = {}
function M.preconf()
  -- TODO: detect kitty or fallback to neovim
  vim.g.slime_target = O.plugin.slime.target
  vim.g.slime_no_mappings = true
  -- Fill in default config here somehow
  -- let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}
end
function M.config()
  local remap = vim.api.nvim_set_keymap
  -- remap("n", "<leader>xs", ":MagmaEvaluateOperator<CR>", { expr = true, silent = true })
  remap("v", "<leader>ts", ":<C-u>SlimeSend<CR>", { silent = true })
  remap("n", "<leader>tss", "<cmd>SlimeSendCurrentLine<CR>", { silent = true })
end
return M
