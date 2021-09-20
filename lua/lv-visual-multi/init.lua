local M = {}
function M.preconf()
  vim.g.VM_maps = nil
  vim.g.VM_maps = {
    ["Find Under"] = "<M-n>",
    ["Select All"] = "<M-a>",
    ["Find Subword Under"] = "<M-n>",
    ["Add Cursor Down"] = "<M-j>",
    ["Add Cursor Up"] = "<M-k>",
    ["Select Cursor Down"] = "<M-S-j>",
    ["Select Cursor Up"] = "<M-S-k>",
    ["Skip Region"] = "n",
    ["Remove Region"] = "N",
    ["Visual Cursors"] = "<M-c>",
    ["Visual Add"] = "<M-a>",
    ["Visual All"] = "<M-S-a>",
    ["Start Regex Search"] = "<M-/>",
    ["Visual Regex"] = "/",
    ["Add Cursor At Pos"] = "<M-S-n>", -- TODO: better keymap for this?
    -- FIXME: Which key(?) is conflicting and making this not work, unless i type fast
    ["Find Operator"] = "m",
    ["Visual Find"] = "<M-f>",
    ["Undo"] = "u",
    ["Redo"] = "<C-r>",
  }
  vim.g.VM_leader = [[<leader>m]]
  -- vim.g.VM_leader = [[\]]
  vim.g.VM_theme = "neon"

  require("which-key").register({ [vim.g.VM_leader] = "which_key_ignore" }, { mode = "n" })
end
return M
