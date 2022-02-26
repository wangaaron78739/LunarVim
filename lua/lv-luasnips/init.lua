local M = {}
function M.setup()
  local types = require "luasnip.util.types"

  require("luasnip").config.set_config {
    history = true,
    enable_autosnippets = true,
    updateevents = "TextChanged,TextChangedP,TextChangedI",
    -- region_check_events = "CursorMoved,CursorHold,InsertEnter",
    region_check_events = "CursorMoved,CursorMovedI,InsertEnter",
    -- delete_check_events = "TextChangedI,TextChangedP,TextChanged",
    delete_check_events = "InsertLeave,InsertEnter",
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    store_selection_keys = "<tab>",

    ext_opts = {
      [types.choiceNode] = { active = { virt_text = { { "●", "GlyphPalette2" } } } },
      [types.insertNode] = { active = { virt_text = { { "●", "GlyphPalette4" } } } },
    },

    -- parser_nested_assembler = require "lv-luasnips.nested",
  }

  local map = vim.keymap.set
  --  "<Plug>luasnip-expand-or-jump"
  -- map("i", "<C-h>", "<Plug>luasnip-expand-snippet", { silent = true })
  -- map("s", "<C-h>", "<Plug>luasnip-expand-snippet", { silent = true })

  local feedkeys_ = vim.api.nvim_feedkeys
  local termcode = vim.api.nvim_replace_termcodes
  local feedkeys = function(keys, o)
    if o == nil then
      o = "m"
    end
    feedkeys_(termcode(keys, true, true, true), o, false)
  end
  local luasnip = require "luasnip"
  local cj = function()
    if luasnip.expand_or_jumpable() then
      feedkeys "<Plug>luasnip-jump-next"
    else
      feedkeys "<Plug>(Tabout)"
    end
  end
  map("i", "<C-j>", cj, { silent = true })
  map("s", "<C-j>", cj, { silent = true })
  map("i", "<C-k>", "<Plug>luasnip-jump-prev", { silent = true })
  map("s", "<C-k>", "<Plug>luasnip-jump-prev", { silent = true })
  map("i", "<C-h>", "<Plug>luasnip-next-choice", { silent = true })
  map("s", "<C-h>", "<Plug>luasnip-next-choice", { silent = true })
  map("i", "<C-y>", "<cmd>lua require'lv-luasnips.choice'.popup_close()<CR>", { silent = true })
  map("s", "<C-y>", "<cmd>lua require'lv-luasnips.choice'.popup_close()<CR>", { silent = true })
  local operatorfunc_keys = require("lv-utils").operatorfunc_keys
  map("n", "<M-s>", operatorfunc_keys("luasnip_select", "<TAB>"), { silent = true })

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
  local function nlt(line)
    return t { "", line }
  end
  local function tnl(line)
    return t { line, "" }
  end

  -- Returns a snippet_node wrapped around an insert_node whose initial
  -- text value is set to the current date in the desired format.
  local function date_input(args, state, fmt)
    local fmt = fmt or "%Y-%m-%d"
    return sn(nil, i(1, os.date(fmt)))
  end

  local function selected_text(opts)
    return f(function(_, snip)
      return snip.env.TM_SELECTED_TEXT or ""
    end, vim.tbl_extend(
      "force",
      {},
      opts or {}
    ))
  end

  ls.snippets = {
    all = {
      s("date", { d(1, date_input, {}, "%A, %B %d of %Y") }),
    },
    -- tex = require("lv-luasnips.tex").snips,
    lua = {
      s("localM", {
        tnl [[local M = {}]],
        t "M.",
        i(0),
        nlt [[return M]],
      }),
      s("link_url", {
        t '<a href="',
        selected_text(),
        t '">',
        i(1),
        t "</a>",
      }),
      s("function", {
        t "function ",
        i(1),
        t "(",
        i(2),
        t { ")", "" },
        selected_text(),
        -- t { "", "" },
        i(0),
        t { "", "end" },
        -- mi(1),
        -- t "(",
        -- mi(2),
        -- t { ")", "" },
      }),
      s("function", {
        t "if ",
        i(1),
        t { "then", "" },
        selected_text(),
        -- t { "", "" },
        i(0),
        t { "", "end" },
        -- mi(1),
        -- t "(",
        -- mi(2),
        -- t { ")", "" },
      }),
      s("iife", {
        t "(function ",
        i(1),
        t "(",
        i(2),
        t { ")", "return" },
        selected_text(),
        -- t { "", "" },
        i(0),
        t { "", "end)()" },
        -- mi(1),
        -- t "(",
        -- mi(2),
        -- t { ")", "" },
      }),
    },
  }

  require("luasnip/loaders/from_vscode").lazy_load()
  require("lv-luasnips.choice").config()
end

function M.get_snippet(name, ft)
  ft = ft or vim.opt.filetype._value

  local snippets = require("luasnip").snippets[ft]
  for i, snip in ipairs(snippets) do
    local trig = snip.trigger
    if trig == name then
      return snip
    end
  end
  return nil
end
function M.expand_snippet(snip)
  if snip == nil then
    return
  end
  if snip.regTrig then
    -- if trigger is a pattern, expand "pattern" instead of actual snippet.
    snip = snip:get_pattern_expand_helper()
  else
    snip = snip:copy()
  end
  utils.dump(snip)
  snip:trigger_expand(require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()])
end
function M.expand_by_name(name, ft)
  M.expand_snippet(M.get_snippet(name, ft))
end
return M
