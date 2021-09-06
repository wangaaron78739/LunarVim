-- npm i -g bash-language-server
require("lsp.config").lspconfig "bashls" {
  cmd = { DATA_PATH .. "/lspinstall/bash/node_modules/.bin/bash-language-server", "start" },

  filetypes = { "zsh" },
}
