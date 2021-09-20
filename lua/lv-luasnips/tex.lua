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
local tbl_extend = vim.tbl_extend

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
local nw = function(k)
  return { trig = k, wordTrig = false }
end
local function re(arg)
  return { trig = arg, regTrig = true }
end
local function renw(arg)
  return { trig = arg, regTrig = true, wordTrig = false }
end

local trig_fns = {
  "sin",
  "cos",
  "tan",
  "cot",
  "csc",
  "sec",
}

local both_maps = {
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
  ["..."] = "ldots",
  ["=>"] = "implies",
  ["=<"] = "impliedby",
  ["->"] = "to",
  ["|->"] = "mapsto",
  ["!>"] = "mapsto",
  ["<>"] = "mapsto",
}
for k, v in pairs(both_maps) do -- FIXME: deal with already existing backslash (can use frontier set?)
  local lhs = ("number" == type(k)) and v or k
end

local math_maps = {
  -- TODO: Move some of these to both
  [">="] = "geq",
  ["<="] = "leq",
  ["!="] = "neq",
  ["~="] = "approx",
  ["~~"] = "sim",
  [">>"] = "gg",
  ["<<"] = "ll",
  ["xx"] = "times",
  ["**"] = "cdot",
  ["||"] = "mid",
  ["+-"] = "pm",
  ["-+"] = "mp",
  ["AA"] = "forall",
  ["qq"] = "quad",
  ["EE"] = "exists",
  ["RR"] = "R",
  ["NN"] = "N",
  ["ZZ"] = "Z",
  ["CC"] = "CC",
  ["QQ"] = "Q",
  ["OO"] = "Op",
  ["to"] = "to",
  ["&&"] = "&",
  "argmin",
  "argmax",
  ["part"] = "partial",
  ["inf"] = "infty", -- FIXME: why below here doesn't trigger? WHY DOES IT TRIGGER NOW!?
  "min",
  "max",
  "log",
  "exp",
}
list_extend(math_maps, trig_fns)
local intlike = {
  ["dint"] = { operator = "\\int", low = { i(1, "\\infty") }, upp = { i(2, "\\infty") } },
  ["dintr"] = { operator = "\\int", low = { i(1, "0") }, upp = { i(2, "\\infty") } },
  ["sum"] = { operator = "\\sum", low = { i(1, "n=0") }, upp = { i(3, "\\infty") } },
  ["sumi"] = { operator = "\\sum", low = { i(1, "i=0") }, upp = { i(3, "n") } },
  ["sumin"] = { operator = "\\sum", low = { i(1, "n \\in \\N") }, upp = {} },
  ["prod"] = { operator = "\\prod", low = { i(1, "n=0") }, upp = { i(3, "\\infty") } },
  ["prodi"] = { operator = "\\prod", low = { i(1, "i=0") }, upp = { i(3, "n") } },
  ["lim"] = { operator = "\\lim", low = { i(1, "n"), t "\\to", i(2, "\\infty") }, upp = {} },
  ["lim0"] = { operator = "\\lim", low = { i(1, "n"), t "\\to", i(2, "0") }, upp = {} },
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

local auto = {}
local snips = {}

----------------------------------------------------------------------
--                     Auto expanding Snippets                      --
----------------------------------------------------------------------
-- Derived snippets
for k, v in pairs(both_maps) do -- FIXME: deal with already existing backslash (can use frontier set?)
  local lhs = ("number" == type(k)) and v or k
  -- local lhs = "([^%\\])" .. v
  -- local lhs = "([%p])" .. v
  list_extend(auto, { ms(lhs, t("\\" .. v)) })
  list_extend(auto, { nms(lhs .. " ", t("$\\" .. v .. "$ ")) })
end

for k, v in pairs(math_maps) do
  local lhs = ("number" == type(k)) and v or k
  list_extend(auto, { ms(lhs, t("\\" .. v)) })
end
for k, v in pairs(trig_fns) do
  local lhs = ("number" == type(k)) and v or k
  list_extend(auto, { ms(re([[ar?c?]] .. lhs), t("\\arc\\" .. v)) })
end

list_extend(auto, {
  s("---- ", { t { "\\hline", "" } }),
  ms("cases ", { t { "\\begin{cases}", "" }, i(0), t { "", "\\end{cases}" } }),
  s("\\eq ", { t { "\\begin{equation}", "" }, i(0), t { "", "\\end{equation}" } }),
  ms("matt ", { t { "\\begin{matrix}", "" }, i(0), t { "", "\\end{matrix}" } }),
  ms("bmat ", { t { "\\begin{bmatrix}", "" }, i(0), t { "", "\\end{bmatrix}" } }),
  ms("pmat ", { t { "\\begin{pmatrix}", "" }, i(0), t { "", "\\end{pmatrix}" } }),
  s("\\ali ", { t { "\\begin{align*}", "" }, i(0), t { "", "\\end{align*}" } }),
  s("\\desc ", { t { "\\begin{description}", "\t\\item[" }, i(1), t { "]" }, i(0), t { "", "\\end{description}" } }),
  pa("$", "\\($0\\)"),
  nms("bf{", { t "\\textbf{", i(0) }),
  nms("it{", { t "\\textit{", i(0) }),
  ms("bf{", { t "\\mathbf{", i(0) }),
  ms("bb{", { t "\\mathbb{", i(0) }),
  ms("tt{", { t "\\text{", i(0) }),
  ms("rt{", { t "\\sqrt{", i(0) }),
  ms("st ", { t "\\text{s.t. } " }),
  ms("let ", { t "\\textbf{let } " }),
  ms("if ", { t "\\textbf{if } " }),
  ms("otherwise ", { t "\\textbf{ otherwise } " }),
  ms("else ", { t "\\textbf{ else } " }),
  ms("cal{", { t "\\mathcal{", i(0) }),
  ms(renw "__([^%s_])", { t "_{", sub(1), i(0), t "}" }),
  ms(renw "%^%^([^%s_])", { t "^{", sub(1), i(0), t "}" }),
  ms(nw "__ ", t "\\,"),
  ms(nw "____", t "\\quad"),
  ms(nw "\\,\\, ", t "\\quad"),
  ms(nw "\\quad\\, ", t "\\qquad"),
  ms(nw "\\quad\\quad ", t "\\qquad"),
  s("--", t "\\item"),
  ms(re [[(%S) ([%^_])]], { sub(1), sub(2) }), -- Remove extra ws sub/superscript
  ms(re [[([A-Za-z%}%]%)])(%d)]], { sub(1), t "_", sub(2) }), -- Auto subscript
  ms(re [[([A-Za-z%}%]%)]) ?_(%d%d)]], { sub(1), t "_{", sub(2), t "}" }), -- Auto escape subscript
  ms(re [[([A-Za-z%}%]%)]) ?_([%+%-] ?[%d%w])]], { sub(1), t "_{", sub(2), t "}" }), -- Auto escape superscript
  ms(re [[([A-Za-z%}%]%)]) ?_([%+%-]? ?%\%w+) ]], { sub(1), t "_{", sub(2), t "}" }), -- Auto escape superscript
  ms(re [[([A-Za-z%}%]%)]) ?%^ ?(%d%d)]], { sub(1), t "^{", sub(2), t "}" }), -- Auto escape superscript
  ms(re [[([A-Za-z%}%]%)]) ?%^([%+%-] ?[%d%w])]], { sub(1), t "^{", sub(2), t "}" }), -- Auto escape superscript
  ms(re [[([A-Za-z%}%]%)]) ?%^([%+%-]? ?%\%w+) ]], { sub(1), t "^{", sub(2), t "}" }), -- Auto escape superscript
  -- TODO: whitespace before and after operators
  -- TODO: line 203 and below
  -- ms(re [[(%w[ ,%)%]%}])to]], { sub(1), t "\\to" }),
  ms(re [[(%\?[%w%^]+),%.]], { t "\\vec{", sub(1), t "}" }),
  ms(re [[(%\?[%w%^]+)%.,]], { t "\\vec{", sub(1), t "}" }),
  ms(re [[(%\?[%w%^]+)%. ]], { t "\\dot{", sub(1), t "} " }),
  ms(re [[(%\?[%w%^]+)%.%.]], { t "\\ddot{", sub(1), t "}" }),
  ms(re [[(%\?[%w%^]+)^~]], { t "\\tilde{", sub(1), t "}" }),
  ms(re [[(%\?[%w%^]+)^bar]], { t "\\overline{", sub(1), t "}" }),
  ms(re [[(%\?%[%w%^]+)^hat]], { t "\\hat{", sub(1), t "}" }),
  ms("bar", { t "\\overline{", i(0), t "}" }),
  ms("hat", { t "\\hat{", i(0), t "}" }),
  -- TODO: bmatrix et al
  ms("//", { t "\\frac{", i(1), t "}{", i(0), t "}" }),
  ms(re "(%b{})/", { t "\\frac", sub(1), t "{", i(0), t "}" }),
  ms(re "(%\\?%w+)/", { t "\\frac{", sub(1), t "}{", i(0), t "}" }),
  ms("inn", t "\\in"),
  ms("notin", t "\\not\\in"),
  ms(re [[([%w^]+)sr]], { sub(1), t "^2", i(0) }),
  ms(re [[([%w^]+)cb]], { sub(1), t "^3", i(0) }),
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
  -- TODO: binomial
  ms(re "big(%S+) ", { t "\\big", sub(1), t " ", i(0), t " \\big", pairsub(1) }),
  ms(re "Big(%S+) ", { t "\\Big", sub(1), t " ", i(0), t " \\Big", pairsub(1) }),
  ms(re "bigg(%S+) ", { t "\\bigg", sub(1), t " ", i(0), t " \\bigg", pairsub(1) }),
  ms(re "Bigg(%S+) ", { t "\\Bigg", sub(1), t " ", i(0), t " \\Bigg", pairsub(1) }),
  ms(re "lr(%S+) ", { t "\\left", sub(1), t " ", i(0), t " \\right", pairsub(1) }),
  -- ms("\\{", { t "\\{", i(0), t " \\" }),
  -- s(nw "\\(", { t "\\(", i(0), t " \\" }),
  -- s(nw "\\[", { t { "\\[", "" }, i(0), t { "", "\\" } }),
  -- ms("\\|", { t "\\|", i(0), t " \\|" }),
  -- ms("\\langle ", { t "\\langle ", i(0), t " \\rangle" }),
  -- ms("\\lceil ", { t "\\lceil ", i(0), t " \\rceil" }),
  -- ms("\\lfloor ", { t "\\lfloor ", i(0), t " \\rfloor" }),
  ms("l<", { t "\\langle" }),
  ms("r>", { t "\\rangle" }),
  ms("lcl", { t "\\lceil" }),
  ms("rcl", { t "\\rceil" }),
  ms("rfl", { t "\\rfloor" }),
  -- ms("|", { t "|", i(0), t "|" }),
})
for k, v in pairs(intlike) do
  local snip = { t(v.operator .. "\\limits_{") }
  list_extend(snip, v.low)
  list_extend(snip, { t "}^{" })
  list_extend(snip, v.upp)
  list_extend(snip, { t "}", i(0) })
  list_extend(auto, { ms(k .. " ", snip) })
end

----------------------------------------------------------------------
--                         Manual Snippets:                         --
----------------------------------------------------------------------
local theorems = {
  "theorem",
  "definition",
  "lemma",
  "proof",
  "claim",
  "fact",
  "corollary",
}
list_extend(snips, {
  ms("partfrac", { t "\\frac{\\partial ", i(1), t "}{\\partial ", i(0), t "}" }),
})
for _, v in pairs(theorems) do
  list_extend(snips, {
    s(v, { t { "\\begin{" .. v .. "}", "" }, i(0), t { "", "\\end{" .. v .. "}" } }),
  })
end
for k, v in pairs(templates.tex) do
  list_extend(snips, { pa(k, v) })
end
list_extend(snips, {
  s("subsubsec", { t "subsubsection{", i(0), t "}" }),
})

return {
  snips = snips,
  auto = auto,
  math_maps = math_maps,
}
