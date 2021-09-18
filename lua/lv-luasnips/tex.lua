-- local F = require "F"
-- local L = require("pl.utils").string_lambda

-- some shorthands...
local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local pa = ls.parser.parse_snippet
local types = require "luasnip.util.types"
local templates = require "lv-luasnips.templates"
local nl = t { "", "" }
local list_extend = vim.list_extend

local rec_ls
rec_ls = function()
  return sn(nil, {
    c(1, {
      -- important!! Having the sn(...) as the first choice will cause infinite recursion.
      t { "" },
      -- The same dynamicNode as in the snippet (also note: self reference).
      sn(nil, { t { "", "\t\\item " }, i(1), d(2, rec_ls, {}) }),
    }),
  })
end

local function re(arg)
  return { trig = arg, regTrig = true }
end

local function fmt(fn, ipairs)
  if ipairs == nil then
    ipairs = {}
  end
  return f(function(args)
    return string.format(unpack(fn(args[1].captures, args[1].trigger, args)))
  end, ipairs)
end
local sub = function(ix)
  return f(function(args)
    return string.format("%s", args[1].captures[ix])
  end, {})
end
local con = function(fn)
  return { condition = fn }
end
local mathmode_ = vim.fn["vimtex#syntax#in_mathzone"]
local mathmode = {
  condition = function()
    return mathmode_() ~= 0
  end,
}
local nonmathmode = {
  condition = function()
    return mathmode_() == 0
  end,
}
local ms = function(lhs, rhs)
  return s(lhs, rhs, mathmode)
end
local nms = function(lhs, rhs)
  return s(lhs, rhs, nonmathmode)
end
local ff = function(str)
  return f(function(args)
    local c1 = args[1].captures[1]
    local c2 = args[1].captures[2]
    local c3 = args[1].captures[3]
    local c4 = args[1].captures[4]
    return L(str)
  end, {})
end

local trig_fns = {
  "sin",
  "cos",
  "tan",
  "cot",
  "csc",
  "sec",
}
local fns = {
  "min",
  "max",
  "argmin",
  "argmax",
  "log",
  "exp",
}
local autosyms = {
  "alpha",
  "beta",
  "gamma",
  "delta",
  "epsilon",
  "zeta",
  "eta",
  "theta",
  "iota",
  "kappa",
  "lambda",
  "mu",
  "nu",
  "xi",
  "omicron",
  "pi",
  "rho",
  "sigma",
  "tau",
  "upsilon",
  "phi",
  "chi",
  "psi",
  "omega",
  "Alpha",
  "Beta",
  "Gamma",
  "Delta",
  "Epsilon",
  "Zeta",
  "Eta",
  "Theta",
  "Iota",
  "Kappa",
  "Lambda",
  "Mu",
  "Nu",
  "Xi",
  "Omicron",
  "Pi",
  "Rho",
  "Sigma",
  "Tau",
  "Upsilon",
  "Phi",
  "Chi",
  "Psi",
  "Omega",
  "nabla",
  "infty",
  "iff",
}
list_extend(autosyms, trig_fns)
list_extend(autosyms, fns)
local symmaps_table = {
  ["..."] = "ldots",
  ["=>"] = "implies",
  ["=<"] = "impliedby",
  [">="] = "geq",
  ["<="] = "leq",
  ["!="] = "neq",
  ["~="] = "approx",
  ["~~"] = "sim",
  [">>"] = "gg",
  ["<<"] = "ll",
  ["xx"] = "times",
  ["**"] = "cdot",
  ["->"] = "to",
  ["|->"] = "mapsto",
  ["!>"] = "mapsto",
  ["<>"] = "mapsto",
  ["||"] = "mid",
  ["+-"] = "pm",
  ["-+"] = "mp",
  ["AA"] = "forall",
  ["EE"] = "exists",
  ["qq"] = "quad",

  ["RR"] = "R",
  ["QQ"] = "Q",
  ["ZZ"] = "Z",
  ["NN"] = "N",
  ["CC"] = "C",

  ["ooo"] = "infty",
}

local tex_pairs = {
  [" "] = { "(", ")" },
  ["("] = { "(", "" },
  ["["] = { "[", "" },
  ["{"] = { "\\{", "\\" },
  ["|"] = { "|", "|" },
  ["<"] = { "<", ">" },
  ["a"] = { "\\langle", "\\rangle" },
}

