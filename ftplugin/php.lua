require("lsp.config").lspconfig "intelephense" {
  filetypes = { "php", "phtml" },
  settings = {
    intelephense = {
      format = { braces = "psr12" },
      environment = { phpVersion = "7.4" },
    },
  },
}
