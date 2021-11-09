local M = {}
M.config = function()
  -- require("nvim-treesitter.configs").setup {
  --   tree_docs = {
  --     enable = true,
  --     keymap = {
  --       doc_node_at_cursor = "<leader>rd",
  --       doc_all_in_range = "<leader>rd",
  --     },
  --     spec_config = {
  --       jsdoc = {
  --         slots = {
  --           class = { custom = true, author = true },
  --         },
  --         templates = {
  --           class = {
  --             "doc-start", -- Note, these are implicit slots and can't be turned off and vary between specs.
  --             "custom",
  --             "author",
  --             "doc-end",
  --             "%content%",
  --           },
  --         },
  --       },
  --     },
  --   },
  -- }
end
return M
