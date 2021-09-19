local lsp_status = require "lsp-status"
vim.opt_local.commentstring = [[// %s]]

local clangd_flags = { "--background-index", "--query-driver=**/arm-none-eabi-*,**/x86_64-linux-*" }
table.insert(clangd_flags, "--cross-file-rename")
table.insert(clangd_flags, "--header-insertion=never")

require("lsp.config").lspconfig "clangd" {
  cmd = {
    DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd",
    unpack(clangd_flags),
  },
  init_options = { clangdFileStatus = true },
  handlers = lsp_status.extensions.clangd.setup(),
}
