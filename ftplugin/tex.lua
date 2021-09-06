-- TODO: inline these variables
local conf = {
  conceal = 2,
  theme = O.lighttheme,
  fontsize = O.bigfontsize,
  filetypes = { "tex", "bib" },
  texlab = {
    aux_directory = ".",
    bibtex_formatter = "texlab",
    build = {
      executable = "tectonic",
      args = {
        -- Input
        "%f",
        -- Flags
        "--synctex",
        "--keep-logs",
        "--keep-intermediates",
        -- Options
        -- OPTIONAL: If you want a custom out directory,
        -- uncomment the following line.
        --"--outdir out",
      },
      forwardSearchAfter = false,
      onSave = true,
    },
    chktex = { on_edit = true, on_open_and_save = true },
    diagnostics_delay = vim.opt.updatetime,
    formatter_line_length = 80,
    forward_search = { args = {}, executable = "" },
    latexFormatter = "latexindent",
    latexindent = { modify_line_breaks = false },
  },
}
vim.opt_local.wrap = true
vim.opt_local.spell = true
local map = vim.api.nvim_buf_set_keymap
map(0, "n", "j", "gj", { noremap = true, silent = true })
map(0, "n", "j", "gj", { noremap = true, silent = true })
map(0, "v", "k", "gk", { noremap = true, silent = true })
map(0, "v", "k", "gk", { noremap = true, silent = true })
map(0, "v", "<C-b>", "Smb", { silent = true })
map(0, "v", "<C-t>", "Smi", { silent = true })
map(0, "n", "<C-b>", "ysiwmb", { silent = true })
map(0, "n", "<C-t>", "ysiwmb", { silent = true })
map(0, "i", "<C-b>", "<cmd>normal ysiwmb<cr>", { silent = true })
map(0, "i", "<C-t>", "<cmd>normal ysiwmb<cr>", { silent = true })

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

require("lsp.config").lspconfig "texlab" {
  cmd = { DATA_PATH .. "/lspinstall/latex/texlab" },
  filetypes = conf.filetypes,
  settings = {
    texlab = conf.texlab,
  },
}

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

-- Localleader
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
  c = { "<leader>Tc", "Toggle Conceal" },
  b = { cmd "VimtexCompile", "Compile" },
  o = { cmd "VimtexCompileOutput", "Compile Output" },
  e = { cmd "VimtexErrors", "Errors" },
  l = { cmd "TexlabBuild", "Texlab Build" },
  n = { cmd.require("nabla").action, "Nabla" },
}, leaderOpts)

-- require("lv-utils").define_augroups { _vimtex_event = {
--   { "InsertLeave", "*.tex", "VimtexCompile" },
-- } }
