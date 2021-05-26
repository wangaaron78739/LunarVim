#!/usr/bin/env fish

set oldwd (pwd)
cd ~/.config/nvim/

git add . && git commit -v && yadm add . && yadm commit -m "update nvim config"
git fetch --all && git pull && git push
git merge --no-ff upstream/master master

cd $oldwd
