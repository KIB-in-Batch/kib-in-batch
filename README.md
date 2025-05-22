## Kali in Batch

A simulated Kali Linux environment in Batch and PowerShell.

### Dependencies

- [Nmap](https://nmap.org/)
- [Git for Windows](https://git-scm.com/download/win) (make sure you get Git Bash and use a system-wide installation)
- [Vim (optional)](https://www.vim.org/download.php)
- [PowerShell 7+](https://github.com/PowerShell/PowerShell/releases) (or you can get it from Microsoft Store)

### Usage

Clone the repository:
```bash
git clone https://github.com/Kali-in-Batch/kali-in-batch.git
```
```bash	
cd kali-in-batch
```

Then, run `kali_in_batch.bat` inside the src directory. For proper functionality, don't move it out of the src directory.

Do not run any of the PowerShell scripts manually, as they require special arguments given by `kali_in_batch.bat`.

Once you have set up Kali in Batch, try installing this package in the Kali in Batch shell:
```bash
pkg install elf-exec
```
This package allows you to execute Linux binaries.
Run it:
```bash
pkg-exec elf-exec
```

### Quick tutorial

#### During the Kali in Batch installer

- Press Windows + R
- Type diskmgmt.msc
- Shrink any drive with any amount of space
- Create a drive in the unallocated space
- Type the drive letter of the new drive in the Kali in Batch installer
- Press Enter
- After this, Kali in Batch should be automatically set up

#### After installation

Try the following commands:

```bash
ls
```
```bash
cd /
```
```bash
cd ~
```
```bash
pwd
```
```bash
ls -l
```
```bash
cd ..
```
```bash
uname -a
```
```bash
whoami
```
```bash
git --version
```
```bash
pkg install hello-world
```
```bash
pkg-exec hello-world
```

These should help you get familiar with the shell. If you're already familiar with Linux shells, only do the package manager commands.

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
