# Kali in Batch

Kali in Batch is a batch script-based environment that runs a bash shell with many Kali Linux utilities.

[![CI/CD](https://github.com/Kali-in-Batch/kali-in-batch/actions/workflows/cicd.yml/badge.svg)](https://github.com/Kali-in-Batch/kali-in-batch/actions/workflows/cicd.yml)

⭐ If you like this project or want to support development, please give it a star!

## Installation

* Download a source code archive from the [latest release](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest).
* Run [`src/kali_in_batch.bat`](./src/kali_in_batch.bat) to start the environment and perform the initial setup.
* During the first run, you will be prompted to assign a drive letter to the root filesystem (e.g., Z:). This drive letter will be used to mount the Kali root filesystem.
* The installer will automatically download dependencies such as Nmap and Neovim using winget.
* The environment will download and set up BusyBox automatically.

## Features

* Bash environment with a Kali Linux style shell prompt.
* Comes with Kali Linux utilities you would expect, including:
  * Netcat
  * Nmap
  * Whois
  * Usable shell scripting environment
* Simple package manager accessible via the `kib-pkg` command.
* Update checking mechanism that compares local and remote versions to notify if the installation is outdated.
* Custom shell prompt and aliases for common commands to enhance usability.
* [POSIX API reimplementations](./src/lib/posix/README.md).

## Usage

1. Run [`src/kali_in_batch.bat`](./src/kali_in_batch.bat) to launch the Kali in Batch shell.
2. On first run, follow the prompts to assign a drive letter and complete setup.
3. Login with your username or root when prompted.
4. Once setup is complete, enjoy the bash shell with Kali Linux utilities.

## Preview

<details>
<summary>Terminal Screenshots</summary>

![Terminal screenshot showing a user listing and displaying the contents of posix_test.c, a C source file. The code demonstrates POSIX file I/O operations including opening, writing, reading, and closing a file named testfile.txt. The terminal prompt is green and blue, indicating the user benja is working in the tests directory. The environment is a dark-themed terminal window. The code includes comments and error handling, and prints the number of bytes written and read. The overall tone is technical and focused on programming tasks.](./assets/image1.png)

![Terminal window showing a user compiling and running a C program named posix_test.c. The terminal displays compiler warnings about macro redefinition and format specifiers for ssize_t types, followed by successful output: Wrote 27 bytes and Read 27 bytes: POSIX file I/O test string. The prompt is green and blue, indicating the user benja is in the tests directory. The environment is a dark-themed terminal, and the overall tone is technical and focused on programming tasks.](./assets/image2.png)

![Terminal window displaying the results of an nmap scan on scanme.nmap.org. The output shows several open TCP ports including SSH on port 22, HTTP on port 80, nping-echo on port 9929, and Elite on port 31337. Some ports such as telnet and SMTP are filtered. The scan summary indicates one IP address was scanned in 8.63 seconds. The terminal prompt is green and blue, showing the user benja is working in a dark-themed environment. The tone is technical and focused on network security tasks.](./assets/image3.png)

![Terminal window displaying the output of kibfetch, a system information tool. The left side shows a large ASCII art logo reading KIB. The right side lists system details: user benja at ACERB, OS Kali in Batch 9.10.1, kernel KALI_IN_BATCH_Windows_NT, root Z:/, CPU architecture AMD64, identifier Intel64 Family 6 Model 141 Stepping 1 GenuineIntel, CPU level 6, 12 CPU cores, revision 8d01. The prompt is green and blue, indicating user benja is in the home directory. The environment is a dark-themed terminal, and the tone is technical and focused on system configuration and hardware information.](./assets/image4.png)

</details>

## License

This project is licensed under the GPL-2.0-only License. See the [LICENSE.txt](./LICENSE.txt) file for details.

## Links

* [GitHub Repository](https://github.com/Kali-in-Batch/kali-in-batch)
* [Latest Releases](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest)

## FAQ

### What is Kali in Batch?

Kali in Batch is a batch script-based environment that runs a bash shell with many Kali Linux utilities on Windows.

### How do I install Kali in Batch?

Download the latest release from the [releases page](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest), run [`src/kali_in_batch.bat`](./src/kali_in_batch.bat), and follow the prompts to assign a drive letter and complete setup.

### How do I update Kali in Batch?

Kali in Batch checks for updates on startup. For minor updates, download the latest release and run `.\src\kali_in_batch.bat`. For major updates, uninstall first using `.\uninstall.bat` then reinstall.

### How do I uninstall Kali in Batch?

Run the `uninstall.bat` script from the extracted release directory in PowerShell or Command Prompt.

### How do I manage packages?

Use the `kib-pkg` command to install, remove, upgrade, search, and list packages. For example, `kib-pkg install <package-name>`.

### Can I use Kali in Batch utilities outside the environment?

Yes, many utilities are available in the `/usr/bin` directory and can be used from Windows command prompt by referencing their full path or adding them to your system PATH.

### What ethical hacking tools are included?

Kali in Batch includes tools like Nmap, Ncat, and a Metasploit Framework wrapper (`msfconsole`) for ethical hacking and penetration testing.

### Is Kali in Batch a full Linux system?

No, it is a batch script environment that mimics many Linux utilities and behaviors but runs on Windows with some limitations.

### Where can I find POSIX API reimplementations?

POSIX API batch file implementations are located in `/usr/lib/posix` and the header files are located in `/usr/include`. See [src/lib/posix/README.md](./src/lib/posix/README.md) for details.

### Help, the symlinks cannot be created

This is because you didn't run the file as Administrator when developer mode was disabled. Run the file as Administrator or enable developer mode to create symlinks.

### Is Kali in Batch affiliated with Kali Linux?

No, this project is not associated with Kali Linux.
