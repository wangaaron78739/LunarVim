vim.opt_local.commentstring = "# %s"

-- TODO: Check if this really activates correctly
require("lsp.config").lspconfig "julials" {
  -- on_new_config = function(new_config, new_root_dir)
  --   server_path = "/home/amedhi/.julia/packages/LanguageServer/jiDTR/src/LanguageServer.jl"
  --   cmd = {
  --     "julia",
  --     "--project=" .. server_path,
  --     "--startup-file=no",
  --     "--history-file=no",
  --     "-e",
  --     [[
  --         using Pkg;
  --         Pkg.instantiate()
  --         using LanguageServer; using SymbolServer;
  --         depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
  --         project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))
  --         # Make sure that we only load packages from this environment specifically.
  --         @info "Running language server" env=Base.load_path()[1] pwd() project_path depot_path
  --         server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
  --         server.runlinter = true;
  --         run(server);
  --       ]],
  --   }
  --   new_config.cmd = cmd
  -- end,
}
