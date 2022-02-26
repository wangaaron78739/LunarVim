require("lsp.config").lspconfig "svelte" {
  filetypes = { "svelte" },
  root_dir = require("lspconfig.util").root_pattern("package.json", ".git"),
}
