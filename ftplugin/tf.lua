if require("lv-utils").check_lsp_client_active "terraformls" then
  return
end

require("lsp.functions").lspconfig("terraformls") {
  cmd = { DATA_PATH .. "/lspinstall/terraform/terraform-ls", "serve" },
  on_attach = require("lsp.functions").common_on_attach,
  filetypes = { "tf", "terraform", "hcl" },
  flags = O.lsp.flags,
}
