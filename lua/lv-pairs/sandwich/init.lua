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

return M