local tex_env = {
  nonmathmode = {
    ["\\eq"] = "equation",
    ["\\it"] = { name = "itemize", body = { t "\t\\item ", i(1) } },
    ["\\en"] = { name = "enumerate", body = { t "\t\\item ", i(1) } },
    ["\\desc"] = { name = "description", body = { t "\t\\item[", i(1), t "]", i(2) } },
  },
  mathmode = {
    ["bmat"] = "bmatrix",
    ["pmat"] = "pmatrix",
    ["cases"] = "cases",
  },
}

local tex_operators = {
  ["dint"] = { operator = "\\int", low = { i(1, "\\infty") }, upp = { i(2, "\\infty") } },
  ["sum"] = { operator = "\\sum", low = { i(1, "n"), t "=", i(2, "0") }, upp = { i(3, "\\infty") } },
  ["prod"] = { operator = "\\prod", low = { i(1, "n"), t "=", i(2, "1") }, upp = { i(3, "\\infty") } },
  ["lim"] = { operator = "\\lim", low = { i(1, "n"), t "\\to", i(2, "\\infty") }, upp = {} },
}

local auto = {
  pa("$", "\\($0\\)"),
  pa("\\(", "\\( $0 \\"),
  pa("it{", "\\textit{$0"),
  pa("bf{", "\\textbf{$0"),
  ms("tt ", { t "\\text{", i(0), t "}" }),
  ms("sq", { t "\\sqrt{", i(0), t "}" }),
  ms("__", { t "_{", i(0), t "}" }),
  s("--", { t "\\item" }),
  s(re [[(%w+)%.%.e]], {
    -- ff "\begin{{{c1}}}",
    fmt(function(cap)
      return { [[\begin{%s}]], cap[1] }
    end),
    nl,
    i(0),
    nl,
    fmt(function(cap)
      return { [[\end{%s}]], cap[1] }
    end),
  }),
  ms(re [[(%S) ([%^_])]], { sub(1), sub(2) }), -- Remove extra ws sub/superscript
  ms(re [[([A-Za-z%}%]%)])(%d)]], { sub(1), t "_", sub(2) }), -- Auto subscript
  ms(re [[([A-Za-z%}%]%)]) ?_(%d%d)]], { sub(1), t "_{", sub(2), t "}" }), -- Auto escape subscript
  ms(re [[([A-Za-z%}%]%)]) ?%^ ?(%d%d)]], { sub(1), t "^{", sub(2), t "}" }), -- Auto escape superscript
  ms(re [[([A-Za-z%}%]%)]) ?%^([%+%-]? ?[%w]) ]], { sub(1), t "^{", sub(2), t "}" }), -- Auto escape superscript
  ms(re [[([A-Za-z%}%]%)]) ?%^([%+%-]? ?%\%w+) ]], { sub(1), t "^{", sub(2), t "}" }), -- Auto escape superscript
  -- TODO: whitespace before and after operators
  -- TODO: fraction
  -- TODO: line 203 and below
  ms(re [[(%w[ ,%)%]%}])to]], { sub(1), t "\\to" }),
  ms(re [[([%w%^]+),%.]], { t "\\vec{", sub(1), t "}" }),
  ms(re [[([%w%^]+)%.,]], { t "\\vec{", sub(1), t "}" }),
  ms(re [[([%w%^]+)~]], { t "\\tilde{", sub(1), t "}" }),
  ms(re [[([%w%^]+)%. ]], { t "\\dot{", sub(1), t "} " }),
  ms(re [[([%w%^]+)%.%.]], { t "\\ddot{", sub(1), t "}" }),
  ms(re [[([%w^]+)bar]], { t "\\overline{", sub(1), t "}" }),
  ms("bar", { t "\\overline{", i(0), t "}" }),
  ms(re [[([%w%^]+)hat]], { t "\\hat{", sub(1), t "}" }),
  ms("hat", { t "\\hat{", i(0), t "}" }),
  -- TODO: bmatrix et al
  ms("part", { t "\\frac{\\partial ", i(1), t "}{\\partial ", i(0), t "}" }),
  ms("//", { t "\\frac{", i(1), t "}{", i(1), t "}", i(0) }),
  ms(re "(%b{})/", { t "\\frac", sub(1), t "{", i(1), t "}", i(0) }),
  ms(re "(%\\?%w+)/", { t "\\frac{", sub(1), t "}{", i(1), t "}", i(0) }),
  ms("inn", t "\\in"),
  ms("notin", t "\\not\\in"),
  ms(re [[([%w^]+)sr]], { sub(1), t "^2", i(0) }),
  ms(re [[([%w^]+)cb]], { sub(1), t "^3", i(0) }),
  -- ms(
  --   re [[([A-Za-z])([A-Za-z])([A-Za-z])]],
  --   f(function(arg)
  --     local cap = arg[1].captures
  --     if cap[2] == cap[3] then
  --       return string.format("%s_%s", cap[1], cap[2])
  --     else
  --       return arg[1].trigger
  --     end
  --   end, {})
  -- ),

  -- TODO: binomial

  ms("norm", { t "\\|", i(1), t "\\|", i(0) }),
  nms("mk", { t "$", i(1), t "$", i(0) }),
  nms("dm", { t { "\\[", "" }, i(1), t { "", "\\]" }, i(0) }),
  ms(re [[([%w%^]+)td]], { sub(1), t "^{", i(1), t "}", i(0) }),
  ms(re [[([%w%^]+)__]], { sub(1), t "_{", i(1), t "}", i(0) }),
}

