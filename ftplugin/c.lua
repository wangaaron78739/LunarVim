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
if O.lang.clang.autoformat then
  local autocmds = {}
  for _, extension in ipairs(extensions) do
    table.insert(autocmds, {
      "BufWritePre",
      "*." .. extension,
      "lua vim.lsp.buf.formatting_sync(nil,1000)",
    })
  end
  require("lv-utils").define_augroups {
    _cpp = autocmds,
  }
end

require("lspconfig").clangd.setup {
  cmd = {
    DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd",
    unpack(clangd_flags),
  },
  on_attach = require("lsp").common_on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = O.lang.clang.diagnostics.virtual_text,
      signs = O.lang.clang.diagnostics.signs,
      underline = O.lang.clang.diagnostics.underline,
      update_in_insert = true,
    }),
  },
  flags = O.lsp.flags,
}

if O.lang.clang.efm.active == true then
  require("lsp.efm-ls").generic_setup { "c", "cpp" }
end
