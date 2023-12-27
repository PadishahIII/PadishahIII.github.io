## Tips
### Switching unstaged changes to another branch
There is some unstaged changes on branch `release`. I want to stage these changes to branch `main`.

```cmd
git stash --include-untracked
git checkout main
git stash pop
```

### Remove big files from git history
Use [BFG](https://rtyley.github.io/bfg-repo-cleaner/)
