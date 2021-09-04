local conf = O.lang.latex
vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.conceallevel = conf.conceal
-- vim.opt_local.background = "light"
if conf.theme then
  vim.cmd(conf.theme)
  -- utils.define_augroups {
  --   _switching_themes = {
  --     { "BufWinEnter", "<buffer>", latexconf.background },
  --     { "BufLeave", "<buffer>", " lua require'theme'()" },
  --   },
  -- }
end
if conf.fontsize then
  utils.set_guifont(conf.fontsize)
end

if not require("lv-utils").check_lsp_client_active "texlab" then
  require("lsp.config").lspconfig "texlab" {
    cmd = { DATA_PATH .. "/lspinstall/latex/texlab" },
    on_attach = require("lsp.functions").common_on_attach,
    handlers = {
      ["textDocument/publishDiagnostics"] = conf.diagnostics and vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        conf.diagnostics
      ),
    },
    -- filetypes = latexconf.filetypes,
    settings = {
      texlab = conf.texlab,
    },
    flags = O.lsp.flags,
  }
end

local map = vim.api.nvim_buf_set_keymap
map(0, "n", "j", "gj", { noremap = true })
map(0, "n", "j", "gj", { noremap = true })
map(0, "v", "k", "gk", { noremap = true })
map(0, "v", "k", "gk", { noremap = true })

-- require("lv-utils").define_augroups {
--   _general_lsp = {
--     { "CursorHold,CursorHoldI", "*", ":lua vim.lsp.buf.formatting()" },
--   },
-- }

require("cmp").setup.buffer {
  sources = {
    { name = "luasnip" },
    -- { name = "nvim_lsp" },
    { name = "buffer" },
  },
}

require("luasnip").snippets.tex = require("lv-luasnips.tex").snips
require("luasnip").autosnippets.tex = require("lv-luasnips.tex").auto

local wk = require "which-key"
local leaderOpts = {
  mode = "n", -- NORMAL mode
  prefix = "<localleader>",
  buffer = 0, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = false,
  -- silent = true, -- use `silent` when creating keymaps
  noremap = false, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}
local cmd = require("lv-utils").cmd
wk.register({
  f = { cmd "call vimtex#fzf#run()", "Fzf Find" },
  i = { cmd "VimtexInfo", "Project Information" },
  s = { cmd "VimtexStop", "Stop Project Compilation" },
  t = { cmd "VimtexTocToggle", "Toggle Table Of Content" },
  v = { cmd "VimtexView", "View PDF" },
  c = { cmd "VimtexCompile", "Compile Project Latex" },
  o = { cmd "VimtexCompileOutput", "Compile Output Latex" },
  l = { cmd "TexlabBuild", "Texlab Build" },
  n = { cmd.require("nabla").action, "Nabla" },
}, leaderOpts)

require("lv-utils").define_augroups { _vimtex_event = {
  { "InsertLeave", "*.tex", "VimtexCompile" },
} }
