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
    -- auto_select = true,
    -- insert = false,
    map_char = {
      all = "(",
      tex = "{",
    },
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

npairs.add_rules {
  R("%", "%", "lua"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
  R("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node { "function" }),
  -- R("if ", " then\nend", "lua"):with_pair(ts_conds.is_not_ts_node { "comment", "string" }),
  -- R("for ", " in", "lua"):with_pair(ts_conds.is_not_ts_node { "comment", "string" }),
  -- R("in ", " do", "lua"):with_pair(ts_conds.is_not_ts_node { "comment", "string" }),
  -- R("do ", " end", "lua"):with_pair(ts_conds.is_not_ts_node { "comment", "string" }),
}

-- press % => %% is only inside comment or string
local texmods = {
  ["\\left"] = "\\right",
  ["\\big"] = "\\big",
  ["\\bigg"] = "\\bigg",
  ["\\Big"] = "\\Big",
  ["\\Bigg"] = "\\Bigg",
}
local texpairs = {
  ["\\("] = "\\)",
  ["\\["] = "\\]",
  ["\\{"] = "\\}",
  ["\\|"] = "\\|",
  ["\\langle "] = "\\rangle",
  ["\\lceil "] = "\\rceil",
  ["\\lfloor "] = "\\rfloor",
}
local basicpairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
}
for lm, rm in pairs(texmods) do
  for lp, rp in pairs(texpairs) do
    npairs.add_rule(R(lm .. lp, " " .. rm .. rp, "tex"))
  end
  for lp, rp in pairs(basicpairs) do
    npairs.add_rule(R(lm .. lp, " " .. rm .. rp, "tex"))
  end
end
for lp, rp in pairs(texpairs) do
  -- npairs.add_rule(R(lp, " " .. rp, "tex"))
  npairs.add_rule(R(lp, rp, "tex"))
end

-- lua utils.dump(MPairs.state.rules)
