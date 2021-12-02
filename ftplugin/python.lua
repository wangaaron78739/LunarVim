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

mappings.localleader {
  x = { "<cmd>MagmaInit<cr>", "Magma" },
}
vim.api.nvim_buf_set_keymap(0, "i", "<S-CR>", "<ESC>o# %%<CR>", { noremap = true, silent = true })

require("lv-terms").jupyter_ascending()
