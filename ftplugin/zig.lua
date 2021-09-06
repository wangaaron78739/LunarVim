-- Because lspinstall don't support zig yet,
-- So we need zls preset in global lib
-- Further custom install zls in
-- https://github.com/zigtools/zls/wiki/Downloading-and-Building-ZLS
require("lsp.config").lspconfig "zls" {
  root_dir = require("lspconfig").util.root_pattern(".git", "build.zig", "zls.json"),
  cmd = { DATA_PATH .. "/lspinstall/zig/zls/zls" },
}

vim.opt_local.commentstring = [[// %s]]

vim.opt_local.expandtab = true
vim.opt_local.tabstop = 8
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
