# Linux Basics

## What is Linux?

Linux is a **free and open-source operating system** based on the Linux kernel.

Linux is known for its **stability, security, flexibility, and performance**. Because of these characteristics, Linux is widely used in:

* Servers
* Cloud environments
* Networking
* DevOps
* Containers
* Embedded systems

Linux is generally less targeted by traditional desktop malware than Windows, but it is **not completely immune to viruses or other security threats**. Proper security practices are still required.

### Linux Distributions

Linux comes in many different distributions (distros), which package the Linux kernel together with system utilities, libraries, package managers, and applications.

Some popular distributions are:

* Ubuntu
* Debian
* Red Hat Enterprise Linux (RHEL)
* Fedora
* Amazon Linux
* Rocky Linux
* AlmaLinux

---

# Basic Linux Architecture

A simplified overview of Linux can be represented as:

```text
User
  ↓
Applications
  ↓
System Software / Utilities
  ↓
System Libraries
  ↓
Kernel
  ↓
Hardware
```

Other important components, such as **compilers**, are used to develop and build applications that run on the operating system.

## 1. Kernel

The **kernel is the core component of the operating system**.

It acts as an intermediate layer between **software and hardware** and manages important system resources such as:

* CPU
* Memory (RAM)
* Storage
* Processes
* Networking
* Hardware devices

For example:

```text
Application
     ↓
System Call
     ↓
Linux Kernel
     ↓
Hardware
```

If an application needs to read a file from a disk, the kernel manages the interaction with the storage device.

---

## 2. System Libraries

**System libraries are collections of pre-written code and functions** that applications can use to perform common operating-system tasks.

Instead of every application writing its own code to communicate with the operating system, it can use functions provided by system libraries.

For example, when an application wants to:

* Read a file
* Write a file
* Allocate memory
* Create a process
* Communicate over a network

it can use functions provided by system libraries.

A simple flow is:

```text
Application
     ↓
System Library
     ↓
Kernel
     ↓
Hardware
```

A common Linux system library is **glibc (GNU C Library)**.

---

## 3. System Software / Utilities

System software provides tools and utilities that allow users and administrators to interact with and manage the operating system.

Examples include:

```bash
ls
cd
cp
mv
rm
cat
ps
top
```

These utilities help users perform tasks such as managing files, monitoring processes, and navigating the system.

---

## 4. Compilers

A **compiler** converts human-readable source code into machine-executable code or an intermediate form that can be executed by the computer.

For example:

```text
Source Code
     ↓
Compiler
     ↓
Machine Code / Executable
     ↓
CPU
```

A common compiler used on Linux is **GCC (GNU Compiler Collection)**.

For example, a C program can be compiled using:

```bash
gcc program.c -o program
```

This produces an executable program that can be run on the system.

---

# Key Takeaways

* **Linux** is a free and open-source operating system.
* **Linux distributions** include Ubuntu, Debian, RHEL, Amazon Linux, etc.
* **Kernel** is the core of the operating system and manages hardware and system resources.
* **System libraries** provide pre-written functions that applications can use to interact with the OS.
* **System utilities** provide commands for managing the Linux system.
* **Compilers** convert source code into executable/machine code.
* Linux is widely used in **servers, cloud computing, networking, and DevOps**.
