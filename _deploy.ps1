chcp 65001
git checkout main
git add .
git commit -m "backup"
git checkout release
proxychains hexo g -d --silent
git restore .obsidian/workspace*.json
git stash 
git checkout main
git stash drop
