vim.opt_local.wrap = true
vim.opt_local.spell = true

if not require("lv-utils").check_lsp_client_active "texlab" then
  require("lsp.config").lspconfig "texlab" {
    cmd = { DATA_PATH .. "/lspinstall/latex/texlab" },
    on_attach = require("lsp.functions").common_on_attach,
    handlers = {
      ["textDocument/publishDiagnostics"] = O.lang.latex.diagnostics and vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        O.lang.latex.diagnostics
      ),
    },
    -- filetypes = O.lang.latex.filetypes,
    settings = {
      texlab = O.lang.latex.texlab,
    },
    flags = O.lsp.flags,
  }
end

local map = vim.api.nvim_buf_set_keymap
map(0, "n", "j", "gj", { noremap = true })
map(0, "n", "j", "gj", { noremap = true })
map(0, "v", "k", "gk", { noremap = true })
map(0, "v", "k", "gk", { noremap = true })

require("cmp").setup.buffer {
  sources = {
    { name = "luasnip" },
    { name = "buffer" },
  },
}

-- require("lv-utils").define_augroups {
--   _general_lsp = {
--     { "CursorHold,CursorHoldI", "*", ":lua vim.lsp.buf.formatting()" },
--   },
-- }
