local M = {}
function M.config()
  -- TODO: reintegrate tabout
  vim.g.coq_settings = {
    ["keymap.jump_to_mark"] = "<c-n>",
    -- ["limits.completion_auto_timeout"] =
    -- auto_start = true,
  }

  utils.augroup("_coq_start").VimEnter = "COQnow --shut-up"
end
return M
