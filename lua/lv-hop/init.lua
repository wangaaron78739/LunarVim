local M = {}

M.config = function()
    require'hop'.setup()
    vim.api.nvim_set_keymap('n', '<M-s>', ":HopChar2<cr>", {silent = true})
    vim.api.nvim_set_keymap('n', '<M-f>', ":HopChar1<cr>", {silent = true})
    vim.api.nvim_set_keymap('n', '<M-S-S>', ":HopWord<cr>", {silent = true})
end

return M
