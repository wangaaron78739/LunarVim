#!/usr/bin/env fish

set oldwd (pwd)
cd ~/.config/nvim/

git add . && git commit -v
git fetch --all && git pull && git push
git merge --no-ff upstream/master master

cd $oldwd
