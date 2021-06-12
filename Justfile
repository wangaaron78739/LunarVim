# This is just here to handle empty `just` invocations
@_null:
    just --list

# Update nvim in YADM
yadm-save message="update nvim config":
	git push
	cd ~  && yadm add ~/.config/nvim 
	yadm commit -m "{{message}}"

# Install neovim (and dependencies)
install:
    sudo apt install ranger libjpeg8-dev zlib1g-dev libxtst-dev 
    pip3 install ueberzug
    pip3 install neovim-remote
    pip3 install pynvim --user
    npm install -g tree-sitter-cli
    git remote add upstream https://github.com/ChristianChiarulli/LunarVim.git
    nvim # Run once to install packer and stuff
    nvim +PackerInstall # Run again to install the plugins

# Open neovim with main settings files
settings:
    nvim init.lua lua/settings.lua lua/plugins.lua lua/keymappings.lua lua/lv-autocommands/init.lua lua/lv-which-key/init.lua

# Open plugins.lua (and PackerInstall automatically afterwards)
plugins:
	nvim lua/plugins.lua
	nvim +PackerCompile +PackerInstall

# Fetch new changes 
fetch:
    git fetch 

# Fix detached HEAD from doing yadm pull
fix-head:
    git checkout -b old_head && git branch -d master && git checkout -b master origin/master \
    || echo "HEAD is okay"
    git branch --set-upstream-to=origin/master master

# Commit the whole config directory (also updates yadm)
save-all: fix-head
    git add . 
    git commit -v 
    just yadm-save

save: fix-head
    git ui 
    just yadm-save

# Pull changes from my repository (rebase)
update: 
	git pull --rebase

# Update LunarVim from ChristianChiarulli's repo
update-lunarvim: save
	git fetch upstream
	git merge upstream/master master
	just yadm-save "update lunarvim"
    
# Add me and my friends remotes
remotes:
	git remote add upstream https://github.com/ChristianChiarulli/LunarVim.git
	git remote add jack https://github.com/jacfger/lunarvim   
	git remote add aaron https://github.com/wangaaron78739/LunarVim.git 
