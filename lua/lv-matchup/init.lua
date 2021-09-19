local M = {}

M.config = function()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
  vim.g.matchup_matchparen_enabled = 0
  vim.g.matchup_motion_enabled = 0
  vim.g.matchup_text_obj_enabled = 0
end

return M
