-- local action_mt = require "telescope.actions.mt"
-- local action_set = require "telescope.actions.set"
local extensions = require("telescope").extensions
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local themes = require "telescope.themes"

local M = {}

M.commands = {}
M.commands.rg = {
  "rg",
  "--color=never",
  "--no-config",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
  "--ignore",
  "--hidden",
}
M.commands.fd = {}
for i, v in ipairs(M.commands.rg) do
  M.commands.fd[i] = v
end
table.insert(M.commands.fd, "--files")

M.set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

--[[
lua require('plenary.reload').reload_module("plugin.telescope")
nnoremap <leader>en <cmd>lua require('plugin.telescope').edit_neovim()<CR>
--]]
function M.edit_neovim()
  require("telescope.builtin").find_files {
    prompt_title = "< VimRC >",
    shorten_path = false,
    cwd = "~/.config/nvim",

    layout_strategy = "vertical",
    layout_config = {
      width = 0.9,
      height = 0.8,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },

    attach_mappings = function(_, map)
      map("i", "<c-y>", M.set_prompt_to_entry_value)
      return true
    end,
  }
end

function M.edit_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/dots",

    attach_mappings = function(_, map)
      map("i", "<c-y>", M.set_prompt_to_entry_value)
      return true
    end,
  }
end

function M.edit_fish()
  require("telescope.builtin").find_files {
    shorten_path = false,
    cwd = "~/.config/fish/",
    prompt = "~ fish ~",
    hidden = true,

    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
  }
end

M.git_branches = function()
  require("telescope.builtin").git_branches {
    attach_mappings = function(_, map)
      map("i", "<c-x>", actions.git_delete_branch)
      map("n", "<c-x>", actions.git_delete_branch)
      map("i", "<c-y>", M.set_prompt_to_entry_value)
      return true
    end,
  }
end

function M.lsp_code_actions()
  require("telescope.builtin").lsp_code_actions(themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  })
end

--[[
function M.live_grep()
  require("telescope").extensions.fzf_writer.staged_grep {
    path_display = {"shorten_path"},
    previewer = false,
    fzf_separator = "|>",
  }
end
--]]

function M.grep_prompt()
  require("telescope.builtin").grep_string {
    path_display = { "shorten_path" },
    search = vim.fn.input "Grep String ❯ ",
  }
end

function M.grep_visual()
  require("telescope.builtin").grep_string {
    path_display = { "shorten_path" },
    search = require("utils").get_visual_selection(),
  }
end

function M.grep_cWORD()
  require("telescope.builtin").grep_string {
    path_display = { "shorten_path" },
    search = vim.fn.expand "<cWORD>",
  }
end

function M.grep_last_search(opts)
  opts = opts or {}

  -- \<getreg\>\C
  -- -> Subs out the search things
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

  opts.path_display = { "shorten_path" }
  opts.word_match = "-w"
  opts.search = register

  require("telescope.builtin").grep_string(opts)
end

function M.installed_plugins()
  require("telescope.builtin").find_files {
    cwd = vim.fn.stdpath "data" .. "/site/pack/packer/",
  }
end

function M.project_search()
  require("telescope.builtin").find_files {
    previewer = false,
    layout_strategy = "vertical",
    cwd = require("nvim_lsp.util").root_pattern ".git"(vim.fn.expand "%:p"),
  }
end

function M.curbuf()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  require("telescope.builtin").help_tags {
    show_version = true,
  }
end

function M.find_files()
  -- require("telescope").extensions.frecency.frecency()
  require("telescope.builtin").fd {
    -- find_command = { "fd", "--hidden", "--follow", "--type f" },
    file_ignore_patterns = { "node_modules", ".pyc" },
  }
end

function M.search_all_files()
  require("telescope.builtin").find_files {
    find_command = { "rg", "--no-ignore", "--files" },
  }
end

function M.file_browser()
  local opts

  opts = {
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    layout_config = {
      prompt_position = "top",
    },

    attach_mappings = function(prompt_bufnr, map)
      local current_picker = action_state.get_current_picker(prompt_bufnr)

      local modify_cwd = function(new_cwd)
        current_picker.cwd = new_cwd
        current_picker:refresh(opts.new_finder(new_cwd), { reset_prompt = true })
      end

      map("i", "-", function()
        modify_cwd(current_picker.cwd .. "/..")
      end)

      map("i", "~", function()
        modify_cwd(vim.fn.expand "~")
      end)

      local modify_depth = function(mod)
        return function()
          opts.depth = opts.depth + mod

          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:refresh(opts.new_finder(current_picker.cwd), { reset_prompt = true })
        end
      end

      map("i", "<M-=>", modify_depth(1))
      map("i", "<M-+>", modify_depth(-1))

      map("n", "yy", function()
        local entry = action_state.get_selected_entry()
        vim.fn.setreg("+", entry.value)
      end)

      return true
    end,
  }

  require("telescope.builtin").file_browser(opts)
end

function M.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }

  -- Can change the git icons using this.
  -- opts.git_icons = {
  --   changed = "M"
  -- }

  require("telescope.builtin").git_status(opts)
end

function M.git_commits()
  require("telescope.builtin").git_commits {
    winblend = 5,
  }
end

function M.search_only_certain_files()
  local cmd = {}
  for i, v in ipairs(M.commands.fd) do
    cmd[i] = v
  end
  table.insert(cmd, "--type")
  table.insert(cmd, vim.fn.input "Type: ")
  local fd = table.insert()
  require("telescope.builtin").find_files {
    find_command = cmd,
  }
end

function M.projects()
  extensions.project.project {}
end

return setmetatable({}, {
  __index = function(_, k)
    -- reloader()

    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})
