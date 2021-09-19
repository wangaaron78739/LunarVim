-- TODO what is a tailwindcss filetype
require("lsp.config").lspconfig "tailwindcss" {
  cmd = {
    "node",
    DATA_PATH .. "/lspinstall/tailwindcss/tailwindcss-intellisense/extension/dist/server/tailwindServer.js",
    "--stdio",
  },
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = require("lspconfig/util").root_pattern("tailwind.config.js", "postcss.config.ts", ".postcssrc"),
}
