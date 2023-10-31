chcp 65001
git checkout main
git add .
git commit -m "backup"
git checkout release
proxychains hexo g -d --silent
git checkout main
