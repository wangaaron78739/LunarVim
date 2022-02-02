local M = {}

function M.config()
  local hop = require "hop"
  hop.setup {
    keys = O.hint_labels,
  }
end

function M.keymaps(leaderMappings)
  if O.plugin.hop then
    -- TODO: register_nN_repeat here??
    local exts = require "hop-extensions"
    local hops = {
      name = "Hop",
      -- ["/"] = { prefix .. "hint_patterns({}, vim.fn.getreg('/'))<cr>", "Last Search" },
      ["/"] = {
        function()
          exts.hint_patterns({}, vim.fn.getreg "/")
        end,
        "Last Search",
      },
      w = { exts.hint_words, "Words" },
      L = { exts.hint_lines_skip_whitespace, "Lines" },
      l = { exts.hint_vertical, "Lines Column" },
      ["*"] = { exts.hint_cword, "cword" },
      W = { exts.hint_cWORD, "cWORD" },
      h = { exts.hint_locals, "Locals" },
      d = { exts.hint_definitions, "Definitions" },
      -- g = { exts.hint_localsgd, "Go to Definition of" },
      r = { exts.hint_references, "References" },
      u = {
        function()
          exts.hint_references "<cword>"
        end,
        "Usages",
      },
      s = { exts.hint_scopes, "Scopes" },
      t = { exts.hint_textobjects, "Textobjects" },
      b = { require("hop-extensions.lsp").hint_symbols, "LSP Symbols" },
      g = { require("hop-extensions.lsp").hint_diagnostics, "LSP Diagnostics" },
      -- f = { prefix .. "hint_textobjects{query='function'}<cr>", "Functions" },
      -- a = { prefix .. "hint_textobjects{query='parameter'}<cr>", "parameter" },
    }
    for k, v in pairs(O.treesitter.textobj_suffixes) do
      -- hops[v[1]] = hops[v[1]] or { prefix .. "hint_textobjects{query='" .. k .. "'}<cr>", "@" .. k }
      hops[v[1]] = hops[v[1]]
        or {
          function()
            exts.hint_textobjects { query = k }
          end,
          "@" .. k,
        }
    end
    leaderMappings.h = hops
    -- require("which-key").register(hops, {
    --   mode = "n",
    --   prefix = "<leader>h",
    --   silent = true,
    -- })
    local map = vim.keymap.set
    map(
      "c",
      "<M-h>", -- "<M-CR>",
      "<CR><CMD>lua require'hop'.hint_patterns({}, vim.fn.getreg('/'))<CR>",
      { silent = true, noremap = true }
    )
  end
end

return M
