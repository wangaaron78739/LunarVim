local M = {}
function M.config()
  -- TODO: lsp.<server>.setup(coq.lsp_ensure_capabilities(<stuff...>))
  -- TODO: reintegrate tabout
  vim.g.coq_settings = {
    ["keymap.jump_to_mark"] = "<c-n>",
    -- ["limits.completion_auto_timeout"] =
    -- auto_start = true,
  }

  require("lv-utils").define_aucmd("_coq_start", { "VimEnter", "*", "COQnow --shut-up" })
end
return M
