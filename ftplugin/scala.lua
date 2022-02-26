local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
require("metals").initialize_or_attach(metals_config)
