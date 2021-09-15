local M = {}
function M.preconf()
  -- TODO: detect kitty or fallback to neovim
  vim.g.slime_target = O.plugin.slime.target
  vim.g.slime_no_mappings = true
  -- Fill in default config here somehow
  -- let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}
end
function M.config()
  -- local map = vim.api.nvim_set_keymap
  -- map("v", "<leader>ts", "<cmd>SlimeSend<cr>", { silent = true })
  -- map("n", "<leader>tss", "<cmd>SlimeSendCurrentLine<cr>", { silent = true })
  mappings.whichkey {
    ["<leader>ts"] = "<cmd>SlimeSend<cr>",
    ["<leader>tss"] = "<cmd>SlimeSendCurrentLine<cr>",
  }
end
return M
