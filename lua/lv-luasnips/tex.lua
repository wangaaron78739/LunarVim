local F = require "F"
local L = require("pl.utils").string_lambda

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
}
local autosyms_math = {}
local autosyms_open = {}
for j, v in ipairs(autosyms) do
  autosyms_math[j] = ms(v, t("\\" .. v))
  autosyms_open[j] = nms(v, t("$\\" .. v .. "$"))
end
local symmaps_table = {
  ["..."] = "dots",
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
}

local auto = {
  s("$", { t "\\(", i(0), t "\\)" }),
  s("\\(", { t "\\( ", i(0), t " \\" }),
  s("\\it ", { t "\\textit{", i(0), t "}" }),
  s("\\bf ", { t "\\textbf{", i(0), t "}" }),
  s("\\eq ", { t "\\begin{equation}\n", i(0), t "\n\\end{equation}" }),
  s("\\ali ", { t "\\begin{equation}\n", i(0), t "\n\\end{equation}" }),
  s("--", { t "\\item " }),
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
}
list_extend(auto, autosyms_math)
list_extend(auto, autosyms_open)
for k, v in pairs(symmaps_table) do
  utils.dump { k, v }
  list_extend(auto, { ms(k, t("\\" .. v)) })
end

local snips = {
  s("\\theorem ", { t "\\begin{theorem}\n", i(0), t "\n\\end{theorem}" }),
  s("\\lemma ", { t "\\begin{lemma}\n", i(0), t "\n\\end{lemma}" }),
  s("\\proof ", { t "\\begin{proof}\n", i(0), t "\n\\end{proof}" }),
  s("\\claim ", { t "\\begin{proof}\n", i(0), t "\n\\end{proof}" }),
}
return {
  snips = snips,
  auto = auto,
}
