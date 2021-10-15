-- C# language server (csharp/OmniSharp) setup
require("lsp.config").lspconfig "omnisharp" {
  root_dir = require("lspconfig").util.root_pattern(".sln", ".git"),
}
