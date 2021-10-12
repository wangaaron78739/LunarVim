local M = {}
-- output = buffer, consolation, echo, quickfix, terminal, or none
local runthis = {
  default_task = "run",
  tasks = {
    run = {
      command = "./%",
      output = "terminal",
    },
  },
}
local tasks = {
  lua = {
    tasks = {
      nvim = {
        command = "luafile %",
        type = "vim",
      },
    },
  },
  c = {
    default_task = "build_and_run",
    tasks = {
      build = {
        command = "gcc main.c -o main",
        output = "quickfix",
      },
      run = {
        command = "./main",
        output = "consolation",
      },
      build_and_run = {
        command = function()
          require("yabs"):run_task("build", {
            on_exit = function()
              require("yabs").languages.c:run_task "run"
            end,
          })
        end,
        type = "lua",
      },
    },
  },
  rust = {
    default_task = "check",
    tasks = {
      check = {
        command = "cargo check",
        output = "quickfix",
      },
      build = {
        command = "cargo build",
        output = "quickfix",
      },
      run = {
        command = "cargo run --release",
        output = "terminal",
      },
      test = {
        command = "cargo test",
        output = "buffer",
      },
      bench = {
        command = "cargo bench",
        output = "buffer",
      },
      test_release = {
        command = "cargo test --release",
        output = "buffer",
      },
    },
  },
  bash = runthis,
  sh = runthis,
  fish = runthis,
}
local global = {}
local opts = {
  output_types = {
    quickfix = {
      open_on_run = "always",
    },
  },
}
M.config = function()
  require("yabs"):setup {
    languages = tasks,
    tasks = global,
    opts = opts,
  }
  require("telescope").load_extension "yabs"
end
M.keymaps = function(leaderMappings)
  vim.cmd [[command! -nargs=1 Yabs lua require'yabs':run_task('<args>') ]]
  leaderMappings["p "] = { "<CMD>lua require'yabs':run_task()<CR>", "YABS: Default" }
  leaderMappings.pb = { "<CMD>lua require'yabs':run_task('build')<CR>", "YABS: Build" }
  leaderMappings.pr = { "<CMD>lua require'yabs':run_task('run')<CR>", "YABS: Run" }
  leaderMappings.pt = { "<CMD>lua require'yabs':run_task('test')<CR>", "YABS: Test" }
  leaderMappings.pp = { "<CMD>Telescope yabs tasks<CR>", "YABS: tasks" }
end
return M
