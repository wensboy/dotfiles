---
tool:
    - git
tags:
    - version control
    - linux
    - command
---

## what is git?

Git is a distributed version control tool for tracking changes to files, collaboratively developing, and managing project code

## how to use git?

You can save a record of all changes to a file

## why git not svn?

git:Multi-person collaborative development

why:SVN has only one server, which is deployed on the remote end, and the local network interacts with the remote end. Git is a distributed version control tool, in addition to a central server for code hosting, there will also be a local repository, when committing code, you can first commit to the local repository, and then push to the remote end as needed or at the right time

## usage

```shell
# download and install
sudo pamcan -S git

# config
git config --global user.name ''
git config --global user.email ''

# get help
git help <command>
git <command> --help
man git-<command>

# init a bare repository
git init --bare

# workspace-->index/stage-->repository-->remote
git pull [or] git fetch && git merge
git add <files>
git commit -m 'message'
git push [-u] remote_repo_name remote_branch

# get log
git log [-oneline -p --merges] 

# remove from index/stage
git rm -f [or] git rm --cached

# push force but not cover
git push --fore-with-lease

# handle error
rejected:git pull
non-fast-forward:
git pull --rebase
git push

# get status
git status [-s]

# cite log
git reflog [options]
git reflog show HEAD@{<n>}

# index/stage --> workspace
git restore -S <files>

# repository -->index/stage [workspace,clean up]
-->index/stage:
git reset --soft
-->workspace
git reset --mixed
-->clean up
git reset --hard

# clean up workspace
-->abandon all (not add)
git checkout .
-->force abandon
git checkout -f <files>
git checkout -f <branck>

# interactive rebase
git rebase -i HEAD~n
git rebase -i <file1> <file2>
```
