git checkout main
git add .
git commit -m "backup"
git push origin main
git checkout release
git merge -X theirs main -m "merge from main"
source ~/.zshrc
proxy
echo "Before hexo generate"
hexo g -d --silent
echo "After hexo generate"
unproxy
#git restore .obsidian/workspace*.json
git stash 
git checkout main
git stash drop
