local M = {}

M.config = function()
  vim.g.tex_flavor = "latex"
  vim.g.vimtex_view_method = "zathura"
  vim.g.vimtex_view_automatic = 1
  vim.g.vimtex_quickfix_mode = 0
  vim.g.tex_conceal = "abdmgs"

  vim.g.vimtex_compiler_method = "tectonic"
  vim.g.vimtex_compiler_generic = { cmd = "watchexec -e tex -- tectonic --synctex --keep-logs *.tex" }
  vim.g.vimtex_compiler_tectonic = {
    ["options"] = { "--synctex", "--keep-logs" },
  }
  vim.g.vimtex_compiler_latexmk = {
    ["options"] = {
      "-shell-escape",
      "-verbose",
      "-file-line-error",
      "-synctex=1",
      "-interaction=nonstopmode",
    },
  }

  -- local augroups = {
  --   -- {'User', 'VimtexEventQuit', 'call vimtex#compiler#clean(0)'},
  --   -- {'FileType', 'tex', 'call vimtex#compiler#compile()'}, -- FIXME: This doesn't work for some reason (not continuous)
  -- }
  -- if vim.g.vimtex_compiler_method == "tectonic" then
  --   table.insert(augroups, { "BufWritePost", "*.tex", "VimtexCompile" })
  --   -- table.insert(augroups, {"CursorHold", '*.tex', 'VimtexCompile'})
  -- end
  -- require("lv-utils").define_augroups { _vimtex_event = augroups }
end

return M
