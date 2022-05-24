local M = {}

function M.setup()
  local refactor = require "refactoring"
  require("telescope").load_extension "refactoring"
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
      -- string.format([[<esc><cmd>lua require('refactoring').refactor('%s')<CR>]], name),
      function()
        vim.cmd "stopinsert"
        refactor.refactor(name)
      end,
      name,
    }
  end
  wk.register({
    e = helper "Extract Function",
    v = helper "Extract Variable",
    i = helper "Inline Variable",
    r = {
      "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
      "Refactors",
    },
    pv = {
      function()
        refactor.debug.print_var {}
      end,
      -- "<cmd>lua require('refactoring').debug.print_var({})<CR>",
      "Printf Var",
    },
  }, visu)

  wk.register({
    e = {
      require("lv-utils").operatorfuncV_keys("extract_function", "<leader>re"),
      "Extract function",
    },
    v = {
      require("lv-utils").operatorfunc_keys("extract_variable", "<leader>rv"),
      "Extract variable",
    },
    r = {
      "<cmd>lua require('refactoring').debug.printf({below = false})<CR>",
      "Refactoring.nvim Debug",
    },
    c = {
      "<cmd>lua require('refactoring').debug.cleanup({})<CR>",
      "Refactoring.nvim Cleanup",
    },
  }, norm)
end

return M
