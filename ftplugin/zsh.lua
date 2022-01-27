-- npm i -g bash-language-server
require("lsp.config").lspconfig "bashls" {

  filetypes = { "zsh" },
}
