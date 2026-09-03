# Basic Linux Commands

These are the basic Linux commands I have learned and practiced.

## 1. SSH

**SSH (Secure Shell)** is used to securely connect to a remote Linux server.

```bash
ssh -i <key-file> username@<server-ip>
```

Example:

```bash
ssh -i my-key.pem ec2-user@54.227.193.100
```

The `-i` option specifies the private key used for authentication.

---

## 2. `cd`

Used to **change the current directory**.

```bash
cd /var/log
```

Example:

```bash
cd /home
```

---

## 3. `ls`

Used to **list files and directories**.

```bash
ls
```

Useful option:

```bash
ls -la
```

`-l` → detailed information
`-a` → includes hidden files

---

## 4. `cd ..`

Moves **one directory level up**.

```bash
cd ..
```

Example:

```text
/home/user/documents
        ↓
cd ..
        ↓
/home/user
```

---

## 5. `cd ../..`

Moves **two directory levels up**.

```bash
cd ../..
```

Example:

```text
/home/user/documents/project
        ↓
cd ../..
        ↓
/home
```

---

## 6. `vi`

`vi` is a **text editor** available on Linux systems.

Used to create or edit files.

```bash
vi filename.txt
```

Example:

```bash
vi test.txt
```

---

## 7. `cat`

Used to **display the contents of a file**.

```bash
cat filename.txt
```

Example:

```bash
cat test.txt
```

---

## 8. `mkdir`

Used to **create a new directory**.

```bash
mkdir directory_name
```

Example:

```bash
mkdir devops
```

---

## 9. `rmdir`

Used to **remove an empty directory**.

```bash
rmdir directory_name
```

Example:

```bash
rmdir devops
```

> `rmdir` only works when the directory is empty.

---

## 10. `nproc`

Shows the **number of available CPU processing units**.

```bash
nproc
```

Example output:

```text
2
```

This means the system has 2 available processing units.

---

## 11. `free`

Used to check **RAM (memory) usage**.

```bash
free
```

---

## 12. `free -g`

Displays memory usage in **GB**.

```bash
free -g
```

This makes memory information easier to read.

---

## 13. `rm`

Used to **remove files**.

```bash
rm filename.txt
```

Example:

```bash
rm test.txt
```

To remove a directory and its contents:

```bash
rm -r directory_name
```

> Be careful with `rm` because deleted files may not be recoverable easily.

---

## 14. `touch`

Used to **create an empty file** or update the file's timestamp.

```bash
touch filename.txt
```

Example:

```bash
touch test.txt
```

This creates `test.txt` if it doesn't already exist.

---

# Quick Reference

| Command    | Purpose                                         |
| ---------- | ----------------------------------------------- |
| `ssh -i`   | Connect securely to a remote server using a key |
| `cd`       | Change directory                                |
| `ls`       | List files/directories                          |
| `cd ..`    | Move one directory up                           |
| `cd ../..` | Move two directories up                         |
| `vi`       | Edit/create a file                              |
| `cat`      | Display file contents                           |
| `mkdir`    | Create a directory                              |
| `rmdir`    | Remove an empty directory                       |
| `nproc`    | Show available CPU processing units             |
| `free`     | Show memory usage                               |
| `free -g`  | Show memory usage in GB                         |
| `rm`       | Remove files/directories                        |
| `touch`    | Create an empty file                            |

---

# What I Practiced

I practiced basic Linux commands for:

* Navigating directories
* Creating and deleting files
* Creating and deleting directories
* Viewing file contents
* Editing files
* Checking CPU resources
* Checking memory resources
* Connecting to remote Linux servers using SSH
