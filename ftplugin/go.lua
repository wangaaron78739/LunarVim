require("lsp.config").lspconfig "gopls" {
  cmd = { DATA_PATH .. "/lspinstall/go/gopls" },
  root_dir = require("lspconfig").util.root_pattern(".git", "go.mod"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  init_options = { usePlaceholders = true, completeUnimported = true },
}

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false
