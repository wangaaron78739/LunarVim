-- npm i -g bash-language-server
local ft = { "sh", "bash" }

require("lsp.config").lspconfig "bashls" {
  filetypes = ft,
}
