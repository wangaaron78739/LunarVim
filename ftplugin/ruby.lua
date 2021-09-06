-- If you are using rvm, make sure to change below configuration
require("lsp.config").lspconfig "solargraph" {
  cmd = { DATA_PATH .. "/lspinstall/ruby/solargraph/solargraph", "stdio" },
  filetypes = { "rb", "erb", "rakefile", "ruby" },
}
