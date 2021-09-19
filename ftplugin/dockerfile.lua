-- npm install -g dockerfile-language-server-nodejs
require("lsp.config").lspconfig "dockerls" {
  cmd = {
    DATA_PATH .. "/lspinstall/dockerfile/node_modules/.bin/docker-langserver",
    "--stdio",
  },
  root_dir = vim.loop.cwd,
}
