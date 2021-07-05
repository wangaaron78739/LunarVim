local clangd_flags = { "--background-index" }

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
    table.insert(autocmds, {
      "BufEnter",
      "*." .. extension,
      [[setlocal commentstring=//\ %s]],
    })
  end
  require("lv-utils").define_augroups {
    _cpp = autocmds,
    -- {
    --     {'BufWritePre', '*.c', 'lua vim.lsp.buf.formatting_sync(nil,1000)'},
    --     {
    --         'BufWritePre', '*.cpp',
    --         'lua vim.lsp.buf.formatting_sync(nil,1000)'
    --     },
    --     {'BufWritePre', '*.cc', 'lua vim.lsp.buf.formatting_sync(nil,1000)'},
    --     {'BufWritePre', '*.h', 'lua vim.lsp.buf.formatting_sync(nil,1000)'},
    --     {
    --         'BufWritePre', '*.hpp',
    --         'lua vim.lsp.buf.formatting_sync(nil,1000)'
    --     }, {'BufEnter', '*.cpp', 'setlocal commenstring', "// %s"},
    --     {'BufEnter', '*.c', 'setlocal commenstring', "// %s"},
    --     {'BufEnter', '*.h', 'setlocal commenstring', "// %s"},
    --     {'BufEnter', '*.hpp', 'setlocal commenstring', "// %s"},
    --     {'BufEnter', '*.cc', 'setlocal commenstring', "// %s"}
    -- }
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
}
