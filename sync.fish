#!/usr/bin/env fish

set oldwd (pwd)
cd ~/.config/nvim/

git add . && git commit -v && fish -c 'cd .. && yadm add nvim && yadm commit -m "update nvim config"'
git fetch --all && git pull 
git merge --no-ff upstream/master master && fish -c 'cd .. && yadm add nvim && yadm commit -m "update nvim config"' 
git push

cd $oldwd
