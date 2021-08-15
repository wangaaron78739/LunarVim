local M = {}
function M.config()
  -- TODO: lsp.<server>.setup(coq.lsp_ensure_capabilities(<stuff...>))
  -- TODO: reintegrate tabout
  vim.g.coq_settings = {
    ["keymap.jump_to_mark"] = "<c-n>",
    ["clients.snippets.sources"] = {},
    -- ["limits.completion_auto_timeout"] =
  }

  require("lv-utils").define_aucmd("_coq_start", { "BufRead", "*", "++once silent ! COQnow" })
end
return M
