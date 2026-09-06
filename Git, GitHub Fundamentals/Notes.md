# Git – Complete Notes

## 1. What is Version Control?

A **Version Control System (VCS)** is a system used to track, manage, and maintain changes made to files over time.

### Why do we need Version Control?

* Track changes in source code
* Maintain different versions of a project
* Roll back to previous versions
* Allow multiple developers to work together
* Maintain a history of changes
* Prevent accidental loss of code
* Support branching and merging

---

# 2. Types of Version Control Systems

## Centralized Version Control System (CVCS)

In a centralized system, there is **one central repository** where the project's version history is maintained.

```text
              Central Repository
                    |
        -------------------------
        |           |           |
      Dev A       Dev B       Dev C
```

Developers need to communicate with the central server for most repository operations.

### Examples

* SVN (Subversion)
* CVS
* Perforce

### Disadvantage

If the central server becomes unavailable, developers may not be able to perform many repository operations.

---

## Distributed Version Control System (DVCS)

In a distributed system, every developer has a **complete copy of the repository and its history** locally.

```text
                Remote Repository
                     |
        ---------------------------
        |            |            |
      Dev A        Dev B        Dev C
      Git           Git           Git
```

### Examples

* Git
* Mercurial

### Advantages

* Work offline
* Faster local operations
* Complete project history available locally
* Easy branching
* Better distributed collaboration
* Changes can be committed without internet access

---

# 3. What is Git?

**Git is a free and open-source Distributed Version Control System (DVCS).**

Git is used to:

* Track changes in source code
* Maintain project history
* Create branches
* Merge changes
* Collaborate with other developers
* Roll back changes
* Manage different versions of a project

Git runs locally on your computer, server, or cloud instance.

Example:

```bash
git init
```

This initializes a directory as a Git repository.

---

# 4. Git vs GitHub

This is an important distinction.

## Git

Git is a **version control software/tool**.

It manages the version history of a project locally.

```text
Developer Machine
       |
      Git
       |
    .git/
```

## GitHub

GitHub is a **cloud-based platform for hosting Git repositories and collaborating with other developers**.

It provides features such as:

* Remote repositories
* Pull Requests
* Code reviews
* Issues
* Collaboration
* Access control
* GitHub Actions (CI/CD)

### Simple Difference

> **Git = Version Control Tool**

> **GitHub = Online Platform for Hosting and Collaborating on Git Repositories**

Git can be used without GitHub.

GitHub uses Git as its underlying version control system.

---

# 5. Git Repository

A **Git repository** is a project that is tracked by Git.

Example:

```text
my-project/
│
├── app.py
├── README.md
├── requirements.txt
│
└── .git/
```

The `.git` directory contains Git's internal information and history.

---

# 6. Git Working Areas

Git can be understood using three main areas:

```text
Working Directory
       |
       | git add
       ↓
Staging Area
       |
       | git commit
       ↓
Local Repository
       |
       | git push
       ↓
Remote Repository
       |
     GitHub
```

---

# 7. Working Directory

The **Working Directory** is where you create and modify files.

Example:

```text
app.py
index.html
README.md
```

When you modify these files, Git detects the changes.

---

# 8. Staging Area

The **Staging Area** contains changes that you want to include in the next commit.

Example:

```bash
git add app.py
```

This moves the changes in `app.py` to the staging area.

---

# 9. Commit

A **commit** is a recorded snapshot of changes in the Git repository.

Example:

```bash
git commit -m "Added login functionality"
```

A commit contains information such as:

* Changes
* Author
* Timestamp
* Commit message
* Commit ID / hash

Example history:

```text
Commit 1 → Created application
     ↓
Commit 2 → Added login
     ↓
Commit 3 → Fixed login bug
```

---

# 10. Push

`git push` sends local commits to a remote repository.

```bash
git push origin main
```

Flow:

```text
Local Repository
       |
   git push
       ↓
GitHub Repository
```

---

# 11. Pull

`git pull` gets changes from a remote repository and integrates them into the current local branch.

