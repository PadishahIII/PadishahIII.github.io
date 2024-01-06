## Tips
### Switching unstaged changes to another branch
There is some unstaged changes on branch `release`. I want to stage these changes to branch `main`.

```cmd
git stash --include-untracked
git checkout main
git stash pop
```

### Merge && Rebase
Current branch A, `git merge B` means that integrate the changes made in branch B into branch A. `git rebase B` just do the same thing except that the commit history will be rewritten to place the commits from the current branch on top of the commits from branch B.

### Remove big files from git history
Use [BFG](https://rtyley.github.io/bfg-repo-cleaner/)
