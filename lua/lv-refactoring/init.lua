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

  noremap(
    "v",
    "<Leader>re",
    [[<Cmd>lua require('refactoring').refactor('Extract Function')<CR><ESC>]],
    { noremap = true, silent = true, expr = false }
  )
  noremap("n", "<Leader>re", require("lv-utils").operatorfunc_keys("extract_function", "<leader>re"), {})
  noremap(
    "v",
    "<Leader>rv",
    [[<Cmd>lua require('refactoring').refactor('Extract Variable')<CR><ESC>]],
    { noremap = true, silent = true, expr = false }
  )
  noremap("n", "<Leader>re", require("lv-utils").operatorfunc_keys("extract_variable", "<leader>rf"), {})
  noremap(
    "v",
    "<Leader>rf",
    [[<Cmd>lua require('lv-refactoring').telescope_refactors()<CR>]],
    { noremap = true, silent = true, expr = false }
  )
end

return M
