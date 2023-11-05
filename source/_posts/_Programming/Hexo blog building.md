---
title: "[Record] Hexo blog building"
date: 2023-10-31
tags:
---
> This post is to record the problems encountered during building this blog site.


## Work with Git repo
I need to deploy hexo site within `release` branch and do backup for all files within `main` branch. To do so, config the obsidian-git plugin to switch branch to `main` and always stage changes to `main` branch. And run `proxychains.exe -f proxychains.conf hexo g -d` to deploy site to `release` branch. 
If any change was committed to `release` by mistake, you should merge the changes for `main` as following:
```shell
git checkout main
git merge release
```
If there are conflicts when merging, the files relating to the conflicts will be modified to reveal the details of conflict. Just check them one by one(use *vscode*) and commit without having conflicts. This is a test