```bash
git pull origin main
```

Flow:

```text
GitHub
  |
git pull
  ↓
Local Repository
```

---

# 12. Clone

`git clone` creates a local copy of a remote repository.

Example:

```bash
git clone https://github.com/user/project.git
```

Flow:

```text
GitHub Repository
       |
   git clone
       ↓
Local Machine / EC2
```

A clone normally includes the repository's Git history.

---

# 13. Fork

A **fork** creates your own copy of another user's repository on GitHub.

Example:

```text
Original GitHub Repository
           |
         Fork
           ↓
Your GitHub Repository
           |
        Clone
           ↓
Your Local Machine
```

### Clone vs Fork

| Clone                           | Fork                                   |
| ------------------------------- | -------------------------------------- |
| Creates local copy              | Creates GitHub-side copy               |
| Done using Git                  | Done on GitHub                         |
| Repository goes to your machine | Repository goes to your GitHub account |
| `git clone`                     | GitHub Fork button                     |

---

# 14. Important Git Commands

## `git init`

Initializes a new Git repository.

```bash
git init
```

Creates the `.git` directory.

---

## `git status`

Shows the current state of the working directory and staging area.

```bash
git status
```

It can show:

* Modified files
* Staged files
* Untracked files
* Current branch

---

## `git add`

Moves changes to the staging area.

```bash
git add file.txt
```

Add all changes:

```bash
git add .
```

---

## `git diff`

Shows changes that have not been staged.

```bash
git diff
```

Useful for checking what was changed before committing.

---

## `git commit`

Records staged changes.

```bash
git commit -m "Added new feature"
```

---

## `git log`

Displays commit history.

```bash
git log
```

Compact version:

```bash
git log --oneline
```

---

## `git show`

Shows details of a particular commit.

```bash
git show <commit-id>
```

---

## `git remote`

Shows remote repositories.

```bash
git remote -v
```

Example:

```text
origin  https://github.com/user/project.git
```

`origin` is the default name commonly given to the remote repository.

---

# 15. Basic Git Workflow

A common Git workflow is:

```text
1. Modify files
       ↓
2. git status
       ↓
3. git diff
       ↓
4. git add
       ↓
5. git commit
       ↓
6. git push
       ↓
7. GitHub
```

Example:

```bash
git status

git diff

git add .

git commit -m "Updated application"

git push origin main
```

---

# 16. Branching

A **branch** is an independent line of development.

Branches allow developers to work on features or fixes without directly modifying the main codebase.

Example:

```text
                 main
                  |
        -----------------------
        |          |          |
     feature     feature    hotfix
      /login     /payment
```

### Why are branches important?

* Developers can work independently
* Protect the main branch
* Develop features separately
* Test changes before merging
* Fix bugs without disturbing other development
* Support parallel development

---

# 17. Common Branch Types

These are common team practices, not mandatory Git branches.

### Main Branch

Usually contains stable/production-ready code.

```text
main
```

### Develop Branch

Used by some teams as an integration/development branch.

```text
develop
```

### Feature Branch

Used to develop a particular feature.

```text
feature/login
feature/payment
feature/search
```

### Release Branch

Used to prepare a particular software release.

```text
release/v1.0
```

### Hotfix Branch

Used for urgent production fixes.

```text
hotfix/payment-bug
```

---

# 18. Creating a Branch

```bash
git branch feature/login
```

Create and switch to the branch:

```bash
git checkout -b feature/login
```

Modern alternative:

```bash
git switch -c feature/login
```

---

# 19. Switching Branches

Using checkout:

```bash
git checkout main
```

Modern command:

```bash
git switch main
```

---

# 20. Listing Branches

```bash
git branch
```

List remote branches:

```bash
git branch -r
```

List all:

```bash
git branch -a
```

---

# 21. Delete a Branch

Delete local branch:

```bash
git branch -d feature/login
```

Force delete:

```bash
git branch -D feature/login
```

Delete remote branch:

```bash
git push origin --delete feature/login
```

