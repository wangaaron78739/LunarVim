if not require("lv-utils").check_lsp_client_active "gopls" then
  require("lspconfig").gopls.setup {
    cmd = { DATA_PATH .. "/lspinstall/go/gopls" },
    settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
    root_dir = require("lspconfig").util.root_pattern(".git", "go.mod"),
    init_options = { usePlaceholders = true, completeUnimported = true },
    on_attach = require("lsp").common_on_attach,
    flags = O.lsp.flags,
  }
end

if O.lang.go.autoformat then
  require("lv-utils").define_augroups {
    _go_format = {
      { "BufWritePre", "*.go", "lua vim.lsp.buf.formatting_sync(nil,1000)" },
    },
  }
end
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false
