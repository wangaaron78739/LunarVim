require("lsp.config").lspconfig "pyright" {
  cmd = {
    DATA_PATH .. "/lspinstall/python/node_modules/.bin/pyright-langserver",
    "--stdio",
  },
  settings = {
    python = {
      analysis = {
        type_checking = "basic", -- off
        auto_search_paths = true,
        use_library_code_types = true,
      },
    },
  },
}

vim.b.lv_magma_kernel = "python3"

-- if O.plugin.debug and O.plugin.dap_install then
--   local dap_install = require "dap-install"
--   dap_install.config("python_dbg", {})
-- end

require("lv-sandwich").add_recipe {
  buns = { [["""]], [["""]] },
  quoteescape = true,
  expand_range = false,
  nesting = false,
  input = { "s" },
}