---

# 22. Rename a Branch

Rename the current branch:

```bash
git branch -m new-name
```

Example:

```bash
git branch -m feature-login
```

---

# 23. Git Merge

`git merge` combines changes from one branch into another branch.

Example:

```bash
git checkout main
git merge feature/login
```

Conceptually:

```text
          feature
         /       \
A---B---C---D-----M
        /
      main
```

### Remember

> **Merge = Combine branch histories**

Merge generally preserves the branching structure in the history.

---

# 24. Git Rebase

`git rebase` moves/replays commits onto a new base.

Example:

Before:

```text
main:       A---B---C
                 \
feature:          D---E
```

After rebase:

```text
A---B---C---D'---E'
```

### Remember

> **Rebase = Replay your commits on top of another branch**

Rebase can create a cleaner, more linear history.

### Important

Avoid rebasing shared/public history unless you understand the consequences, because rebase rewrites commit history.

---

# 25. Merge vs Rebase

| Merge                                      | Rebase                          |
| ------------------------------------------ | ------------------------------- |
| Combines histories                         | Replays commits                 |
| Usually creates a merge commit when needed | Usually creates linear history  |
| Preserves branch structure                 | Rewrites commit history         |
| Safer for shared history                   | Be careful with shared branches |

Simple memory trick:

> **Merge = Join**

> **Rebase = Move**

---

# 26. Git Cherry-Pick

`git cherry-pick` applies a **specific commit** from another branch to your current branch.

Example:

```bash
git cherry-pick abc123
```

Suppose:

```text
Feature Branch:

A---B---C---D
        ↑
     Needed fix
```

Instead of merging the entire branch, you can take only commit `C`.

### Remember

> **Cherry-pick = Select specific commit**

---

# 27. Merge vs Rebase vs Cherry-Pick

| Operation   | Purpose                          |
| ----------- | -------------------------------- |
| Merge       | Combine branches                 |
| Rebase      | Replay commits onto another base |
| Cherry-pick | Apply selected commit(s)         |

Easy memory:

```text
MERGE      → Whole branch
REBASE     → Move/replay branch commits
CHERRY-PICK → Specific commit
```

---

# 28. HTTPS vs SSH

Git repositories can be accessed using HTTPS or SSH.

### HTTPS

```bash
git clone https://github.com/user/project.git
```

### SSH

```bash
git clone git@github.com:user/project.git
```

SSH requires an SSH key pair.

```text
Your Machine
     |
Private Key
     |
     ↓
    SSH
     |
     ↓
  GitHub
     |
Public Key
```

SSH is commonly preferred for regular developer/server access once the key is configured.

---

# 29. `.gitignore`

`.gitignore` tells Git which files/directories should not be tracked.

Example:

```text
.env
*.log
node_modules/
__pycache__/
```

Common things to ignore:

* Passwords
* API keys
* Environment files
* Logs
* Temporary files
* Build files
* Dependency directories

**Never commit secrets such as passwords, API keys, or private credentials.**

---

# 30. Important Git Terminology – Quick Revision

| Term              | Meaning                             |
| ----------------- | ----------------------------------- |
| Git               | Distributed Version Control System  |
| GitHub            | Cloud platform for Git repositories |
| Repository        | Project tracked by Git              |
| Working Directory | Files you are currently modifying   |
| Staging Area      | Changes prepared for commit         |
| Commit            | Recorded snapshot of changes        |
| Push              | Send local commits to remote        |
| Pull              | Get and integrate remote changes    |
| Clone             | Copy remote repository locally      |
| Fork              | Create your own GitHub copy         |
| Branch            | Separate line of development        |
| Merge             | Combine branches                    |
| Rebase            | Replay commits onto another base    |
| Cherry-pick       | Apply specific commit               |
| Remote            | External repository location        |
| `origin`          | Common default name for remote      |
| `.git`            | Git repository metadata             |
| `.gitignore`      | Files Git should ignore             |

---

# 31. Most Important Commands – Cheat Sheet

