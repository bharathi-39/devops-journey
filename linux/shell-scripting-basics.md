# Shell Scripting Basics

## Overview

This repository documents my hands-on practice with Linux commands and shell scripting using an AWS EC2 Linux instance.

The objective of this practice was to understand how individual Linux commands can be combined into shell scripts to automate repetitive system administration and DevOps tasks.

---

## What Is Shell Scripting?

Shell scripting is the process of writing a sequence of Linux commands in a file so that the commands can be executed automatically.

Instead of running each command manually, we can place the commands inside a script and execute the complete workflow using a single command.

Shell scripting is important in DevOps because automation:

- Reduces repetitive manual work
- Improves consistency
- Saves operational effort
- Minimizes human errors
- Makes infrastructure tasks repeatable
- Supports faster deployments and troubleshooting

Shell scripts can be used for:

- Automating repetitive tasks
- Monitoring systems and servers
- Deploying applications
- Creating files and directories
- Managing Linux servers
- Performing backups
- Installing and configuring software
- Starting and stopping services
- Collecting logs and system information

---

## Practice Environment

A Linux environment is required to practice shell scripting.

Common options include:

- AWS EC2 Linux instance
- Linux virtual machine
- Windows Subsystem for Linux with Ubuntu
- Physical Linux machine
- Remote Linux server

For this practice, I used an **AWS EC2 Linux instance** and connected to it through SSH.

Example SSH command:

```bash
ssh -i "path/to/private-key.pem" ubuntu@<public-ip-address>
```

---

## Basic Linux Commands Practiced

### `pwd`

Displays the current working directory.

```bash
pwd
```

Example output:

```text
/home/ubuntu
```

---

### `ls -ltr`

Lists files and directories with detailed information and sorts them by modification time.

```bash
ls -ltr
```

The options have the following meanings:

- `l`: Long listing format
- `t`: Sort by modification time
- `r`: Reverse the order

---

### `cd`

Changes the current working directory.

Move to a specific directory:

```bash
cd /home
```

Move one directory level up:

```bash
cd ..
```

Move to the current user's home directory:

```bash
cd ~
```

---

### `touch`

Creates an empty file if the file does not already exist.

```bash
touch test.txt
```

If the file already exists, `touch` updates its timestamp.

---

### `man`

Displays the manual page for a Linux command.

```bash
man ls
```

Another example:

```bash
man chmod
```

The manual page provides information about:

- Command purpose
- Syntax
- Available options
- Usage details

Press `q` to exit the manual page.

---

### `history`

Displays commands that were previously executed in the shell.

```bash
history
```

This is useful while working on remote Linux servers because it allows us to review and reuse previously executed commands.

Run a particular command from history:

```bash
!25
```

This runs command number `25` from the history output.

---

## Creating and Removing Files

Create an empty file:

```bash
touch test.txt
```

Remove a file:

```bash
rm test.txt
```

Display the contents of a file:

```bash
cat test.txt
```

> **Warning:** Files removed using `rm` are normally not moved to a recycle bin. Always verify the filename before running the command.

---

## Creating and Removing Directories

Create a directory:

```bash
mkdir devops
```

Create nested directories:

```bash
mkdir -p devops/scripts
```

Remove an empty directory:

```bash
rmdir devops
```

Remove a directory and its contents:

```bash
rm -r devops
```

Forcefully remove a directory and everything inside it:

```bash
rm -rf devops
```

> **Warning:** `rm -rf` permanently removes the specified directory and its contents. Carefully verify the path before executing it.

---

## Creating a Shell Script

Shell scripts commonly use the `.sh` file extension.

Create a script using Vim:

```bash
vi script.sh
```

A basic shell script looks like this:

```bash
#!/bin/bash

echo "Hello DevOps"
```

---

## Shebang

A shebang is the first line of a script that specifies which interpreter should execute it.

Bash shebang:

```bash
#!/bin/bash
```

Complete example:

```bash
#!/bin/bash

echo "Hello DevOps"
```

When the script is executed directly, Linux reads the shebang and uses the specified Bash executable to interpret the commands.

