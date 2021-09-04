local conf = O.lang.markdown
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
-- {'FileType', 'markdown', 'set guifont "FiraCode Nerd Font:h15"'},