```bash
# Repository
git init
git clone <url>

# Check changes
git status
git diff

# Stage & commit
git add .
git add <file>
git commit -m "message"

# History
git log
git log --oneline
git show <commit-id>

# Remote
git remote -v
git push origin main
git pull origin main

# Branches
git branch
git branch <branch-name>
git checkout <branch-name>
git checkout -b <branch-name>

# Modern branch commands
git switch <branch-name>
git switch -c <branch-name>

# Merge
git merge <branch-name>

# Rebase
git rebase <branch-name>

# Cherry-pick
git cherry-pick <commit-id>

# Delete branch
git branch -d <branch-name>
git push origin --delete <branch-name>

# Rename branch
git branch -m <new-name>
```

---

# 32. Complete Git Flow – One Example

Suppose you are developing a login feature.

```bash
# Clone project
git clone https://github.com/user/project.git

# Go inside project
cd project

# Create feature branch
git switch -c feature/login

# Make changes
# Edit files...

# Check changes
git status
git diff

# Stage changes
git add .

# Commit
git commit -m "Added login functionality"

# Push feature branch
git push origin feature/login
```

Then on GitHub:

```text
feature/login
      |
      ↓
Pull Request
      |
Code Review
      |
Testing
      |
     Merge
      |
      ↓
    main
```

---

# 33. Git Mental Model

Remember this:

```text
                 GITHUB
                    ↑
                    | git push
                    |
              REMOTE REPOSITORY
                    ↑
                    | git pull / fetch
                    |
              LOCAL REPOSITORY
                    ↑
                    | git commit
                    |
               STAGING AREA
                    ↑
                    | git add
                    |
              WORKING DIRECTORY
                    |
                Edit files
```

And branches allow:

```text
                         main
                          |
             --------------------------
             |            |            |
         feature-A    feature-B      hotfix
             |            |            |
             ↓            ↓            ↓
         Developer     Developer    Developer
             |
             ↓
          Merge/PR
             |
             ↓
            main
```

---

# 34. Git in DevOps

Git is one of the most important foundations of DevOps.

A typical DevOps pipeline can look like:

```text
Developer
    |
    ↓
   Git
    |
    ↓
 GitHub
    |
    ↓
CI/CD Pipeline
    |
    ↓
Build
    |
    ↓
Test
    |
    ↓
Docker
    |
    ↓
AWS / Cloud
    |
    ↓
Production
```

Therefore, learning Git properly is essential before going deeper into:

* Jenkins
* GitHub Actions
* GitLab CI/CD
* Docker
* Kubernetes
* Terraform
* AWS DevOps

---

# 35. Key Points to Remember

> **Git is not GitHub.**

> **Git = Version Control System**

> **GitHub = Platform for hosting and collaborating on Git repositories**

> **Commit = Save a snapshot to local Git history**

> **Push = Send local commits to remote**

> **Pull = Get and integrate remote changes**

> **Clone = Remote repository → Local machine**

> **Fork = Someone else's GitHub repository → Your GitHub account**

> **Branch = Separate line of development**

> **Merge = Combine branches**

> **Rebase = Replay commits on a new base**

> **Cherry-pick = Apply a specific commit**

> **Git can work without GitHub and without internet for local operations.**

---

## Git Learning Status

### ✅ Covered

* Version Control System
* Centralized vs Distributed VCS
* Git
* Git vs GitHub
* Repository
* Working Directory
* Staging Area
* Commit
* Push
* Pull
* Clone
* Fork
* Git commands
* Branching
* Feature/Main/Develop/Release/Hotfix branches
* Merge
* Rebase
* Cherry-pick
* Branch creation/deletion/renaming
* HTTPS
* SSH
* Git on Ubuntu/EC2

### 🔜 Next Git Topics

* `git fetch`
* `git reset`
* `git revert`
* `git stash`
* Merge conflicts
* Pull Requests
* Code review
* `.gitignore`
* Git tags
* GitHub Actions
* Git workflows
* CI/CD with Git
