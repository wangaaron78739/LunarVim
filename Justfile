yadm-save:
    cd ~  && yadm add ~/.config/nvim 
    yadm commit -m "update nvim"

install:
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt install ranger libjpeg8-dev zlib1g-dev libxtst-dev
    pip3 install ueberzug
    pip3 install neovim-remote
    pip3 install pynvim --user
    npm install -g tree-sitter-cli
    sudo apt install neovim
    just remotes

neovide:
    sudo apt install -y curl \
        gnupg ca-certificates git \
        gcc-multilib g++-multilib cmake libssl-dev pkg-config \
        libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
        libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libsdl2-dev

    wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo apt-key add -
    sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-focal.list https://packages.lunarg.com/vulkan/lunarg-vulkan-focal.list
    sudo apt update
    sudo apt install vulkan-sdk

    git clone "https://github.com/Kethku/neovide"
    cd neovide
    # cargo build --release
    cargo install --path .

from-source:
    git clone https://github.com/neovim/neovim.git
    cd neovim 
    make CMAKE_BUILD_TYPE=Release;
    and make CMAKE_INSTALL_PREFIX=$HOME/.local/nvim install

settings:
    nvim init.lua lua/settings.lua lua/plugins.lua lua/keymappings.lua lua/lv-autocommands/init.lua lua/lv-which-key/init.lua

plugins:
    nvim lua/plugins.lua
    nvim +PackerCompile +PackerInstall

save: update
    git add . 
    git commit -v 
    just yadm-save

fetch:
    git fetch 

checkout-master:
    git checkout master 

update: fetch checkout-master
    git pull --ff-only

update-merge: fetch checkout-master
    git pull --rebase

update-origin: update-merge
    git fetch upstream
    git merge upstream/master master
    just yadm-save
    
remotes:
    git remote add upstream https://github.com/ChristianChiarulli/LunarVim.git
    git remote add jack https://github.com/jacfger/lunarvim   
    git remote add aaron https://github.com/wangaaron78739/LunarVim.git 
