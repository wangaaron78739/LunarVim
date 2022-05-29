local M = {}
M.config = function()
  local set = vim.keymap.set
  local surf = require "syntax-tree-surfer"
  -- .select() will show you what you will be swapping with .move(), you'll get used to .select() and .move() behavior quite soon!
  set("n", "vx", surf.select, {})
  -- .select_current_node() will select the current node at your cursor
  set("n", "vn", surf.select_current_node, {})

  -- NAVIGATION: Only change the keymap to your liking. I would not recommend changing anything about the .surf() parameters!
  set("x", "J", function()
    surf.surf("next", "visual")
  end, {})
  set("x", "K", function()
    surf.surf("prev", "visual")
  end, {})
  set("x", "H", function()
    surf.surf("parent", "visual")
  end, {})
  set("x", "L", function()
    surf.surf("child", "visual")
  end, {})

  -- SWAPPING WITH VISUAL SELECTION: Only change the keymap to your liking. Don't change the .surf() parameters!
  set("x", "<A-j>", function()
    surf.surf("next", "visual", true)
  end, {})
  set("x", "<A-k>", function()
    surf.surf("prev", "visual", true)
  end, {})
end
return M
