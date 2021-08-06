# This is just here to handle empty `just` invocations
@_default:
    just --list

# Update nvim in YADM
yadm-save message="update nvim config": fix-head
    git pull
    git push 
    cd ~  && yadm add ~/.config/nvim 
    yadm commit -m "{{message}}"

# TODO: install in an isolated virutal environment? (use pipx)
# Install dependencies # TODO: there are some dependencies not included here
install:
    sudo apt install libjpeg8-dev zlib1g-dev libxtst-dev 
    # pipx install --force ranger-fm
    # pipx inject ranger-fm pynvim ueberzug
    pipx install --force neovim-remote
    # pip3 install pynvim --user
    npm install -g tree-sitter-cli
    cargo install stylua
    git remote add upstream https://github.com/ChristianChiarulli/LunarVim.git || true
    cp ./utils/efm-config.yaml ~/.config/efm-langserver/config.yaml
    nvim # Run once to install packer and stuff
    nvim +PackerSync # Run again to install the plugins

# Install lsp that I want
lsps:
    nvim +'LspInstall efm'
    nvim +'LspInstall rust'
    nvim +'LspInstall lua'
    nvim +'LspInstall python'
    nvim +'LspInstall cpp'
    nvim +'LspInstall cmake'
    nvim +'LspInstall latex'
    nvim +'LspInstall json'

# Open neovim with main settings files
settings:
    nvim init.lua lv-config.lua lua/default-config.lua lua/settings.lua lua/plugins.lua lua/keymappings.lua lua/lv-which-key/init.lua

# Open plugins.lua (and PackerInstall automatically afterwards)
plugins:
	nvim lua/plugins.lua
	nvim lua/plugins.lua +PackerSync

# Update Plugins using Packer
update-plugins:
    nvim lua/plugins.lua +PackerSync

# Profile startup time
startup:
    nvim +PackerCompile +'StartupTime -- lua/plugins.lua'

stylua:
    stylua **.lua

# Fetch new changes 
fetch:
    git fetch 

# Fix detached HEAD from doing yadm pull
_fix_head:
    #!/usr/bin/env bash
    set -euxo pipefail
    HASH=$(git rev-parse master)
    git branch master-$HASH $HASH
    git branch -f master HEAD 
    git checkout master
# TODO: clean up old heads

fix-head:
    test $(git rev-parse --abbrev-ref HEAD) = 'master' || just _fix_head
# #!/usr/bin/env fish
# set hash (git rev-parse HEAD)
# git checkout master
# git merge $hash

# Commit the whole config directory (also updates yadm)
save-all: fix-head
    git add . 
    git commit -v 
    just yadm-save

# Interactively save
save: fix-head
    git ui 
    just yadm-save
    
# Add me and my friends remotes
remotes:
	git remote add upstream https://github.com/ChristianChiarulli/LunarVim.git
	git remote add jack https://github.com/jacfger/lunarvim   
	git remote add aaron https://github.com/wangaaron78739/LunarVim.git 

copy-config:
    test "$PWD" == "$(~/.config/nvim)" || rsync -r . ~/.config/nvim

git-copy-config:
    git push
    cd ~/.config/nvim && git checkout $(git rev-parse HEAD)
