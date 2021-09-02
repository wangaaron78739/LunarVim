-- if not package.loaded['nvim-autopairs'] then
--   return
-- end
local npairs = require "nvim-autopairs"
local R = require "nvim-autopairs.rule"

-- if package.loaded["compe"] then
if O.plugin.cmp then
  require("nvim-autopairs.completion.cmp").setup {
    map_cr = true, --  map <CR> on insert mode
    map_complete = true, -- it will auto insert `(` after select function or method item
  }
end

npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string" }, -- it will not add pair on that treesitter node
    javascript = { "template_string" },
    java = false, -- don't check treesitter on java
  },
}

require("nvim-treesitter.configs").setup { autopairs = { enable = true } }

local ts_conds = require "nvim-autopairs.ts-conds"

-- press % => %% is only inside comment or string
npairs.add_rules {
  R("%", "%", "lua"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
  R("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node { "function" }),
  -- TODO: maybe should just make this into a luasnip autosnippet
  R("\\left(", " \\right)", "tex"),
  R("\\left[", " \\right]", "tex"),
  R("\\left{", " \\right}", "tex"),
  R("\\left|", " \\right|", "tex"),
  R("\\left\\|", " \\right\\|", "tex"),
  R("\\(", " \\)", "tex"),
  R("\\[", " \\]", "tex"),
  R("\\{", " \\}", "tex"),
  R("\\|", " \\|", "tex"),
  -- R("\\begin", "\\end", "tex"):use_regex(true),
  -- Rule("\\left[", " \\right]", "tex"),
}

utils.dump(MPairs.state.rules)
