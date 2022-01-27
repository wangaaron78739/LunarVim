-- local action_mt = require "telescope.actions.mt"
-- local action_set = require "telescope.actions.set"
local extensions = require("telescope").extensions
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local themes = require "telescope.themes"
local builtins = require "telescope.builtin"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"

local M = {}

M.commands = {}
function rg(ignore, hidden, files)
  return {
    "rg",
    "--color=never",
    "--no-config",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    ignore and "--ignore" or "--no-ignore",
    hidden and "--hidden" or "--no-hidden",
    files and "--files" or nil,
  }
end
M.commands.rg = rg(true, true, false)
-- M.commands.fd = vim.list_extend(vim.deepcopy(M.commands.rg), { "--files" })
M.commands.fd = rg(true, true, true)

function M.set_prompt_to_entry_value(prompt_bufnr)
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
  builtins.find_files {
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
  builtins.find_files {
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
  builtins.find_files {
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

function M.git_branches()
  builtins.git_branches {
    attach_mappings = function(_, map)
      map("i", "<c-x>", actions.git_delete_branch)
      map("n", "<c-x>", actions.git_delete_branch)
      map("i", "<c-y>", M.set_prompt_to_entry_value)
      return true
    end,
  }
end

local cursor_menu = themes.get_cursor {
  -- previewer = true,
  shorten_path = false,
  border = true,
  layout_config = { height = 0.5, width = 0.75 },
}
function M.lsp_code_actions()
  builtins.lsp_code_actions(vim.tbl_deep_extend("keep", { layout_config = {
    width = 0.3,
  } }, cursor_menu))
end

function M.lsp_references()
  builtins.lsp_references(cursor_menu)
end

-- M.codelens_actions = function(opts)
--   local results_lsp = vim.lsp.codelens.get(0)
--
--   if not results_lsp or vim.tbl_isempty(results_lsp) then
--     print "No executable codelens actions found at the current buffer"
--     return
--   end
--
--   local idx = 1
--   local results = {}
--   local widths = {
--     idx = 0,
--     command_title = 0,
--     client_name = 0,
--   }
--
--   for _, result in ipairs(results_lsp) do
--     if result.command then
--       local entry = {
--         idx = idx,
--         command_title = result.command.title:gsub("\r\n", "\\r\\n"):gsub("\n", "\\n"):gsub("▶︎ ", ""),
--         command = result.command,
--         client_name = result.command.command,
--       }
--
--       for key, value in pairs(widths) do
--         widths[key] = math.max(value, strings.strdisplaywidth(entry[key]))
--       end
--
--       table.insert(results, entry)
--       idx = idx + 1
--     end
--   end
--
--   if #results == 0 then
--     print "No codelens actions available"
--     return
--   end
--
--   local displayer = entry_display.create {
--     separator = " ",
--     items = {
--       { width = widths.idx + 1 }, -- +1 for ":" suffix
--       { width = widths.command_title },
--       { width = widths.client_name },
--     },
--   }
--
--   local function make_display(entry)
--     return displayer {
--       { entry.idx .. ":", "TelescopePromptPrefix" },
--       { entry.command_title },
--       { entry.client_name, "TelescopeResultsComment" },
--     }
--   end
--
--   local execute_action = opts.execute_action
--     or function(action)
--       if action.edit or type(action.command) == "table" then
--         if action.edit then
--           vim.lsp.util.apply_workspace_edit(action.edit)
--         end
--         if type(action.command) == "table" then
--           vim.lsp.buf.execute_command(action.command)
--         end
--       else
--         vim.lsp.buf.execute_command(action)
--       end
--     end
--
--   pickers.new(opts, {
--     prompt_title = "LSP CodeLens Actions",
--     finder = finders.new_table {
--       results = results,
--       entry_maker = function(line)
--         return {
--           valid = line ~= nil,
--           value = line.command,
--           ordinal = line.idx .. line.command_title,
--           command_title = line.command_title,
--           idx = line.idx,
--           client_name = line.client_name,
--           display = make_display,
--         }
--       end,
--     },
--     attach_mappings = function(prompt_bufnr)
--       actions.select_default:replace(function()
--         local selection = action_state.get_selected_entry()
--         actions.close(prompt_bufnr)
--         local action = selection.value
--
--         execute_action(action)
--       end)
--
--       return true
--     end,
--     sorter = conf.generic_sorter(opts),
--   }):find()
-- end

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
  builtins.grep_string {
    path_display = { "shorten_path" },
    search = vim.fn.input "Grep String ❯ ",
  }
end

function M.grep_visual()
  builtins.grep_string {
    path_display = { "shorten_path" },
    search = require("utils").get_visual_selection(),
  }
end

function M.grep_cWORD()
  builtins.grep_string {
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

  builtins.grep_string(opts)
end

function M.installed_plugins()
  builtins.find_files {
    cwd = vim.fn.stdpath "data" .. "/site/pack/packer/",
  }
end

function M.project_search()
  builtins.find_files {
    previewer = false,
    layout_strategy = "vertical",
    cwd = require("nvim_lsp.util").root_pattern ".git"(vim.fn.expand "%:p"),
  }
end

function M.curbuf()
  -- local opts = themes.get_dropdown {
  local opts = {
    -- winblend = 10,
    previewer = false,
    shorten_path = false,
  }
  builtins.current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  builtins.help_tags {
    show_version = true,
  }
end

function M.live_grep_all()
  builtins.find_files {
    find_command = rg(false, false, false),
  }
end

function M.find_all_files()
  builtins.find_files {
    find_command = rg(false, false, true),
  }
end

function M.uiselect(topts)
  topts = topts or themes.get_cursor() -- get_dropdown
  local conf = require("telescope.config").values
  return function(items, opts, on_choice)
    opts = opts or {}
    local prompt = opts.prompt or ""
    local format_item = opts.format_item or tostring

    pickers.new(topts, {
      prompt_title = prompt,
      finder = finders.new_table {
        results = items, -- TODO:
        entry_maker = function(entry)
          local str = format_item(entry)
          -- local str = function(tbl)
          --   utils.dump(tbl)
          --   return format_item(tbl.value)
          -- end

          return {
            value = entry,
            display = str,
            ordinal = str,
          }
        end,
      },
      sorter = conf.generic_sorter(topts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          on_choice(selection.value)
        end)
        return true
      end,
    }):find()
  end
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

      local function modify_cwd(new_cwd)
        current_picker.cwd = new_cwd
        current_picker:refresh(opts.new_finder(new_cwd), { reset_prompt = true })
      end

      map("i", "-", function()
        modify_cwd(current_picker.cwd .. "/..")
      end)

      map("i", "~", function()
        modify_cwd(vim.fn.expand "~")
      end)

      local function modify_depth(mod)
        return function()
          opts.depth = opts.depth + mod

          local curr_picker = action_state.get_current_picker(prompt_bufnr)
          curr_picker:refresh(opts.new_finder(curr_picker.cwd), { reset_prompt = true })
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

  builtins.file_browser(opts)
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

  builtins.git_status(opts)
end

function M.git_commits()
  builtins.git_commits {
    winblend = 5,
  }
end

function M.find_only_certain_files(ignore)
  local cmd = vim.tbl_extend(rg(ignore, ignore, true), { "--type", vim.fn.input "Type: " })
  builtins.find_files {
    find_command = cmd,
  }
end

function M.projects()
  extensions.project.project {}
end

function M.yabs()
  extensions.yabs.tasks {}
end

return setmetatable(M, {
  __index = function(_, k)
    -- reloader()

    local builtin = builtins[k]
    if builtin then
      return builtin
    else
      return extensions[k]
    end
  end,
})
