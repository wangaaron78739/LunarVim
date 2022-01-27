local conf = {
  conceal = 2,
  -- theme = O.lighttheme,
  fontsize = O.bigfontsize,
}
vim.opt_local.wrap = true
require("keymappings").wrapjk()
vim.opt_local.spell = true
vim.opt.number = false
vim.opt.relativenumber = false
require("lv-lightspeed").au_unconceal(conf.conceal)
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
require("lv-cmp").sources {
  { name = "luasnip" },
  { name = "nvim_lsp" },
  { name = "buffer" },
  { name = "latex_symbols" },
  { name = "calc" },
  { name = "spell" },
  -- { name = "cmp_tabnine" },
}

mappings.localleader {
  p = { "<Plug>MarkdownPreviewToggle", "Preview Toggle" },
  g = { "<CMD>Glow<CR>", "Glow" },
}

require("lv-pairs.sandwich").add_local_recipe {
  buns = { "```\n", "\n```" },
  quoteescape = true,
  expand_range = false,
  nesting = false,
  input = { "c" },
}

-- TODO: make snippets for math in markdown?

require("lv-terms").mdeval_keymaps()
