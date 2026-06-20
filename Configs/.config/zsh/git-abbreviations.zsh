# ============================================================================
# Git Abbreviations (zsh-abbr)
# Expands inline on space/enter, just like fish abbr.
# zsh-abbr has no native "description" field, so descriptions are kept as
# comments directly above/beside each abbreviation.
# ============================================================================

# Suppress "Added the regular session abbreviation `x`" noise on every
# new shell. ABBR_QUIET is zsh-abbr's own env var for this (same effect
# as passing --quiet to every call below).
ABBR_QUIET=1

# --- core ---------------------------------------------------------------
abbr -S g='git'                                            # git
abbr -S ga='git add'                                        # stage file(s)
abbr -S gaa='git add --all'                                  # stage everything
abbr -S gau='git add --update'                               # stage tracked changes only
abbr -S gapa='git add --patch'                               # interactively stage hunks
abbr -S gap='git apply'                                      # apply a patch

# --- branch ---------------------------------------------------------------
abbr -S gb='git branch -vv'                                  # list branches, verbose
abbr -S gba='git branch -a -v'                               # list all branches (local+remote)
abbr -S gban='git branch -a -v --no-merged'                  # list unmerged branches
abbr -S gbd='git branch -d'                                  # delete branch (safe)
abbr -S gbD='git branch -D'                                  # delete branch (force)
abbr -S ggsup='git branch --set-upstream-to=origin/$(git rev-parse --abbrev-ref HEAD)'  # set upstream to current branch on origin
abbr -S gbl='git blame -b -w'                                # blame, ignore whitespace

# --- bisect ---------------------------------------------------------------
abbr -S gbs='git bisect'                                     # start bisecting
abbr -S gbsb='git bisect bad'                                # mark commit bad
abbr -S gbsg='git bisect good'                               # mark commit good
abbr -S gbsr='git bisect reset'                              # end bisect session
abbr -S gbss='git bisect start'                              # begin bisect session

# --- commit ---------------------------------------------------------------
abbr -S --force gc='git commit -v' > /dev/null               # commit, show diff in editor (--force: a `gc` command exists on PATH and would otherwise block this)
abbr -S 'gc!'='git commit -v --amend'                        # amend last commit
abbr -S 'gcn!'='git commit -v --no-edit --amend'             # amend without changing message
abbr -S gca='git commit -v -a'                               # commit all tracked changes
abbr -S 'gca!'='git commit -v -a --amend'                    # amend, including all tracked changes
abbr -S 'gcan!'='git commit -v -a --no-edit --amend'         # amend all, keep message
abbr -S gcv='git commit -v --no-verify'                      # commit, skip hooks
abbr -S gcav='git commit -a -v --no-verify'                  # commit all, skip hooks
abbr -S 'gcav!'='git commit -a -v --no-verify --amend'       # amend all, skip hooks
abbr -S gcm='git commit -m'                                  # commit with inline message
abbr -S gcam='git commit -a -m'                              # commit all, inline message
abbr -S gcs='git commit -S'                                  # signed commit
abbr -S gscam='git commit -S -a -m'                          # signed commit, all, inline message
abbr -S gcfx='git commit --fixup'                            # fixup commit (for autosquash)

# --- config / clone / clean -----------------------------------------------
abbr -S gcf='git config --list'                              # show all git config
abbr -S gcl='git clone'                                      # clone a repo
abbr -S gclean='git clean -di'                               # interactively remove untracked files
abbr -S 'gclean!'='git clean -dfx'                            # force remove untracked + ignored files
abbr -S 'gclean!!'='git reset --hard && git clean -dfx'       # hard reset + force clean
abbr -S gcount='git shortlog -sn'                             # commit count per author

# --- cherry-pick ------------------------------------------------------------
abbr -S gcp='git cherry-pick'                                 # cherry-pick a commit
abbr -S gcpa='git cherry-pick --abort'                        # abort cherry-pick
abbr -S gcpc='git cherry-pick --continue'                     # continue cherry-pick

