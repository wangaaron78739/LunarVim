return {
  config = function()
    -- Make Ranger replace netrw and be the file explorer
    vim.g.rnvimr_enable_ex = 1
    vim.g.rnvimr_draw_border = 1
    vim.g.rnvimr_enable_picker = 1
    vim.g.rnvimr_enable_bw = 1
    vim.api.nvim_set_keymap("n", "-", ":RnvimrToggle<CR>", { noremap = true, silent = true })
  end,
}
