## Kali in Batch

A simulated Kali Linux environment in Batch and PowerShell.

[![Upload src to release](https://github.com/Kali-in-Batch/kali-in-batch/actions/workflows/upload_src_to_release.yml/badge.svg)](https://github.com/Kali-in-Batch/kali-in-batch/actions/workflows/upload_src_to_release.yml)

### Table of Contents
- [Dependencies](#dependencies)
- [Downloading Kali in Batch](#downloading-kali-in-batch)
- [Setting up Kali in Batch](#setting-up-kali-in-batch)
- [Using Kali in Batch](#using-kali-in-batch)
- [Uninstalling Kali in Batch](#uninstalling-kali-in-batch)
- [Features](#features)

### Dependencies

- [Nmap](https://nmap.org/)
- [Neovim](https://neovim.io/)
- [PowerShell 7+](https://github.com/PowerShell/PowerShell/releases)

*The dependencies are automatically installed during the Kali in Batch installer, so you don't need to install them manually.*

### Downloading Kali in Batch

You should download the latest releases from these buttons:

[![zip](https://img.shields.io/badge/kali__in__batch.zip-blue?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/kali_in_batch.zip)
[![tar.gz](https://img.shields.io/badge/kali__in__batch.tar.gz-green?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/kali_in_batch.tar.gz)

Then, run `kali_in_batch.bat` inside the src directory. For proper functionality, don't move it out of the src directory.

Do not run any of the PowerShell scripts manually, as they require special arguments given by `kali_in_batch.bat`.

*Note that the archives in the releases are created with a GitHub workflow that adds the msys runtime and Bash to the archive, meaning you must package these manually if you want to use `git clone` instead of the archives. For the VERY latest features, you can try an unstable build that is created on every push to the dev branch. You can find it as an artifact [here](https://github.com/Kali-in-Batch/kali-in-batch/actions/workflows/build_unstable.yml).*

### Setting up Kali in Batch

#### During the Kali in Batch installer

- It will be automatically installed along with it's dependencies. Root filesystem for Kali in Batch is '%USERPROFILE%\kali'.

#### After installation

You may want to run Linux binaries. For that, run this in the Kali in Batch shell:
```bash
pkg install elf-exec
```
You can then run it by:
```bash
elf-exec
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

### Uninstalling Kali in Batch

You can just download [uninstall.bat](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/uninstall.bat) and run it.

### Features

- [x] Networking with ping and nmap
- [x] Package management with pkg
- [x] File management with cp, mv, rm, and mkdir
- [x] Text editing with vim or any other text editor
- [x] Terminal control with clear, exit, and help
- [x] System information with uname and whoami

---

This project is **NOT** associated with Kali Linux or any of it's contributors.
