local F = require "F"
local L = require("pl.utils").string_lambda
local templates = require "lv-luasnips.templates"

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
local sub = function(j)
  return f(function(args)
    return string.format("%s", args[1].captures[j])
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
  ["..."] = "ldots", -- dots
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
  ["RR"] = "R",
  ["NN"] = "N",
  ["ZZ"] = "Z",
  ["CC"] = "C",
  ["OO"] = "Op",
}
local pairsubs = setmetatable({ -- Autopairs will complete the closing for most of these
  ["{"] = "", -- "}",
  ["["] = "", -- "]",
  ["("] = "", -- ")",
  ["\\{"] = "\\", -- "\\}",
  ["\\["] = "\\", -- "\\]",
  ["\\("] = "\\", -- "\\)",
}, {
  __index = function(tbl, key)
    return key
  end,
})
local pairsub = function(j)
  return f(function(args)
    return string.format("%s", pairsubs[args[1].captures[j]])
  end, {})
end

local nw = function(k)
  return { trig = k, wordTrig = false }
end

local auto = {
  ms("cases ", { t { "\\begin{cases}", "" }, i(0), t { "", "\\end{cases}" } }),
  s("\\eq ", { t { "\\begin{equation}", "" }, i(0), t { "", "\\end{equation}" } }),
  s("\\ali ", { t { "\\begin{equation}", "" }, i(0), t { "", "\\end{equation}" } }),
  s("\\desc ", { t { "\\begin{description}", "\t\\item[" }, i(1), t { "]" }, i(0), t { "", "\\end{description}" } }),
  pa("$", "\\($0\\)"),
  -- pa("\\(", "\\( $0 \\"),
  nms("bf{", { t "\\textbf{", i(0) }),
  nms("it{", { t "\\textit{", i(0) }),
  ms("sq", { t "\\sqrt{", i(0), t "}" }),
  ms("st ", { t "\\text{s.t.}" }),
  ms("let", { t "\\textbf{let}" }),
  ms("if", { t "\\textbf{if}" }),
  ms("otherwise", { t "\\textbf{otherwise}" }),
  ms("else", { t "\\textbf{else}" }),
  ms("bf{", { t "\\mathbf{", i(0) }),
  ms("bb{", { t "\\mathbb{", i(0) }),
  ms("cal{", { t "\\mathcal{", i(0) }),
  ms(nw "__", { t "_{", i(0), t "}" }),
  s("--", { t "\\item" }),
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
  ms(re [[([%w%^]+)^bar]], { t "\\overline{", sub(1), t "}" }),
  ms("bar", { t "\\overline{", i(0), t "}" }),
  ms(re [[([%w%^]+)^hat]], { t "\\hat{", sub(1), t "}" }),
  ms("hat", { t "\\hat{", i(0), t "}" }),
  -- TODO: bmatrix et al
  ms("part", { t "\\frac{\\partial ", i(1), t "}{\\partial ", i(0), t "}" }),
  ms("//", { t "\\frac{", i(1), t "}{", i(0), t "}" }),
  ms(re "(%b{})/", { t "\\frac", sub(1), t "{", i(0), t "}" }),
  ms(re "(%\\?%w+)/", { t "\\frac{", sub(1), t "}{", i(0), t "}" }),
  ms("inn", t "\\in"),
  ms("notin", t "\\not\\in"),
  ms("sr", t "^2"),
  ms("cb", t "^3"),
  ms(
    re [[([A-Za-z])([A-Za-z])([A-Za-z])]],
    f(function(arg)
      local cap = arg[1].captures
      if cap[2] == cap[3] then
        return string.format("%s_%s", cap[1], cap[2])
      else
        return arg[1].trigger
      end
    end, {})
  ),
  ms("dint", { t "\\int_{", i(1, "\\infty"), t "}^{", i(2, "\\infty"), t "}" }),
  -- TODO: binomial
  ms(re "big(%S+) ", { t "\\big", sub(1), t " ", i(0), t " \\big", pairsub(1) }),
  ms(re "Big(%S+) ", { t "\\Big", sub(1), t " ", i(0), t " \\Big", pairsub(1) }),
  ms(re "bigg(%S+) ", { t "\\bigg", sub(1), t " ", i(0), t " \\bigg", pairsub(1) }),
  ms(re "Bigg(%S+) ", { t "\\Bigg", sub(1), t " ", i(0), t " \\Bigg", pairsub(1) }),
  ms(re "lr(%S+) ", { t "\\left", sub(1), t " ", i(0), t " \\right", pairsub(1) }),
  ms("\\{", { t "\\{", i(0), t " \\" }),
  s(nw "\\(", { t "\\(", i(0), t " \\" }),
  s(nw "\\[", { t { "\\[", "" }, i(0), t { "", "\\" } }),
  ms("\\|", { t "\\|", i(0), t " \\|" }),
  ms("\\langle ", { t "\\langle ", i(0), t " \\rangle" }),
  ms("\\lceil ", { t "\\lceil ", i(0), t " \\rceil" }),
  ms("\\lfloor ", { t "\\lfloor ", i(0), t " \\rfloor" }),
  ms("l<", { t "\\langle" }),
  ms("r>", { t "\\rangle" }),
  ms("lcl", { t "\\lceil" }),
  ms("rcl", { t "\\rceil" }),
  ms("rfl", { t "\\rfloor" }),
}

-- Derived snippets
local autosyms_math = {}
local autosyms_open = {}
for j, v in ipairs(autosyms) do -- FIXME: deal with already existing backslash (can use frontier set?)
  -- local lhs = "([^%\\])" .. v
  -- local lhs = "([%p])" .. v
  local lhs = v
  autosyms_math[j] = ms(re(lhs), t("\\" .. v))
  autosyms_open[j] = nms(re(lhs), t("$\\" .. v .. "$"))
end
list_extend(auto, autosyms_math)
list_extend(auto, autosyms_open)
for k, v in pairs(symmaps_table) do
  list_extend(auto, { ms(k, t("\\" .. v)) })
end
for _, v in ipairs(trig_fns) do
  list_extend(auto, { ms(re([[ar?c?]] .. v), t("\\arc\\" .. v)) })
end

local theorems = {
  "theorem",
  "definition",
  "lemma",
  "proof",
  "claim",
  "fact",
  "corollary",
}
local snips = {}
for _, v in pairs(theorems) do
  list_extend(snips, {
    s(v, { t { "\\begin{" .. v .. "}", "" }, i(0), t { "", "\\end{" .. v .. "}" } }),
  })
end
for k, v in pairs(templates.tex) do
  list_extend(snips, { pa(k, v) })
end

return {
  snips = snips,
  auto = auto,
}
