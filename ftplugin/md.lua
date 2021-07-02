vim.api.nvim_exec([[
        augroup vimtex_event_1
            au!
            au User FileType markdown setlocal wrap
            au User FileType markdown setlocal spell
        augroup END
    ]], false)
