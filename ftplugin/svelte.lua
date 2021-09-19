require("lsp.config").lspconfig "svelte" {
  cmd = { DATA_PATH .. "/lspinstall/svelte/node_modules/.bin/svelteserver", "--stdio" },
  filetypes = { "svelte" },
  root_dir = require("lspconfig.util").root_pattern("package.json", ".git"),
}
