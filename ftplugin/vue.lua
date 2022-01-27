require("lsp.config").lspconfig "vuels" {

  root_dir = require("lspconfig").util.root_pattern(".git", "vue.config.js", "package.json", "yarn.lock"),
}
