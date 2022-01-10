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
    local prefix = "<cmd>lua require('hop-extensions')."
    local hops = {
      name = "Hop",
      w = { prefix .. "hint_words()<cr>", "Words" },
      L = { prefix .. "hint_lines_skip_whitespace()<cr>", "Lines" },
      l = { prefix .. "hint_vertical()<cr>", "Lines Column" },
      ["*"] = { prefix .. "hint_cword()<cr>", "cword" },
      ["/"] = { prefix .. "hint_patterns({}, vim.fn.getreg('/'))<cr>", "Last Search" },
      W = { prefix .. "hint_cWORD()<cr>", "cWORD" },
      h = { prefix .. "hint_locals()<cr>", "Locals" },
      d = { prefix .. "hint_definitions()<cr>", "Definitions" },
      -- g = { prefix .. "hint_locals()<cr>gd", "Go to Definition of" },
      r = { prefix .. "hint_references()<cr>", "References" },
      u = { prefix .. "hint_references('<cword>')<cr>", "Usages" },
      s = { prefix .. "hint_scopes()<cr>", "Scopes" },
      t = { prefix .. "hint_textobjects()<cr>", "Textobjects" },
      b = { "<cmd>lua require'lv-hop.lsp'.hint_symbols()<cr>", "LSP Symbols" },
      g = { "<cmd>lua require'lv-hop.lsp'.hint_diagnostics()<cr>", "LSP Diagnostics" },
      -- f = { prefix .. "hint_textobjects{query='function'}<cr>", "Functions" },
      -- a = { prefix .. "hint_textobjects{query='parameter'}<cr>", "parameter" },
    }
    for k, v in pairs(O.treesitter.textobj_suffixes) do
      hops[v[1]] = hops[v[1]] or { prefix .. "hint_textobjects{query='" .. k .. "'}<cr>", "@" .. k }
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
