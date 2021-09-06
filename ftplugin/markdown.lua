local conf = {
  conceal = 2,
  theme = O.lighttheme,
  fontsize = O.bigfontsize,
}
vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.conceallevel = conf.conceal
-- vim.opt_local.background = conf.background
if conf.theme then
  vim.cmd(conf.theme)
  -- utils.define_augroups {
  --   _switching_themes = {
  --     { "BufWinEnter", "<buffer>", conf.background },
  --     { "BufLeave", "<buffer>", " lua require'theme'()" },
  --   },
  -- }
end
if conf.fontsize then
  utils.set_guifont(conf.fontsize)
end

-- You should specify your *installed* sources.
require("cmp").setup.buffer {
  { name = "luasnip" },
  { name = "nvim_lsp" },
  { name = "buffer" },
  { name = "latex_symbols" },
  { name = "calc" },
  -- { name = "cmp_tabnine" },
}
