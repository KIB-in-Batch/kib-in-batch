# /usr/lib/posix

This directory contains batch file implementations of POSIX APIs. For a reference, you can see here what's implemented.

## Implemented APIs

* int execl(const char *path, const char \*arg, ...)
  * Note: The batch file for this is not meant to be used standalone, use the wrapper in unistd.h instead.
* int mkdir(const char *path, mode_t mode)
* int rmdir(const char *path)
* int chdir(const char *path)
  * Note: This does not have a batch file backend, the logic is just a wrapper for SetCurrentDirectoryW().
* int open(const char *path, int flags, ...)
  * Note: This does not have a batch file backend.
* int close(int fd)
  * Note: This does not have a batch file backend.
* ssize_t read(int fd, void *buf, size_t count)
  * Note: This does not have a batch file backend.
* ssize_t write(int fd, const void *buf, size_t count)
  * Note: This does not have a batch file backend.
* char *getcwd(char \*buf, size_t size)
  * Note: The batch file for this is not meant to be used standalone, use the wrapper in unistd.h instead.
* getpid
  * Note: This is just a define for _getpid.
* unlink
  * Note: This is just a define for _unlink.
* pid_t fork(void)
  * Note: This fork() implementation is unreliable and has many differences from POSIX fork()! Do not use it in production!
* unsigned int sleep(unsigned int seconds)

Other APIs will be implemented in the future.

## Running UNIX Programs On KIB in Batch

You simply just recompile the program with a C compiler that supports the -I flag:

```shell
# Ensure you are in the drive letter where KIB in Batch is installed
pwd
# That should display something like "Z:/path/to/directory" if you installed KIB in Batch in the Z: drive
# If not, navigate to the correct location
# This is because otherwise / won't be the KIB in Batch root directory
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
    printf("Creating demo_directory... ");
    mkdir("demo_directory", 0777);
    printf("Created demo_directory\n");

    // Change to demo_directory
    printf("Changing to demo_directory... ");
    if (chdir("demo_directory") != 0) {
        perror("chdir() error");
        return 1;
    } else {
        printf("Changed to demo_directory\n");
        char cwd2[4096];
        if (getcwd(cwd2, sizeof(cwd2)) != NULL) {
            printf("Current working directory: %s\n", cwd2);
        } else {
            perror("getcwd() error");
        }
    }

    printf("Sleeping for 2 seconds... ");
    sleep(2);
    printf("Slept for 2 seconds\n");

    return 0;
}
```

After following this, you will have successfully ran a UNIX program on KIB in Batch!

## Using These APIs From A Batch File

You can also use these APIs directly from a batch script. Example:

```batch
@echo off

set /p dir=Enter the directory name: 
set /p mode=Enter the mode: 

set /p kibroot=<"%APPDATA%\kib_in_batch\kibroot.txt"

rem You can also use any other implemented API here

"%kibroot%\usr\lib\posix\mkdir.bat" %dir% %mode%
```