# --- diff -------------------------------------------------------------------
abbr -S gd='git diff'                                         # show unstaged changes
abbr -S gdca='git diff --cached'                              # show staged changes
abbr -S gds='git diff --stat'                                 # diff summary stats
abbr -S gdsc='git diff --stat --cached'                       # staged diff summary stats
abbr -S gdt='git diff-tree --no-commit-id --name-only -r'     # list files changed in a commit
abbr -S gdw='git diff --word-diff'                            # word-level diff
abbr -S gdwc='git diff --word-diff --cached'                  # word-level diff, staged
abbr -S gdto='git difftool'                                   # open configured diff tool
abbr -S gdg='git diff --no-ext-diff'                          # diff, ignore external diff tool

# --- misc -------------------------------------------------------------------
abbr -S gignore='git update-index --assume-unchanged'         # ignore changes to tracked file

# --- fetch --------------------------------------------------------------
abbr -S gf='git fetch'                                        # fetch from remote
abbr -S gfa='git fetch --all --prune'                         # fetch all remotes, prune deleted branches
abbr -S gfm='git fetch origin $(git rev-parse --abbrev-ref HEAD) --prune && git merge FETCH_HEAD'  # fetch+merge current branch from origin
abbr -S gfo='git fetch origin'                                 # fetch from origin

# --- pull / push (basic) -----------------------------------------------------
abbr -S gl='git pull'                                          # pull
abbr -S ggl='git pull origin $(git rev-parse --abbrev-ref HEAD)'  # pull current branch from origin
abbr -S gll='git pull origin'                                  # pull from origin
abbr -S glr='git pull --rebase'                                 # pull with rebase

# --- log ----------------------------------------------------------------
abbr -S glg='git log --stat'                                    # log with file stats
abbr -S glgg='git log --graph'                                  # log as graph
abbr -S glgga='git log --graph --decorate --all'                 # log graph, all branches
abbr -S glo='git log --oneline --decorate --color'               # condensed colored log
abbr -S glog='git log --oneline --decorate --color --graph'      # condensed colored graph log
abbr -S gloga='git log --oneline --decorate --color --graph --all'  # condensed graph log, all branches
abbr -S glom='git log --oneline --decorate --color $(git rev-parse --abbrev-ref HEAD)..'  # commits ahead of current branch
abbr -S glod='git log --oneline --decorate --color develop..'    # commits ahead of develop
abbr -S gloo="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"  # pretty one-line log w/ author + date

# --- merge ----------------------------------------------------------------
abbr -S gm='git merge'                                            # merge a branch
abbr -S gmt='git mergetool --no-prompt'                           # open merge tool
abbr -S gmom='git merge origin/$(git rev-parse --abbrev-ref HEAD)'  # merge origin's version of current branch

# --- push -----------------------------------------------------------------
abbr -S gp='git push'                                              # push
abbr -S 'gp!'='git push --force-with-lease'                        # safe force-push
abbr -S gpo='git push origin'                                      # push to origin
abbr -S 'gpo!'='git push --force-with-lease origin'                # safe force-push to origin
abbr -S gpv='git push --no-verify'                                  # push, skip hooks
abbr -S 'gpv!'='git push --no-verify --force-with-lease'            # safe force-push, skip hooks
abbr -S ggp='git push origin $(git rev-parse --abbrev-ref HEAD)'    # push current branch to origin
abbr -S 'ggp!'='git push origin $(git rev-parse --abbrev-ref HEAD) --force-with-lease'  # safe force-push current branch
abbr -S gpu='git push origin $(git rev-parse --abbrev-ref HEAD) --set-upstream'  # push + set upstream for current branch
abbr -S gpoat='git push origin --all && git push origin --tags'    # push all branches and tags
abbr -S ggpnp='git pull origin $(git rev-parse --abbrev-ref HEAD) && git push origin $(git rev-parse --abbrev-ref HEAD)'  # pull then push current branch

