local M = {}
local prefix = "<localleader>"
local maps = {
  ["toggle_line"] = {
    map = "d",
    cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
    desc = "toggle current item",
  },
  ["enter_file"] = {
    map = "<cr>",
    cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
    desc = "goto current file",
  },
  ["send_to_qf"] = {
    map = prefix .. "q",
    cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
    desc = "send all item to quickfix",
  },
  ["replace_cmd"] = {
    map = prefix .. "c",
    cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
    desc = "input replace vim command",
  },
  ["show_option_menu"] = {
    map = prefix .. "o",
    cmd = "<cmd>lua require('spectre').show_options()<CR>",
    desc = "show option",
  },
  ["run_replace"] = {
    map = prefix .. "r",
    cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
    desc = "replace all",
  },
  ["change_view_mode"] = {
    map = prefix .. "v",
    cmd = "<cmd>lua require('spectre').change_view()<CR>",
    desc = "change result view mode",
  },
  ["toggle_ignore_case"] = {
    map = prefix .. "i",
    cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
    desc = "toggle ignore case",
  },
  ["toggle_ignore_hidden"] = {
    map = prefix .. "h",
    cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
    desc = "toggle search hidden",
  },
  -- you can put your mapping here it only use normal mode
}
M.setup = function()
  -- ft = spectre_panel
  -- TODO: register which-key

  require("spectre").setup {
    find_engine = {
      -- rg is map with finder_cmd
      ["rg"] = {
        cmd = "rg",
        -- default args
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--no-config",
        },
        options = {
          ["ignore-case"] = {
            value = "--ignore-case",
            icon = "[I]",
            desc = "ignore case",
          },
          ["hidden"] = {
            value = "--hidden",
            desc = "hidden file",
            icon = "[H]",
          },
          -- you can put any option you want here it can toggle with
          -- show_option function
        },
      },
    },
    mapping = maps,
  }
end
return M
