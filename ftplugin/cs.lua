-- C# language server (csharp/OmniSharp) setup
require("lsp.config").lspconfig "omnisharp" {
  root_dir = require("lspconfig").util.root_pattern(".sln", ".git"),
  cmd = { DATA_PATH .. "/lspinstall/csharp/omnisharp/run", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
}