# --- remote -----------------------------------------------------------------
abbr -S gr='git remote -vv'                                        # list remotes, verbose
abbr -S gra='git remote add'                                       # add a remote
abbr -S grv='git remote -v'                                        # list remotes
abbr -S grmv='git remote rename'                                   # rename a remote
abbr -S grpo='git remote prune origin'                              # prune deleted remote branches
abbr -S grrm='git remote remove'                                    # remove a remote
abbr -S grset='git remote set-url'                                  # change a remote's URL
abbr -S grup='git remote update'                                    # update remote refs

# --- rebase -----------------------------------------------------------------
abbr -S grb='git rebase'                                            # rebase
abbr -S grba='git rebase --abort'                                   # abort rebase
abbr -S grbc='git rebase --continue'                                # continue rebase
abbr -S grbi='git rebase --interactive'                             # interactive rebase
abbr -S grbm='git rebase $(git rev-parse --abbrev-ref HEAD)'        # rebase onto current branch name (see note below)
abbr -S grbmi='git rebase $(git rev-parse --abbrev-ref HEAD) --interactive'  # interactive rebase onto current branch name
abbr -S grbmia='git rebase $(git rev-parse --abbrev-ref HEAD) --interactive --autosquash'  # interactive autosquash rebase
abbr -S grbom='git fetch origin $(git rev-parse --abbrev-ref HEAD) && git rebase FETCH_HEAD'  # fetch + rebase onto origin's current branch
abbr -S grbomi='git fetch origin $(git rev-parse --abbrev-ref HEAD) && git rebase FETCH_HEAD --interactive'  # fetch + interactive rebase
abbr -S grbomia='git fetch origin $(git rev-parse --abbrev-ref HEAD) && git rebase FETCH_HEAD --interactive --autosquash'  # fetch + interactive autosquash rebase
abbr -S grbd='git rebase develop'                                    # rebase onto develop
abbr -S grbdi='git rebase develop --interactive'                      # interactive rebase onto develop
abbr -S grbdia='git rebase develop --interactive --autosquash'        # interactive autosquash rebase onto develop
abbr -S grbs='git rebase --skip'                                      # skip current commit during rebase
abbr -S ggu='git pull --rebase origin $(git rev-parse --abbrev-ref HEAD)'  # rebase-pull current branch from origin

# --- revert / reset -----------------------------------------------------------
abbr -S grev='git revert'                                             # revert a commit
abbr -S grh='git reset'                                               # unstage / reset
abbr -S grhh='git reset --hard'                                       # hard reset
abbr -S grhpa='git reset --patch'                                     # interactively unstage hunks

# --- rm / restore -----------------------------------------------------------
abbr -S grm='git rm'                                                   # remove file from working tree + index
abbr -S grmc='git rm --cached'                                         # unstage file but keep on disk
abbr -S grs='git restore'                                              # restore file(s)
abbr -S grss='git restore --source'                                    # restore from a given source
abbr -S grst='git restore --staged'                                    # unstage file(s)

# --- show / status -----------------------------------------------------------
abbr -S gsh='git show'                                                  # show a commit
abbr -S gsd='git svn dcommit'                                          # svn: commit to svn
abbr -S gsr='git svn rebase'                                           # svn: rebase
abbr -S gsb='git status -sb'                                           # short status w/ branch
abbr -S gss='git status -s'                                            # short status
abbr -S gst='git status'                                               # status

# --- stash -----------------------------------------------------------------
abbr -S gsta='git stash'                                                # stash changes
abbr -S gstd='git stash drop'                                          # drop a stash
abbr -S gstl='git stash list'                                          # list stashes
abbr -S gstp='git stash pop'                                           # pop top stash
abbr -S gsts='git stash show --text'                                   # show stash contents as diff

