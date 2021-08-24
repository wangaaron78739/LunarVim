if require("lv-utils").check_lsp_client_active "graphql" then
  return
end

-- npm install -g graphql-language-service-cli
require("lsp.config").lspconfig  "graphql" {
  on_attach = require("lsp.functions").common_on_attach,
  flags = O.lsp.flags,
}
