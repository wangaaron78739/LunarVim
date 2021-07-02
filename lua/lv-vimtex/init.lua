vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = 'abdmgs'
vim.g.vimtex_compiler_method = "tectonic"
vim.g.vimtex_compiler_latexmk = {
    ['options'] = {
        '-shell-escape', '-verbose', '-file-line-error', '-synctex=1',
        '-interaction=nonstopmode'
    }
}
-- Compile on initialization, cleanup on quit TODO: translate to lua
-- vim.api.nvim_exec(
--     [[
--         augroup vimtex_event_1
--             au!
--             au User VimtexEventQuit     call vimtex#compiler#clean(0)
--             au User VimtexEventInitPost call vimtex#compiler#compile()
--         augroup END
--     ]], false
-- )
