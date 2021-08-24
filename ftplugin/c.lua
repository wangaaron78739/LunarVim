vim.opt_local.commentstring = [[// %s]]

if require("lv-utils").check_lsp_client_active "clangd" then
  return
end

local clangd_flags = { "--background-index", "--query-driver=**/arm-none-eabi-*,**/x86_64-linux-*" }

if O.lang.clang.cross_file_rename then
  table.insert(clangd_flags, "--cross-file-rename")
end

table.insert(clangd_flags, "--header-insertion=" .. O.lang.clang.header_insertion)

local extensions = { "hpp", "h", "cpp", "c", "cc" }

require("lsp.config").lspconfig  "clangd" {
  cmd = {
    DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd",
    unpack(clangd_flags),
  },
  on_attach = require("lsp.functions").common_on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = O.lang.clang.diagnostics and vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      O.lang.clang.diagnostics
    ),
  },
  flags = O.lsp.flags,
}
