require("lsp.config").lspconfig "terraformls" {
  cmd = { DATA_PATH .. "/lspinstall/terraform/terraform-ls", "serve" },

  filetypes = { "tf", "terraform", "hcl" },
}
