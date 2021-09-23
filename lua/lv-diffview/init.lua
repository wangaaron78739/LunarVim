local M = {}
local gitsigns_fn = utils.cmd.require "gitsigns"
function M.diff_cWORD()
  local f = vim.fn.expand "<cWORD>"
  require("diffview").open("-- " .. f)
end
M.config = function()
  local cb = require("diffview.config").diffview_callback

  require("diffview").setup {
    diff_binaries = false, -- Show diffs for binaries
    use_icons = true, -- Requires nvim-web-devicons
    enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
    signs = {
      fold_closed = "",
      fold_open = "",
    },
    file_panel = {
      position = "left", -- One of 'left', 'right', 'top', 'bottom'
      width = 35, -- Only applies when position is 'left' or 'right'
      height = 10, -- Only applies when position is 'top' or 'bottom'
    },
    file_history_panel = {
      position = "bottom",
      width = 35,
      height = 16,
      log_options = {
        max_count = 256, -- Limit the number of commits
        follow = false, -- Follow renames (only for single file)
        all = false, -- Include all refs under 'refs/' including HEAD
        merges = false, -- List only merge commits
        no_merges = false, -- List no merge commits
        reverse = false, -- List commits in reverse order
      },
    },
    key_bindings = {
      disable_defaults = false, -- Disable the default key bindings
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      view = {
        ["<tab>"] = cb "select_next_entry", -- Open the diff for the next file
        ["<s-tab>"] = cb "select_prev_entry", -- Open the diff for the previous file
        ["<localleader>t"] = cb "toggle_stage_entry", -- Stage / unstage the selected entry.
        ["<localleader>x"] = cb "restore_entry", -- Restore entry to the state on the left side.
        ["<localleader>g"] = cb "goto_file", -- Open the file in a new split in previous tabpage
        ["<localleader>f"] = cb "goto_file_split", -- Open the file in a new split
        ["<localleader>F"] = cb "goto_file_tab", -- Open the file in a new tabpage
        ["<localleader>e"] = cb "focus_files", -- Bring focus to the files panel
        ["<localleader>b"] = cb "toggle_files", -- Toggle the files panel.
        ["<localleader>l"] = gitsigns_fn.blame_line,
        ["<localleader>p"] = gitsigns_fn.preview_hunk,
        ["<localleader>Rh"] = gitsigns_fn.reset_hunk,
        ["<localleader>Rb"] = gitsigns_fn.reset_buffer,
        ["<localleader>s"] = gitsigns_fn.stage_hunk,
        ["<localleader>u"] = gitsigns_fn.undo_stage_hunk,
      },
      file_panel = {
        ["<tab>"] = cb "select_next_entry",
        ["<s-tab>"] = cb "select_prev_entry",
        ["j"] = cb "next_entry", -- Bring the cursor to the next file entry
        ["<down>"] = cb "next_entry",
        ["k"] = cb "prev_entry", -- Bring the cursor to the previous file entry.
        ["<up>"] = cb "prev_entry",
        ["<cr>"] = cb "select_entry", -- Open the diff for the selected entry.
        ["o"] = cb "select_entry",
        ["<2-LeftMouse>"] = cb "select_entry",
        ["<localleader>t"] = cb "toggle_stage_entry", -- Stage / unstage the selected entry.
        ["<localleader>x"] = cb "restore_entry", -- Restore entry to the state on the left side.
        ["<localleader>S"] = cb "stage_all", -- Stage all entries.
        ["<localleader>U"] = cb "unstage_all", -- Unstage all entries.
        ["<localleader>r"] = cb "refresh_files", -- Update stats and entries in the file list.
        ["<localleader>g"] = cb "goto_file",
        ["<localleader>f"] = cb "goto_file_split",
        ["<localleader>F"] = cb "goto_file_tab",
        ["<localleader>e"] = cb "focus_files",
        ["<localleader>b"] = cb "toggle_files",
        ["q"] = "<cmd>DiffviewClose<cr>",
      },
      file_history_panel = {
        ["<tab>"] = cb "select_next_entry",
        ["<s-tab>"] = cb "select_prev_entry",
        ["j"] = cb "next_entry",
        ["<down>"] = cb "next_entry",
        ["k"] = cb "prev_entry",
        ["<up>"] = cb "prev_entry",
        ["<cr>"] = cb "select_entry",
        ["o"] = cb "select_entry",
        ["<2-LeftMouse>"] = cb "select_entry",
        ["<localledaer>!"] = cb "options", -- Open the option panel
        ["<localleader>d"] = cb "open_in_diffview", -- Open the entry under the cursor in a diffview
        ["zR"] = cb "open_all_folds",
        ["zM"] = cb "close_all_folds",
        ["<localleader>g"] = cb "goto_file",
        ["<localleader>f"] = cb "goto_file_split",
        ["<localleader>F"] = cb "goto_file_tab",
        ["<localleader>e"] = cb "focus_files",
        ["<localleader>b"] = cb "toggle_files",
      },
      option_panel = {
        ["<tab>"] = cb "select",
        ["q"] = cb "close",
      },
    },
  }
end
return M
