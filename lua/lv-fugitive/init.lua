local M = {}

function M.setup() end

function M.ftplugin()
  mappings.buf(0, "n", "p", "<cmd>Git push<CR>", { noremap = true })
  mappings.localleader {
    s = { "s", "Stage" },
    u = { "u", "Unstage" },
    ["-"] = { "-", "Toggle Stage" },
    U = { "U", "Unstage all" },
    X = { "X", "Discard" },
    [","] = { "=", "Toggle diff" },
    ["="] = { "=", "Toggle diff" },
    [">"] = { ">", "Show diff" },
    ["<"] = { "<", "Hide diff" },
    -- I = { "I", "Add Patch" },
    d = { name = "Diffs" },
    dd = { "dd", "Gdiffsplit" },
    dv = { "dv", "Gvdiffsplit" },
    ds = { "ds", "Ghdiffsplit" },
    dq = { "dq", "Close Diffs" },
    ["<CR>"] = { "<CR>", "Open" },
    o = { "gO", "Open vsplit" },
    gO = { "o", "Open split" },
    O = { "O", "Open tab" },
    P = { "1p", "Open preview" },
    p = { "<cmd>Git push<cr>", "Push" },
    C = { "C", "Open commit" },
    ["("] = { "(", "Jump prev" },
    [")"] = { ")", "Jump next" },
    i = { "i", "Next file (expand)" },
    ["*"] = { "*", "Find +/-" },
    I = { "1gi", "Open .gitignore" },
    gI = { "1gI", "Add to ignore" },
    c = { name = "Commits" },
    cc = { "cvc", "Create commit" },
    ca = { "cva", "Amend" },
    ce = { "ce", "Amend noedit" },
    cw = { "cw", "Reword" },
    -- cvc = { "cvc", "Commit -v" },
    -- cva = { "cva", "Amend -v" },
    cf = { "cf", "Fixup" },
    cF = { "cF", "Fixup+Rebase" },
    cs = { "cs", "Squash" },
    cS = { "cS", "Squash+Rebase" },
    cA = { "cA", "Squash+Edit" },
    ["c<space>"] = { "c<space>", ":Git commit ..." },
    cr = { name = "Revert" },
    crc = { "crc", "Revert" },
    crn = { "crn", "Revert (nocommit)" },
    ["cr<space>"] = { "cr<space>", ":Git revert ..." },
    ["cm<space>"] = { "cm<space>", ":Git merge ..." },
    co = { name = "Checkout" },
    coo = { "coo", "Checkout Commit" },
    ["cb<space>"] = { "cb<space>", ":Git branch ..." },
    ["co<space>"] = { "co<space>", ":Git checkout ..." },
    cz = { name = "Stashes" },
    czz = { "czz", "Push stash" },
    czZ = { "1czz", "Push stash untracked" },
    -- czA = { "2czz", "Push stash all" },
    czw = { "czw", "Push stash worktree" },
    czA = { "czA", "Apply stash" },
    cza = { "cza", "Apply stash preserve" },
    czP = { "czP", "Pop stash" },
    czp = { "czp", "Pop stash preserve" },
    ["cz<space>"] = { "co<space>", ":Git stash ..." },
    -- TODO: Rebase
    r = { name = "Rebase" },
    ri = { "ri", "Interactive" },
    rf = { "rf", "Interactive notodo" },
    ru = { "ru", "Against @{upstream}" },
    rp = { "rp", "Against @{push}" },
    rr = { "rr", "Continue" },
    rs = { "rs", "Skip" },
    ra = { "ra", "Abort" },
    re = { "re", "Edit todo" },
    rw = { "rw", "commit: reword" },
    rm = { "rm", "commit: edit" },
    rd = { "rd", "commit: drop" },
    ["r<Space>"] = { "r<Space>", ":Git rebase ... " },
    q = { "gq", "Close status" },
  }
  mappings.whichkey({
    ["[g"] = { "[c", "Prev hunk" },
    ["]g"] = { "]c", "Next hunk" },
    ["[m"] = { "[m", "Prev file" },
    ["]m"] = { "]m", "Next file" },
    gq = { "gq", "Close status" },
    ["<ESC>"] = { "gq", "Close status" },
  }, {
    buffer = 0,
  })

  --   vim.cmd [[
  -- augroup _fugitive
  --   autocmd! * <buffer>
  --   autocmd CursorHold,CursorHoldI <buffer> lua require'which-key'.show()
  -- augroup END
  -- ]]
end
return M
