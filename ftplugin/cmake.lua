require("lsp.config").lspconfig "cmake" {
  cmd = { DATA_PATH .. "/lspinstall/cmake/venv/bin/cmake-language-server" },
  filetypes = { "cmake" },
}
