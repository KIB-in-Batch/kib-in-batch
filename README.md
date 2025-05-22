## Kali in Batch

A simulated Kali Linux environment in Batch and PowerShell.

### Table of Contents
- [Dependencies](#dependencies)
- [Downloading Kali in Batch](#downloading-kali-in-batch)
- [Setting up Kali in Batch](#setting-up-kali-in-batch)
- [Using Kali in Batch](#using-kali-in-batch)
- [Features](#features)

### Dependencies

- [Nmap](https://nmap.org/)
- [Git for Windows](https://git-scm.com/download/win) (make sure you get Git Bash and use a system-wide installation)
- [Vim (optional)](https://www.vim.org/download.php)
- [PowerShell 7+](https://github.com/PowerShell/PowerShell/releases) (or you can get it from Microsoft Store)

### Downloading Kali in Batch

Clone the repository:
```bash
git clone https://github.com/Kali-in-Batch/kali-in-batch.git
```
```bash	
cd kali-in-batch
```
Or if you don't want the entire repository and just want the code, you can click these buttons:

[![zip](https://img.shields.io/badge/kali__in__batch.zip-blue?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/kali_in_batch.zip)
[![tar.gz](https://img.shields.io/badge/kali__in__batch.tar.gz-green?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/kali_in_batch.tar.gz)

Then, run `kali_in_batch.bat` inside the src directory. For proper functionality, don't move it out of the src directory.

Do not run any of the PowerShell scripts manually, as they require special arguments given by `kali_in_batch.bat`.

### Setting up Kali in Batch

#### During the Kali in Batch installer

- Press Windows + R
- Type diskmgmt.msc
- Shrink any drive with any amount of space
- Create a drive in the unallocated space
- Type the drive letter of the new drive in the Kali in Batch installer
- Press Enter
- After this, Kali in Batch should be automatically set up

#### After installation

You may want to run Linux binaries. For that, run this in the Kali in Batch shell:
```bash
pkg install elf-exec
```
You can then run it by:
```bash
pkg-exec elf-exec
```
If you're not familiar with Linux shells, see [Using Kali in Batch](#using-kali-in-batch).

### Using Kali in Batch

#### Quick introduction

- ls - list files and directories
- cd - change directory
- cp - copy files
- mv - move files
- rm - remove files
- mkdir - make directory
- rmdir - remove directory
- clear - clear the screen
- exit - exit the shell

#### Using nmap in Kali in Batch

You can use it just like you would in a normal Kali Linux environment:
```bash	
nmap -v scanme.nmap.org
```
```bash
nmap --help
```
#### Using Git in Kali in Batch

You should be able to use Git normally. See the [Git documentation](https://git-scm.com/doc) for more information.


#### Ping

Since this uses the Windows ping command, it may differ from the Linux ping command.
Run this:
```bash
ping --help
```

#### Editing files

You can use any text editor, like you would anywhere. So if you want to use something like [MS Edit](https://github.com/microsoft/edit):

```bash
edit file.txt
```

### Features

- [x] Networking with ping and nmap
- [x] Package management with pkg
- [x] File management with cp, mv, rm, and mkdir
- [x] Text editing with vim or any other text editor
- [x] Terminal control with clear, exit, and help
- [x] System information with uname and whoami
- [x] Version control with Git

---

This project is **NOT** associated with Kali Linux or any of it's contributors.