local snips = {
  s("theorem", { t "\\begin{theorem}\n", i(0), t "\n\\end{theorem}" }),
  s("lemma", { t "\\begin{lemma}\n", i(0), t "\n\\end{lemma}" }),
  s("proof", { t "\\begin{proof}\n", i(0), t "\n\\end{proof}" }),
  s("claim", { t "\\begin{proof}\n", i(0), t "\n\\end{proof}" }),
}

-- Derived snippets
local autosyms_math = {}
local autosyms_open = {}
for j, v in ipairs(autosyms) do -- FIXME: deal with already existing backslash (can use frontier set?)
  -- local lhs = "([^%\\])" .. v
  -- local lhs = "([%p])" .. v
  local lhs = v
  autosyms_math[j] = ms(re(lhs), t("\\" .. v))
  -- autosyms_open[j] = nms(re(lhs), t("$\\" .. v .. "$"))
end
list_extend(auto, autosyms_math)
list_extend(auto, autosyms_open)

for k, v in pairs(symmaps_table) do
  list_extend(auto, { ms(k, t("\\" .. v)) })
end

for _, v in ipairs(trig_fns) do
  list_extend(auto, { ms(re([[ar?c?]] .. v), t("\\arc\\" .. v)) })
end

for k, v in pairs(tex_pairs) do
  list_extend(auto, { ms("lr" .. k, { t("\\left" .. v[1]), i(1), t("\\right" .. v[2]), i(0) }) })
end

for k, v in pairs(tex_operators) do
  local snip = { t(v.operator .. "\\limits_{") }
  for _, _v in ipairs(v.low) do
    list_extend(snip, { _v })
  end
  list_extend(snip, { t "}^{" })
  for _, _v in ipairs(v.upp) do
    list_extend(snip, { _v })
  end
  list_extend(snip, { t "}", i(0) })
  list_extend(auto, { ms(k, snip) })
end

local tex_env_snip = function(name, body)
  local snip = { t { "\\begin{" .. name .. "} ", "" } }
  list_extend(snip, body)
  list_extend(snip, { t { "", "\\end{" .. name .. "}" }, i(0) })
  return snip
end

for k, v in pairs(tex_env.nonmathmode) do
  if type(v) == "string" then
    list_extend(auto, { nms(k, tex_env_snip(v, { i(1) })) })
  else
    list_extend(auto, { nms(k, tex_env_snip(v.name, v.body)) })
  end
end
for k, v in pairs(tex_env.mathmode) do
  if type(v) == "string" then
    list_extend(auto, { ms(k, tex_env_snip(v, { i(1) })) })
  else
    list_extend(auto, { ms(k, tex_env_snip(v.name, v.body)) })
  end
end

for k, v in pairs(templates.tex) do
  list_extend(snips, { pa(k, v) })
end

return {
  snips = snips,
  auto = auto,
}
