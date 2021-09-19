require("lsp.config").lspconfig "intelephense" {
  cmd = {
    DATA_PATH .. "/lspinstall/php/node_modules/.bin/intelephense",
    "--stdio",
  },
  filetypes = { "php", "phtml" },
  settings = {
    intelephense = {
      format = { braces = "psr12" },
      environment = { phpVersion = "7.4" },
    },
  },
}
