local util = require "lspconfig/util"

-- TODO: enable jdtls dap
require("lsp.config").lspconfig "jdtls" {
  cmd = { DATA_PATH .. "/lspinstall/java/jdtls.sh" },
  filetypes = { "java" },
  root_dir = util.root_pattern { ".git", "build.gradle", "pom.xml" },
  -- init_options = {bundles = bundles}
}

-- require('jdtls').start_or_attach({
--     on_attach = on_attach,
--     cmd = {DATA_PATH .. "/lspinstall/java/jdtls.sh"},
--     root_dir = require('jdtls.setup').find_root({'build.gradle', 'pom.xml', '.git'}),
--     init_options = {bundles = bundles}
-- })
