local util = require "lspconfig/util"

-- TODO: enable jdtls dap
require("lsp.config").lspconfig "jdtls" {
  filetypes = { "java" },
  root_dir = util.root_pattern { ".git", "build.gradle", "pom.xml" },
  -- init_options = {bundles = bundles}
}

-- require('jdtls').start_or_attach({
--     on_attach = on_attach,
--     root_dir = require('jdtls.setup').find_root({'build.gradle', 'pom.xml', '.git'}),
--     init_options = {bundles = bundles}
-- })