Common shell interpreters include:

| Shell | Typical Executable | Description |
|---|---|---|
| Bash | `/bin/bash` | Feature-rich shell commonly used in Linux and DevOps |
| SH | `/bin/sh` | Standard POSIX-compatible shell interface |
| Dash | `/bin/dash` | Lightweight POSIX shell commonly used for system scripts |
| KSH | `/bin/ksh` | Korn Shell, found in some Unix and enterprise environments |

Scripts that use Bash-specific features should use:

```bash
#!/bin/bash
```

They should not be executed with `sh script.sh` because `/bin/sh` may point to Dash, which does not support every Bash-specific feature.

---

## The `echo` Command

The `echo` command displays text or variable values in the terminal.

Example:

```bash
echo "Hello World"
```

Output:

```text
Hello World
```

Write text to a file:

```bash
echo "Hey, how are you?" > message.txt
```

View the file:

```bash
cat message.txt
```

Output:

```text
Hey, how are you?
```

Append text without replacing the existing content:

```bash
echo "Welcome to shell scripting" >> message.txt
```

---

## Vim Basics

Vim or Vi can be used to create and edit shell scripts.

Open a file:

```bash
vi script.sh
```

### Enter Insert Mode

Press:

```text
i
```

This allows you to type and edit the file.

### Save and Exit

Press `Esc`, type the following command, and press `Enter`:

```vim
:wq
```

- `w`: Write or save
- `q`: Quit

### Quit Without Saving

Press `Esc`, type the following command, and press `Enter`:

```vim
:q!
```

### Save Without Exiting

```vim
:w
```

---

## Making a Script Executable

A newly created file may not have execute permission.

Add execute permission:

```bash
chmod +x script.sh
```

Execute the script:

```bash
./script.sh
```

Alternatively, the script can be passed directly to Bash:

```bash
bash script.sh
```

When using `bash script.sh`, execute permission is not required because the Bash executable is being asked to read the script directly.

---

## Linux File Permissions

Linux file permissions control who can read, write, or execute a file or directory.

There are three permission categories:

1. **User**, also called the owner
2. **Group**
3. **Others**

The three basic permissions are:

| Permission | Symbol | Numeric Value |
|---|---:|---:|
| Read | `r` | `4` |
| Write | `w` | `2` |
| Execute | `x` | `1` |

Permission values are calculated by adding the required values:

| Value | Permission | Meaning |
|---:|---|---|
| `7` | `rwx` | Read, write, and execute |
| `6` | `rw-` | Read and write |
| `5` | `r-x` | Read and execute |
| `4` | `r--` | Read only |
| `0` | `---` | No permission |

### Example: `chmod 755`

```bash
chmod 755 script.sh
```

Meaning:

| Category | Value | Permission |
|---|---:|---|
| Owner | `7` | Read, write, and execute |
| Group | `5` | Read and execute |
| Others | `5` | Read and execute |

The `chmod` command stands for **change mode** and is used to modify file and directory permissions.

Check permissions:

```bash
ls -l script.sh
```

Example output:

```text
-rwxr-xr-x 1 ubuntu ubuntu 120 Sep 4 10:30 script.sh
```

---

## System Monitoring Commands

I also practiced basic Linux commands for checking the health and resource usage of a Linux node.

### `top`

Displays real-time system and process information.

```bash
top
```

It can be used to monitor:

- CPU usage
- Memory usage
- Running processes
- Process IDs
- System uptime
- System load
- Resource-consuming processes

Useful keys while using `top`:

- `P`: Sort processes by CPU usage
- `M`: Sort processes by memory usage
- `q`: Quit

---

### `free`

Displays physical memory and swap usage.

```bash
free
```

Display memory in a human-readable format:

```bash
free -h
```

Display memory using GiB units:

```bash
free -g
```

The output contains:

- Total memory
- Used memory
- Free memory
- Shared memory
- Buffer and cache memory
- Available memory
- Swap usage

`free -h` is generally easier to read because it automatically selects suitable units.

---

### `nproc`

Displays the number of processing units available to the current process.

```bash
nproc
