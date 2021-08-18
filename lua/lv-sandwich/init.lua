local M = {}

local recipes = {}
function M.add_recipe(recipe)
  vim.list_extend(recipes, { recipe })
  vim.g["sandwich#recipes"] = recipes
end
function M.add_recipes(recipes_)
  vim.list_extend(recipes, recipes_)
  vim.g["sandwich#recipes"] = recipes_
end

function M.preconf()
  vim.g.sandwich_no_default_key_mappings = 1
  vim.g.operator_sandwich_no_default_key_mappings = 1
  vim.g.textobj_sandwich_no_default_key_mappings = 1
end

function M.config()
  vim.cmd "runtime macros/sandwich/keymap/surround.vim"

  -- vim.tbl_extend(recipes, vim.g["sandwich#recipes"])
  recipes = vim.g["sandwich#recipes"]

  -- TODO: use inline_text_input for sandwich function
  --   M.add_recipe {
  --     buns = { "lua require('lv-sandwich').fname()", '")"' },
  --     expr = true,
  --     kind = { "add", "replace" },
  --     action = { "add" },
  --     input = { "f" },
  --   }
  M.add_recipe {
    external = { "ic", "ac" },
    noremap = false,
    kind = { "delete", "replace", "query" },
    input = { "c" },
  }
  M.add_recipe {
    external = { "ii", "ai" },
    noremap = false,
    kind = { "delete", "replace", "query" },
    input = { "i" },
  }
  M.add_recipe {
    external = { "if", "af" },
    noremap = false,
    kind = { "delete", "replace", "query" },
    input = { "af" },
  }

  vim.api.nvim_command [[
      xmap is <Plug>(textobj-sandwich-query-i)
      xmap as <Plug>(textobj-sandwich-query-a)
      omap is <Plug>(textobj-sandwich-query-i)
      omap as <Plug>(textobj-sandwich-query-a)
  ]]
end

function M.fname()
  vim.fn["operator#sandwich#show"]()

  vim.fn["operator#sandwich#quench"]()
end

return M
