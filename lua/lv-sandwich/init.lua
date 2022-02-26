local M = {}

local recipes = {}
local function add_recipes(recipes_)
  vim.list_extend(recipes, recipes_)
  vim.g["sandwich#recipes"] = recipes
end
M.add_recipes = add_recipes
function M.add_recipe(recipe)
  add_recipes { recipe }
end

local insertlocal = utils.fn.sandwich.util.insertlocal
local function add_local_recipes(recipes_)
  local localrecipes = vim.b.sandwich_recipes
  if localrecipes == nil then
    localrecipes = vim.deepcopy(recipes)
  end
  vim.list_extend(localrecipes, recipes_)
  vim.b.sandwich_recipes = localrecipes
end
M.add_local_recipes = add_local_recipes
function M.add_local_recipe(recipe)
  add_local_recipes { recipe }
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

  local add_recipe = M.add_recipe
  -- TODO: use inline_text_input for sandwich function
  --   M.add_recipe {
  --     buns = { "lua require('lv-sandwich').fname()", '")"' },
  --     expr = true,
  --     kind = { "add", "replace" },
  --     action = { "add" },
  --     input = { "f" },
  --   }
  add_recipes {
    {
      external = { "ic", "ac" },
      noremap = false,
      kind = { "delete", "replace", "query" },
      input = { "c" },
    },
    {
      external = { "ii", "ai" },
      noremap = false,
      kind = { "delete", "replace", "query" },
      input = { "i" },
    },
    {
      external = { "if", "af" },
      noremap = false,
      kind = { "delete", "replace", "query" },
      input = { "af" },
    },
    -- {
    --   buns = { [[']], [[']] },
    --   quoteescape = true,
    --   expand_range = false,
    --   nesting = false,
    --   input = { "q" },
    -- },
    -- {
    --   buns = { [["]], [["]] },
    --   quoteescape = true,
    --   expand_range = false,
    --   nesting = false,
    --   input = { "Q" },
    -- },
    {
      buns = { "['`\"]", "['`\"]" },
      kind = { "delete", "replace", "query" },
      quoteescape = true,
      expand_range = false,
      nesting = false,
      input = { "q" },
      regex = 1,
    },
  }

  local map = mappings.sile
  map("x", "is", "<Plug>(textobj-sandwich-query-i)")
  map("x", "as", "<Plug>(textobj-sandwich-query-a)")
  map("o", "is", "<Plug>(textobj-sandwich-query-i)")
  map("o", "as", "<Plug>(textobj-sandwich-query-a)")
  map("x", "iq", "isq")
  map("x", "aq", "asq")
  map("o", "iq", "isq")
  map("o", "aq", "asq")
end

function M.fname()
  vim.fn["operator#sandwich#show"]()

  vim.fn["operator#sandwich#quench"]()
end

return M
