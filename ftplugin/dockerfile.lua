-- npm install -g dockerfile-language-server-nodejs
require("lsp.config").lspconfig "dockerls" {
  root_dir = vim.loop.cwd,
}
