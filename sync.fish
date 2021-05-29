#!/usr/bin/env fish

set oldwd (pwd)
cd ~/.config/nvim/

echo 'git add . && git commit -v' # '&& fish -c cd .. && yadm add nvim && yadm commit -m "merge upstream lunarvim"'
git add . && git commit -v # && fish -c 'cd .. && yadm add nvim && yadm commit -m "merge upstream lunarvim"'

echo 'git fetch --all && git pull'
git fetch --all && git pull 

echo 'git merge --no-ff upstream/master master' # '&& fish -c cd .. && yadm add nvim && yadm commit -m "update nvim config"'
git merge --no-ff upstream/master master # && fish -c 'cd .. && yadm add nvim && yadm commit -m "merge upstream lunarvim"' 

echo 'fish -c cd .. && yadm add nvim && yadm commit -m "merge upstream lunarvim"'
fish -c 'cd .. && yadm add nvim && yadm commit -m "merge upstream lunarvim"' 

echo 'git push'
git push
echo 'remember to yadm push'

cd $oldwd
