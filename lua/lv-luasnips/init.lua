local M = {}
function M.setup()
  require("luasnip").config.set_config {
    history = true,
    enable_autosnippets = true,
    -- updateevents = "TextChanged,TextChangedP,TextChangedI",
    -- region_check_events = "CursorMoved,CursorHold,InsertEnter",
    -- delete_check_events = "TextChangedI,TextChangedP,TextChanged",
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
  }

  local map = vim.api.nvim_set_keymap
  --  "<Plug>luasnip-expand-or-jump"
  -- map("i", "<C-h>", "<Plug>luasnip-expand-snippet", { silent = true })
  -- map("s", "<C-h>", "<Plug>luasnip-expand-snippet", { silent = true })
  map("i", "<C-j>", "<Plug>luasnip-jump-next", { silent = true })
  map("s", "<C-j>", "<Plug>luasnip-jump-next", { silent = true })
  map("i", "<C-k>", "<Plug>luasnip-jump-prev", { silent = true })
  map("s", "<C-k>", "<Plug>luasnip-jump-prev", { silent = true })
  map("i", "<C-h>", "<Plug>luasnip-next-choice", { silent = true })
  map("s", "<C-h>", "<Plug>luasnip-next-choice", { silent = true })

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
  local nlt = function(line)
    return t { "", line }
  end
  local tnl = function(line)
    return t { line, "" }
  end

  ls.snippets = {
    -- tex = require("lv-luasnips.tex").snips,
    lua = {
      s("localM", {
        tnl [[local M = {}]],
        t "M.",
        i(0),
        nlt [[return M]],
      }),
    },
  }

  require("luasnip/loaders/from_vscode").lazy_load()
end
return M
