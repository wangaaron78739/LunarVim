-- npm install -g vim-language-server
require("lsp.config").lspconfig "vimls" {
  cmd = {
    DATA_PATH .. "/lspinstall/vim/node_modules/.bin/vim-language-server",
    "--stdio",
  },
}
