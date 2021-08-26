local M = {}
function M.setup()
  require("luasnip").config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    region_check_events = "CursorMoved,InsertEnter",
    delete_check_events = "InsertLeave",
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
  }

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
  local types = require "luasnip.util.types"

  -- TODO: port Latex auto snippets
  ls.autosnippets = {
    all = {
      s("xxx", {
        t "autosnippet",
      }),
    },
  }
end
return M
