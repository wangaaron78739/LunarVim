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

local mainnotestemplate = {
  t "test"
}

return {
  snips = {
    s("ls", {
      t { "\\begin{itemize}", "\t\\item " },
      i(1),
      d(2, rec_ls, {}),
      t { "", "\\end{itemize}" },
      i(0),
    }),
    s("\\theorem ", { t "\\begin{theorem}\n", i(0), t "\n\\end{theorem}" }),
    s("\\lemma ", { t "\\begin{lemma}\n", i(0), t "\n\\end{lemma}" }),
    s("\\proof ", { t "\\begin{proof}\n", i(0), t "\n\\end{proof}" }),
    s("\\claim ", { t "\\begin{proof}\n", i(0), t "\n\\end{proof}" }),
    s("mainnotestemplate", mainnotestemplate)
  },
  auto = {
    s("$", { t "\\(", i(0), t "\\)" }),
    s("\\(", { t "\\( ", i(0), t " \\" }),
    s("\\it ", { t "\\textit{", i(0), t "}" }),
    s("\\bf ", { t "\\textbf{", i(0), t "}" }),
    s("\\eq ", { t "\\begin{equation}\n", i(0), t "\n\\end{equation}" }),
    s("\\ali ", { t "\\begin{equation}\n", i(0), t "\n\\end{equation}" }),
    -- s(re [[e_(%w+) ]], {
    s(re [[(%w+)%.%.e]], {
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
    s("--", { t "\\item " }),
    -- The last entry of args passed to the user-function is the surrounding snippet.
    s(
      re [[hello(%w+) ]],
      f(function(args)
        return "Triggered with " .. args[1].trigger .. "."
      end, {})
    ),
    -- It's possible to use capture-groups inside regex-triggers.
    s(
      { trig = "b(%d)", regTrig = true },
      f(function(args)
        return "Captured Text: " .. args[1].captures[1] .. "."
      end, {})
    ),
  },
}