# --- submodule -----------------------------------------------------------------
abbr -S gsu='git submodule update'                                      # update submodules
abbr -S gsur='git submodule update --recursive'                         # update submodules, recursive
abbr -S gsuri='git submodule update --recursive --init'                 # init + update submodules, recursive

# --- tag -----------------------------------------------------------------
abbr -S gts='git tag -s'                                                # create a signed tag
abbr -S gtv='git tag | sort -V'                                         # list tags, version-sorted

# --- switch -----------------------------------------------------------------
abbr -S gsw='git switch'                                                # switch branch
abbr -S gswc='git switch --create'                                     # create + switch to new branch

# --- misc / pull variants -----------------------------------------------------
abbr -S gunignore='git update-index --no-assume-unchanged'             # stop ignoring tracked file changes
abbr -S gup='git pull --rebase'                                        # pull with rebase
abbr -S gupv='git pull --rebase -v'                                    # pull with rebase, verbose
abbr -S gupa='git pull --rebase --autostash'                           # pull with rebase, autostash local changes
abbr -S gupav='git pull --rebase --autostash -v'                       # pull with rebase + autostash, verbose
abbr -S gwch='git whatchanged -p --abbrev-commit --pretty=medium'      # show changes per commit, patch form

# ============================================================================
# git checkout
# ============================================================================
abbr -S gco='git checkout'                                              # checkout a branch/commit
abbr -S gcb='git checkout -b'                                           # create + checkout new branch
abbr -S gcod='git checkout develop'                                     # checkout develop branch
abbr -S gcom='git checkout $(git rev-parse --abbrev-ref HEAD)'          # checkout current branch by name (see note below)

# ============================================================================
# git flow
# ============================================================================
abbr -S gfb='git flow bugfix'                                           # git-flow bugfix
abbr -S gff='git flow feature'                                          # git-flow feature
abbr -S gfr='git flow release'                                          # git-flow release
abbr -S gfh='git flow hotfix'                                           # git-flow hotfix
abbr -S gfs='git flow support'                                          # git-flow support
abbr -S gfbs='git flow bugfix start'                                    # start a bugfix branch
abbr -S gffs='git flow feature start'                                   # start a feature branch
abbr -S gfrs='git flow release start'                                   # start a release branch
abbr -S gfhs='git flow hotfix start'                                    # start a hotfix branch
abbr -S gfss='git flow support start'                                   # start a support branch
abbr -S gfbt='git flow bugfix track'                                    # track a remote bugfix branch
abbr -S gfft='git flow feature track'                                   # track a remote feature branch
abbr -S gfrt='git flow release track'                                   # track a remote release branch
abbr -S gfht='git flow hotfix track'                                    # track a remote hotfix branch
abbr -S gfst='git flow support track'                                   # track a remote support branch
abbr -S gfp='git flow publish'                                          # publish current git-flow branch

# ============================================================================
# git worktree
# ============================================================================
abbr -S gwt='git worktree'                                              # worktree
abbr -S gwta='git worktree add'                                         # add a worktree
abbr -S gwtls='git worktree list'                                       # list worktrees
abbr -S gwtlo='git worktree lock'                                       # lock a worktree
abbr -S gwtmv='git worktree move'                                       # move a worktree
abbr -S gwtpr='git worktree prune'                                      # prune stale worktree info
abbr -S gwtrm='git worktree remove'                                     # remove a worktree
abbr -S gwtulo='git worktree unlock'                                    # unlock a worktree

# ============================================================================
# GitLab push options
# ============================================================================
abbr -S gmr='git push origin $(git rev-parse --abbrev-ref HEAD) --set-upstream -o merge_request.create'  # push + open GitLab MR
abbr -S gmwps='git push origin $(git rev-parse --abbrev-ref HEAD) --set-upstream -o merge_request.create -o merge_request.merge_when_pipeline_succeeds'  # push + open MR + merge when pipeline succeeds
