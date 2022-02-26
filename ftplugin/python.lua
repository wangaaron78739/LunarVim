require("lsp.config").lspconfig "pyright" {
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

require("lv-pairs.sandwich").add_recipe {
  buns = { [["""]], [["""]] },
  quoteescape = true,
  expand_range = false,
  nesting = false,
  input = { "s" },
}
require("lv-pairs.sandwich").add_recipe {
  buns = { [[''']], [[''']] },
  quoteescape = true,
  expand_range = false,
  nesting = false,
  input = { "S" },
}

mappings.localleader {
  x = { "<cmd>MagmaInit<cr>", "Magma" },
}
vim.keymap.setl("i", "<S-CR>", "<ESC>o# %%<CR>", { silent = true })

require("lv-terms").jupyter_ascending()
