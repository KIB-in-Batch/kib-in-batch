# /usr/lib/posix

This directory contains batch file implementations of POSIX APIs. For a reference, you can see here what's implemented.

## Implemented APIs

* int execl(const char *path, const char \*arg, ...)
* int mkdir(const char *path, mode_t mode)
* int rmdir(const char *path)
* char *getcwd(char \*buf, size_t size)
* pid_t fork(void)
  * Note: The child process does not inherit the parent's current instruction.

Other APIs will be implemented in the future.

## Running UNIX Programs On Kali In Batch

You simply just recompile the program with a C compiler that supports the -I flag:

```shell
# Ensure you are in the drive letter where Kali in Batch is installed
pwd
# That should display something like "Z:/path/to/directory" if you installed Kali in Batch in the Z: drive
# If not, navigate to the correct location
# This is because otherwise / won't be the Kali in Batch root directory
clang -I/usr/include -o demo.exe demo.c
./demo.exe
cd demo_directory
# You should now be inside the directory you just created
# If it is a large project and it uses some kind of build system, you may have to modify it's compiler flags to include /usr/include.
```

Here is an example program you can use to test the POSIX APIs:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>

int main() {
    char cwd[4096];

    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        printf("Current working directory: %s\n", cwd);
    } else {
        perror("getcwd() error");
        return 1;
    }

    // Create a new directory
    mkdir("demo_directory", 0777);

    // Delete it
    rmdir("demo_directory");

    // Reproduce
    pid_t pid = fork();

    if (pid == 0) {
        printf("Child process\n");
        // Execute something
        execl("/bin/ls", "ls", "-l", NULL);
        printf("This should not be printed\n");
    } else {
        printf("Parent process\n");
    }

    return 0;
}
```

After following this, you will have successfully ran a UNIX program on Kali in Batch!

## Using These APIs From A Batch File

You can also use these APIs directly from a batch script. Example:

```batch
@echo off

set /p dir=Enter the directory name: 
set /p mode=Enter the mode: 

set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"

rem You can also use any other implemented API here

"%kaliroot%\usr\lib\posix\mkdir.bat" %dir% %mode%
```
