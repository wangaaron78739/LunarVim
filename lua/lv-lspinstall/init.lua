local lspinstall_ok, lspinstall = pcall(require, "lspinstall")
if lspinstall_ok then
  -- 1. get the config for this server from nvim-lspconfig and adjust the cmd path.
  --    relative paths are allowed, lspinstall automatically adjusts the cmd and cmd_cwd for us!
  local config = require("lspconfig").jdtls.document_config
  require("lspconfig/configs").jdtls = nil -- important, unset the loaded config again
  -- config.default_config.cmd[1] = "./node_modules/.bin/bash-language-server"

  -- 2. extend the config with an install_script and (optionally) uninstall_script
  -- require'lspinstall/servers'.jdtls = vim.tbl_extend('error', config, {
  --     -- lspinstall will automatically create/delete the install directory for every server
  --     install_script = [[
  --       git clone https://github.com/eclipse/eclipse.jdt.ls.git
  --       cd eclipse.jdt.ls
  --       ./mvnw clean verify
  --   ]],
  --     uninstall_script = nil -- can be omitted
  -- })

  -- require'lspinstall/servers'.kotlin = vim.tbl_extend('error', config, {
  --     install_script = [[
  --       git clone https://github.com/fwcd/kotlin-language-server.git language-server
  --       cd language-server
  -- 	  ./gradlew :server:installDist
  --   ]],
  --     uninstall_script = nil -- can be omitted
  -- })

  -- Install Julia Language Server
  -- local config = require"lspinstall/util".extract_config("julia")
  local config = {}
  require("lspinstall/servers").julia = vim.tbl_extend("error", config, {
    install_script = [[
    julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
  ]],
    uninstall_script = nil, -- can be omitted
  })

  -- Install Zig Lanuage Server
  local config = require("lspinstall/util").extract_config "zls"
  config.default_config.cmd[1] = "./zls/zls"
  require("lspinstall/servers").zig = vim.tbl_extend("error", config, {
    install_script = [[
        os=$(uname -s | tr "[:upper:]" "[:lower:]")
        mchn=$(uname -m | tr "[:upper:]" "[:lower:]")
        if [ $mchn = "arm64" ]; then
        mchn="aarch64"
        fi
        case $os in
        linux)
        platform="unknown-linux-gnu"
        ;;
        darwin)
        platform="apple-darwin"
        ;;
        esac
        curl -L -o "$mchn-$os.tar.xz" "https://github.com/zigtools/zls/releases/latest/download/$mchn-$os.tar.xz"
        tar xavf $mchn-$os.tar.xz
        mv $mchn-$os zls
    ]],
  })

  lspinstall.setup()
end

local lsp_installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if lsp_installer_ok then
end
