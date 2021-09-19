-- npm install -g yaml-language-server
require("lsp.config").lspconfig "yamlls" {
  cmd = {
    DATA_PATH .. "/lspinstall/yaml/node_modules/.bin/yaml-language-server",
    "--stdio",
  },
}
vim.cmd "setl ts=2 sw=2 ts=2 ai et"
