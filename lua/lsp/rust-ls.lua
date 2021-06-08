vim.cmd([[
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
]])

require'lspconfig'.rust_analyzer.setup{
    cmd = {"rust-analyzer"},
    on_attach = require'lsp'.common_on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
            checkOnSave = {
                enable = true,
                command = "clippy" -- comment out to not use clippy
            }
        }
    }
}
