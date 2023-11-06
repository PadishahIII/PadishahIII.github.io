git checkout main
git add .
git commit -m "backup"
git checkout release
git merge -X theirs main
proxy
hexo g -d --silent
unproxy
git restore .obsidian/workspace*.json
git stash 
git checkout main
git stash drop
