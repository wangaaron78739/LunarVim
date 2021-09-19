-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/plugin/telescope.lua
local sorters = require "telescope.sorters"
local actions = require "telescope.actions"
local functions = require "lv-telescope.functions"
-- Global remapping
------------------------------
TelescopeMapArgs = TelescopeMapArgs or {}
local map_ = vim.api.nvim_set_keymap
local map_b = vim.api.nvim_buf_set_keymap
local map_options = {
  noremap = true,
  silent = true,
}
local map_tele = function(mode, key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local rhs = string.format("<cmd>lua require('telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)

  if not buffer then
    map_(mode, key, rhs, map_options)
  else
    map_b(0, mode, key, rhs, map_options)
  end
end

local telescope = require "telescope"
telescope.setup {
  defaults = {
    find_command = functions.commands.fd,
    vimgrep_arguments = functions.commands.rg,
    prompt_prefix = " ",
    selection_caret = " ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.75,
      prompt_position = "bottom",
      preview_cutoff = 120,
      horizontal = { mirror = false },
      vertical = { mirror = false },
    },
    -- file_sorter = sorters.get_fzy_sorter,
    -- generic_sorter = sorters.get_fzy_sorter,
    -- generic_sorter = sorters.get_generic_fuzzy_sorter,
    file_ignore_patterns = {},
    path_display = { "shorten_path" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      i = {
        ["<C-h>"] = telescope.extensions.hop.hop,
        ["<C-x>"] = actions.delete_buffer,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        -- ["<C-t>"] = actions.select_tab,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<CR>"] = actions.select_default + actions.center,
        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-y>"] = functions.set_prompt_to_entry_value,
      },
      n = {
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["<C-x>"] = actions.delete_buffer,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        -- ["<C-t>"] = actions.select_tab,
        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.send_to_qflist,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-c>"] = actions.close,
      },
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    "cmake",
    extensions = {
      hop = {
        keys = { "a", "s", "d", "f", "h", "j", "k", "l" },
      },
    },
  },
}

-- telescope.setup {}

_G.telescopes = functions
-- telescope.load_extension('fzy_native')
telescope.load_extension "fzf"
telescope.load_extension "hop"
-- telescope.load_extension "frecency"
-- telescope.load_extension('project')
