local M = {}

-- TODO: Convert to lua
function M.config()
  -- vim.cmd [[call wilder#enable_cmdline_enter()]]
  vim.api.nvim_set_keymap("c", "<F1>", "wilder#main#start()", { expr = true, silent = true })
  vim.api.nvim_set_keymap("n", "g/", "/", { noremap = true })
  vim.api.nvim_set_keymap("n", "/", "g/<F1>", {})
  vim.api.nvim_set_keymap("n", "g/", "/", { noremap = true })
  vim.api.nvim_set_keymap("n", "/", "g/<F1>", {})
  vim.cmd [[call wilder#set_option('modes', ['/', '?', ':'])]]
  vim.cmd [[set wildcharm=<Tab>]]
  vim.cmd [[cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"]]
  vim.cmd [[cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"]]
  -- vim.cmd [[call wilder#set_option('modes', [':'])]]

  vim.cmd [[
  call wilder#set_option('pipeline', [ wilder#branch( wilder#cmdline_pipeline({ 'fuzzy': 1, }), wilder#python_search_pipeline({ 'pattern': 'fuzzy', }),), ])
    ]]

  vim.cmd [[
let g:wilder_highlighters = [ wilder#pcre2_highlighter(), wilder#basic_highlighter(), ] 
call wilder#set_option('renderer', wilder#renderer_mux({ ':': wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter(), }), '/': wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter(), }), }))
    ]]
end

return M
