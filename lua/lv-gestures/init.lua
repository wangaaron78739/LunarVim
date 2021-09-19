local M = {}
local conf = O.plugin.gesture
M.keymaps = function()
  if conf then
    local map = vim.api.nvim_set_keymap
    -- Helper functions
    local gesturecmd = require("lv-utils").cmd.require "gesture"

    if conf.lmb then
      -- map("n", "<LeftMouse>", gesturecmd.draw, { silent = true })
      map("n", "<LeftDrag>", gesturecmd.draw, { silent = true })
      map("n", "<LeftRelease>", gesturecmd.finish, { silent = true })
    end
    if conf.rmb then
      map("n", "<RightMouse>", "<NOP>", { silent = true })
      map("n", "<RightDrag>", gesturecmd.draw, { silent = true })
      map("n", "<RightRelease>", gesturecmd.finish, { silent = true })
    end
  end
end
M.config = function()
  local gesture = require "gesture"
  local register = gesture.register
  local up = gesture.up()
  local down = gesture.down()
  local right = gesture.right()
  local left = gesture.left()

  -- TODO: pure mouse navigation for exploring codebases??
  register {
    name = "go to defn",
    inputs = { left },
    action = "lua vim.lsp.buf.definition()",
  }
  register {
    name = "previous",
    inputs = { up, left },
    action = "b#",
  }
  register {
    name = "go to ref",
    inputs = { right },
    action = "lua vim.lsp.buf.references()",
  }
  register {
    name = "scroll to bottom",
    inputs = { up, down },
    action = "normal! G",
  }
  -- register {
  --   name = "next tab",
  --   inputs = { gesture.right() },
  --   action = "tabnext",
  -- }
  -- register {
  --   name = "previous tab",
  --   inputs = { gesture.left() },
  --   action = function(ctx) -- also can use callable
  --     vim.cmd "tabprevious"
  --   end,
  -- }
  -- register {
  --   name = "go back",
  --   inputs = { gesture.right(), gesture.left() },
  --   -- map to `<C-o>` keycode
  --   action = [[lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "n", true)]],
  -- }
end
return M
