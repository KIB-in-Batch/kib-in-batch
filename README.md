# KIB in Batch

KIB in Batch is a batch script-based environment that runs a bash shell with many UNIX® utilities.

*Note: This project used to be named "Kali in Batch", but has been renamed to "KIB in Batch" (a recursive acronym) to avoid confusion with the Kali Linux project and OffSec trademarks.*

[![CI/CD](https://github.com/KIB-in-Batch/kib-in-batch/actions/workflows/cicd.yml/badge.svg)](https://github.com/KIB-in-Batch/kib-in-batch/actions/workflows/cicd.yml)

⭐ If you like this project or want to support development, please give it a star!

## Installation

* Download a source code archive from the [latest release](https://github.com/KIB-in-Batch/kib-in-batch/releases/latest).
* Run [`src/kib_in_batch.bat`](./src/kib_in_batch.bat) to start the environment and perform the initial setup.
* During the first run, you will be prompted to assign a drive letter to the root filesystem (e.g., Z:). This drive letter will be used to mount the KIB root filesystem.
* The installer will automatically download dependencies such as Nmap and Neovim using winget.
* The environment will download and set up BusyBox automatically.

## Features

* Bash environment with a custom shell prompt.
* Comes with utilities you would expect, including:
  * Netcat
  * Nmap
  * Whois
  * Usable shell scripting environment
* Requests admin privileges if cannot create symlinks.
* Simple package manager accessible via the `kib-pkg` command.
* Custom shell prompt and aliases for common commands to enhance usability.
* [POSIX API reimplementations](./src/lib/posix/README.md).
* [BusyBox](https://busybox.net/) for a lightweight, portable set of utilities.
* [Neovim](https://neovim.io/) for a powerful, extensible text editor.
* [Nmap](https://nmap.org/) for network scanning and discovery.
* [KIBDock](./src/bin/kibdock.bat), our own software for managing containers.


## Usage

1. Run [`src/kib_in_batch.bat`](./src/kib_in_batch.bat) to launch the KIB in Batch shell.
2. On first run, follow the prompts to assign a drive letter and complete setup.
3. Login with your username or root when prompted.
4. Once setup is complete, enjoy the bash shell with UNIX® utilities.

## Preview

![Terminal window divided into three panes. Top left pane displays system information: OS: KIB in Batch 9.13.1 x86_64, Kernel: 6.6.87.2-kib, Uptime: 6 hours 42 mins. Top right pane shows CPU details: OS: KIB in Batch 9.13.1, Number of CPU cores: 12. Bottom right pane shows nmap scan results: PORT STATE SERVICE 80/tcp open http 443/tcp open https. The environment is a split terminal interface with command outputs and system diagnostics.](./assets/image.png)

</details>

## License

This project is licensed under the GPL-2.0-only License. See the [LICENSE.txt](./LICENSE.txt) file for details.

## Links

* [GitHub Repository](https://github.com/KIB-in-Batch/kib-in-batch)
* [Latest Releases](https://github.com/KIB-in-Batch/kib-in-batch/releases/latest)

## FAQ

### What is KIB in Batch?

KIB in Batch is a batch script-based environment that runs a bash shell with many UNIX® utilities on Windows.

### How do I install KIB in Batch?

Download the latest release from the [releases page](https://github.com/KIB-in-Batch/kib-in-batch/releases/latest), run [`src/kib_in_batch.bat`](./src/kib_in_batch.bat), and follow the prompts to assign a drive letter and complete setup.

### How do I update KIB in Batch?

For minor updates, download the latest release and run `.\src\kib_in_batch.bat`. For major updates, uninstall first using `.\uninstall.bat` then reinstall. The uninstaller creates a backup of your KIB in Batch home directory which KIB in Batch automatically detects and restores upon reinstalling.

### How do I uninstall KIB in Batch?

Run the `uninstall.bat` script from the extracted release directory in PowerShell or Command Prompt. The uninstaller creates a backup of your KIB in Batch home directory which KIB in Batch automatically detects and restores upon reinstalling.

### How do I manage packages?

Use the `kib-pkg` command to install, remove, upgrade, search, and list packages. For example, `kib-pkg install <package-name>`.

### Can I use KIB in Batch utilities outside the environment?

Yes, many utilities are available in the `/usr/bin` directory and can be used from Windows command prompt by referencing their full path or adding them to your system PATH.

### What ethical hacking tools are included?

KIB in Batch includes tools like Nmap, Ncat, and a Metasploit Framework wrapper (`msfconsole`) for ethical hacking and penetration testing.

### Is KIB in Batch a full Linux system?

No, it is a batch script environment that mimics many Linux utilities and behaviors but runs on Windows with some limitations.

### Where can I find POSIX API reimplementations?

POSIX API batch file implementations are located in `/usr/lib/posix` and the header files are located in `/usr/include`. See [src/lib/posix/README.md](./src/lib/posix/README.md) for details.

### Help, the symlinks cannot be created

This is because you didn't run the file as Administrator when developer mode was disabled. Run the file as Administrator or enable developer mode to create symlinks.

### Is KIB in Batch affiliated with Kali Linux?

No, this project is not associated with KALI LINUX ™.

### What is KIBDock?

KIBDock is our own software for managing containers. When you run it without arguments, it displays the following:

```plaintext
$ kibdock
kibdock [command]

Deploy secure KIB containers.

Commands:
---------
- init                : Enable the KIBDock service.
- uninit              : Disable the KIBDock service. [deletes ALL kibdock data]
- create              : Create a new KIB container.
- deploy              : Deploy a KIB container.
- delete              : Delete a KIB container.
- list                : List all KIB containers.
- list-img            : List all available KIB images.
- help                : Display this help message.

This software is licensed to [USERNAME] under the terms of the GNU General Public License, ONLY version 2 of it.
There is no warranty, without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

List the images using list-img. To create a container, use the create command. To deploy a container, use the deploy command. To delete a container, use the delete command. To list all containers, use the list command. To enable the KIBDock service (do before any other commands!), use the init command. To disable the KIBDock service (deletes all kibdock data!), use the uninit command.

For example, here is how to create a new KIB container called mycontainer using the Ubuntu image:

```plaintext
$ kibdock create
Enter container name: mycontainer
Enter image name: ubuntu
```

Deploy it:

```plaintext
$ kibdock deploy
Enter container name: mycontainer
Deploying container "mycontainer"...
Enter drive letter for container: X:
Welcome to KIBDock on KIB in Batch 10.2.4. Image: ubuntu
If you see this message and a command shell, it means your container has successfully been deployed
wsl: Failed to translate 'Z:\home\benja'
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.6.87.2-microsoft-standard-WSL2 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Aug 14 21:35:18 -04 2025

  System load:  0.37               Processes:             34
  Usage of /:   0.5% of 218.95GB   Users logged in:       0
  Memory usage: 2%                 IPv4 address for eth0: 172.20.220.231
  Swap usage:   0%


This message is shown once a day. To disable it please create the
/root/.hushlogin file.
root@acerb:~#
```

Linux® containers don't use the specified drive letter.

To create a Windows container using the windows_minimal image:

```plaintext
$ kibdock create
Enter container name: mycontainer_win
Enter image name: windows_minimal
```

Deploy it:

```plaintext
$ kibdock deploy
Enter container name: mycontainer_win
Deploying container "mycontainer_win"...
Enter drive letter for container: X:
Welcome to KIBDock on KIB in Batch 10.2.4. Image: windows_minimal
If you see this message and a command shell, it means your container has successfully been deployed
Microsoft Windows [Versión 10.0.26100.4946]
(c) Microsoft Corporation. Todos los derechos reservados.

X:\Users\yourusername>
```

KIBDock can be used for running applications in containers.

---

UNIX® is a registered trademark of The Open Group.
Linux® is a registered trademark of Linus Torvalds.
KALI LINUX ™ is a trademark of OffSec.
KALI ™ is a trademark of OffSec.

We are not affilitated or associated in any way with Offensive Security or Kali Linux. This project is a community-driven effort to bring a Linux-like environment to Windows using batch scripts. We are not responsible for any misuse of the tools included in this project.
