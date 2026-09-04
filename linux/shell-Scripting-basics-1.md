# Shell Scripting Basics

## What is Shell Scripting?

Shell scripting is the process of writing a series of Linux commands in a file so that they can be executed automatically.

Shell scripting is very important in **DevOps** because automation reduces repetitive manual work and helps improve consistency and efficiency.

Shell scripts can be used for tasks such as:

* Automating repetitive tasks
* Monitoring systems
* Deploying applications
* Provisioning files and directories
* Managing servers
* Performing backups
* Installing and configuring software

---

# Requirements for Practicing Shell Scripting

To practice shell scripting, we need a Linux environment.

For example:

* AWS EC2 Linux instance
* Virtual Machine running Linux
* WSL with Ubuntu
* Any Linux server

In my practice, I used an **AWS EC2 Linux environment** and connected to it using SSH.

---

# Basic Commands Practiced

## `touch`

Creates an empty file.

```bash
touch test.txt
```

---

## `ls -ltr`

Lists files and directories with detailed information and sorts them based on modification time.

```bash
ls -ltr
```

---

## `man`

Displays the manual/help page for a Linux command.

```bash
man ls
```

Example:

```bash
man chmod
```

This helps understand the command, its options, and how to use it.

---

## `pwd`

Shows the current working directory.

```bash
pwd
```

---

## `cd`

Used to move between directories.

```bash
cd /home
```

Move one level up:

```bash
cd ..
```

---

## Creating and Removing Files

Create a file:

```bash
touch test.txt
```

Remove a file:

```bash
rm test.txt
```

---

## Creating and Removing Directories

Create a directory:

```bash
mkdir devops
```

Remove an empty directory:

```bash
rmdir devops
```

---

# Creating and Editing a Shell Script

A shell script normally has the `.sh` extension.

Example:

```bash
vi script.sh
```

Inside the script, we can write Linux commands.

---

# Shebang

A **shebang** specifies which interpreter should be used to execute the script.

For Bash:

```bash
#!/bin/bash
```

Example:

```bash
#!/bin/bash

echo "Hello DevOps"
```

The first line tells Linux to use the **Bash interpreter** to execute the script.

Other shell interpreters include:

```text
bash
sh
ksh
```

Bash is very commonly used for Linux administration and DevOps automation.

---

# `echo` Command

The `echo` command prints text or values to the terminal.

Example:

```bash
echo "Hello World"
```

Output:

```text
Hello World
```

It is commonly used in shell scripts to display messages and command results.

---

# Vim Basics

`vi` or `vim` can be used to create and edit shell scripts.

Open a script:

```bash
vi script.sh
```

### Insert Mode

Press:

```text
i
```

to enter **Insert Mode** and start typing/editing.

### Save and Exit

```text
:wq
```

* `w` → write/save
* `q` → quit

### Quit Without Saving

```text
:q!
```

This exits Vim without saving the changes.

---

# Making a Script Executable

A newly created script may not have execute permission.

We can give it execute permission using `chmod`.

```bash
chmod +x script.sh
```

Then execute it:

```bash
./script.sh
```

---

# Linux File Permissions

Linux permissions determine who can **read, write, or execute** a file.

There are three main permission categories:

```text
User (Owner)
Group
Others
```

The three basic permissions are:

```text
r = Read
w = Write
x = Execute
```

Permission values:

```text
r = 4
w = 2
x = 1
```

Therefore:

```text
7 = 4 + 2 + 1 = read + write + execute
6 = 4 + 2 = read + write
5 = 4 + 1 = read + execute
4 = read
```

Example:

```bash
chmod 755 script.sh
```

This means:

```text
Owner  → 7 → read + write + execute
Group  → 5 → read + execute
Others → 5 → read + execute
```

The `chmod` command is used to **change permissions** of files and directories.

---

# `history`

The `history` command displays previously executed commands.

```bash
history
```

This is especially useful when working with a remote Linux server through an SSH session because it allows us to review commands that were previously executed.

---

# Monitoring Commands

I also practiced basic Linux commands for checking system resources.

## `top`

Displays real-time information about running processes and system resource usage.

```bash
top
```

It can be used to monitor:

* CPU usage
* Memory usage
* Running processes
* System load

---

## `free`

Displays memory usage.

```bash
free
```

To display memory in GB:

```bash
free -g
```

It shows information about:

* Total memory
* Used memory
* Free memory
* Available memory
* Swap

---

## `nproc`

Displays the number of available processing units / virtual CPUs.

```bash
nproc
```

Example:

```text
2
```

This means the system has 2 available processing units.

---

# Practical Shell Script I Created

I created a small shell script as a practical exercise.

The script:

1. Creates a directory
2. Enters the directory
3. Creates two files inside the directory

Example:

```bash
#!/bin/bash

mkdir devops
cd devops
touch file1.txt
touch file2.txt

echo "Directory and files created successfully"
```

Running the script automatically performs all these tasks instead of executing each command manually.

### Manual approach

```text
mkdir devops
cd devops
touch file1.txt
touch file2.txt
```

### Shell scripting approach

```text
Run one script
      ↓
Directory created
      ↓
Files created automatically
```

This demonstrates the basic purpose of **automation using shell scripting**.

---

# Why Shell Scripting is Important for DevOps

DevOps involves performing many repetitive operational tasks. Shell scripting allows these tasks to be automated.

For example:

```text
Shell Script
     ↓
Create directories
     ↓
Copy files
     ↓
Change permissions
     ↓
Start/stop services
     ↓
Check system resources
     ↓
Deploy application
```

Shell scripting is therefore an important foundational skill for a DevOps engineer.

---

# What I Learned Today

Today I learned and practically practiced:

* What shell scripting is
* Why automation is important in DevOps
* Creating `.sh` files
* Shebang (`#!/bin/bash`)
* Bash and other shell interpreters
* `echo`
* `touch`
* `ls -ltr`
* `man`
* `pwd`
* `cd`
* `mkdir`
* `rmdir`
* `rm`
* Vim/vi
* Insert mode
* Saving and exiting Vim using `:wq`
* Exiting without saving using `:q!`
* `chmod`
* Linux file permissions
* User, group, and others permissions
* Permission values `4`, `2`, and `1`
* `history`
* `top`
* `free`
* `free -g`
* `nproc`
* Creating and executing a basic shell script
* How shell scripting can automate repetitive DevOps tasks

## Practical Exercise Completed

I created and executed a shell script that automatically created a directory and two files inside it.

This helped me understand how individual Linux commands can be combined into a script to perform tasks automatically.
