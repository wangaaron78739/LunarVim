local M = {}
-- output = buffer, consolation, echo, quickfix, terminal, or none
local runme = {
  command = "./%",
  output = "terminal",
}
local runthis = {
  default_task = "run",
  tasks = {
    run = runme,
  },
}
local function strip_ext(name)
  -- TODO:
  return name
end
local function curr_file_name()
  return strip_ext(vim.fn.expand "%")
end
local function get_root_dir()
  return vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd()
end
local ctasks = {
  default_task = "build_and_run",
  tasks = {
    -- One file
    build = {
      -- command = "gcc main.c -o main",
      command = function()
        return "gcc % -o " .. curr_file_name() .. ".o"
      end,
      output = "quickfix",
    },
    build_release = {
      -- command = "gcc main.c -o main",
      command = function()
        return "gcc -O3 % -o " .. curr_file_name() .. ".o"
      end,
      output = "quickfix",
    },
    run = {
      command = function()
        return "./" .. curr_file_name() .. ".o"
      end,
      output = "terminal",
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

    -- cmake
    cmake_build = {
      command = function()
        local root = get_root_dir()
        return "cmake --build " .. root .. "/build"
      end,
      output = "quickfix",
    },
    cmake_gen = {
      command = function()
        local root = get_root_dir()
        return "cmake -S " .. root .. "-B " .. root .. "/build"
      end,
      output = "quickfix",
    },
    cmake_gen_release = {
      command = function()
        local root = get_root_dir()
        return "cmake -S " .. root .. "-B " .. root .. "/build -DCMAKE_BUILD_TYPE=Release"
      end,
      output = "quickfix",
    },

    -- TODO: meson

    -- make
    make = {
      command = function()
        local root = get_root_dir()
        return "cd " .. root .. " && make"
      end,
    },
    ninja = {
      command = function()
        local root = get_root_dir()
        return "cd " .. root .. " && ninja"
      end,
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
  c = ctasks,
  cpp = ctasks,
  h = ctasks,
  hpp = ctasks,
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
      build_release = {
        command = "cargo build --release",
        output = "quickfix",
      },
      run = {
        command = "cargo run --release",
        output = "terminal",
      },
      run_debug = {
        command = "cargo run",
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
      install = {
        command = "cargo install --path .",
        output = "terminal",
      },
      update_deps = {
        command = "cargo update",
        output = "terminal",
      },
      publish = {
        command = "cargo publish",
        output = "terminal",
      },
    },
  },
  bash = runthis,
  sh = runthis,
  fish = runthis,
  python = {
    default_task = "run",
    tasks = {
      run = {
        command = "python %",
        output = "terminal",
      },
      run_interactive = {
        command = "python -i %",
        output = "terminal",
      },

      -- Poetry based projects
      poetry_install = {
        command = "poetry install",
        output = "terminal",
      },
      poetry_build = {
        command = "poetry build",
        output = "terminal",
      },
      poetry_shell = {
        command = "poetry shell",
        output = "terminal",
      },
      poetry_run = {
        command = "poetry run python %",
        output = "terminal",
      },
      poetry_run_interactive = {
        command = "poetry run python -i %",
        output = "terminal",
      },
    },
  },
}
local global = {
  run_shell = runme,
  commit_all = {
    command = "git commit -a",
    output = "terminal",
  },
  git_push = {
    command = "git push",
    output = "terminal",
  },
  git_pull = {
    command = "git pull --no-ff",
    output = "terminal",
  },
}
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
