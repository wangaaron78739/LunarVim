local M = {}

local function telescope_refactor_helper(prompt_bufnr)
  local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
  require("telescope.actions").close(prompt_bufnr)
  require("refactoring").refactor(content.value)
end

function M.telescope_refactors()
  require("telescope.pickers").new({}, {
    prompt_title = "Telescope refactors",
    finder = require("telescope.finders").new_table {
      results = require("refactoring").get_refactors(),
    },
    sorter = require("telescope.config").values.generic_sorter {},
    attach_mappings = function(_, map)
      map("i", "<CR>", telescope_refactor_helper)
      map("n", "<CR>", telescope_refactor_helper)
      return true
    end,
  }):find()
end

function M.setup()
  local refactor = require "refactoring"
  refactor.setup()
  local wk = require "which-key"

  local norm = {
    mode = "n",
    prefix = "<leader>r",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
  }

  local visu = {
    mode = "v",
    prefix = "<leader>r",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
  }
  local function helper(name)
    return {
      string.format([[<cmd>lua require('refactoring').refactor('%s')<CR><ESC>]], name),
      name,
    }
  end
  wk.register({
    e = helper "Extract Function",
    v = helper "Extract Variable",
    i = helper "Inline Variable",
    -- TODO: use popfix/nui.nvim to get a code_actions style popup
    f = {
      [[<cmd>lua require('lv-refactoring').telescope_refactors()<CR>]],
      "Refactors",
    },
  }, visu)

  wk.register({
    e = {
      require("lv-utils").operatorfunc_keys("extract_function", "<leader>re"),
      "Extract function",
    },
    v = {
      require("lv-utils").operatorfunc_keys("extract_variable", "<leader>rv"),
      "Extract variable",
    },
  }, norm)
end

return M
