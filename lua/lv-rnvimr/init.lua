return {
  config = function()
    -- Make Ranger replace netrw and be the file explorer
    vim.g.rnvimr_enable_ex = 1
    vim.g.rnvimr_draw_border = 1
    vim.g.rnvimr_enable_picker = 1
    -- vim.g.rnvimr_enable_bw = 1
    vim.api.nvim_set_keymap("n", "-", ":RnvimrToggle<CR>", { noremap = true, silent = true })
    require("lv-utils").define_augroups {
      _close_rnvimr = {
        { "FileType", "rnvimr", "tnoremap <silent> <buffer> <M-q> <C-\\><C-n><CMD>q<CR>" },
        { "FileType", "rnvimr", "tnoremap <silent> <buffer> <nowait> - <ESC>:q<CR>" },
        { "FileType", "rnvimr", "inoremap <silent> <buffer> <nowait> - <ESC>:q<CR>" },
      },
    }
  end,
}
