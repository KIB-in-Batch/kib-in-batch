/usr/lib/posix
==============

This directory contains batch file implementations of POSIX APIs. For a reference, you can see here what's implemented and how to use each.

Implemented APIs
================

* mkdir
    * Usage: /usr/lib/posix/mkdir.bat pathname mode
* rmdir
    * Usage: /usr/lib/posix/rmdir.bat pathname

Other APIs will be implemented in the future.

Patching A UNIX Program To Use These APIs
=========================================

Let's for example have a UNIX program that looks like this:

```code
#include <sys/stat.h>
#include <sys/types.h>

int main() {
    mkdir("demo_directory", 0755);
    return 0;
}
```endcode

If you want to run it in Kali in Batch, you can patch it like this:

```code
#include <sys/stat.h>
#include <sys/types.h>
#include <stdlib.h>

int main() {
    system("/usr/lib/posix/mkdir.bat demo_directory 0755");
    return 0;
}
```endcode

You can then compile it using your preferred C compiler and run it like this:

```code
$ clang -o demo.exe demo.c
$ # Ensure you are in the drive letter where Kali in Batch is installed
$ pwd
$ # That should have displayed something like for example "Z:/path/to/directory" if you installed Kali in Batch in the Z: drive
$ # If not, navigate to the correct location
$ ./demo.exe
$ cd demo_directory
$ # You then should be in the directory you just created
```endcode

Congratulations, you have succesfully compiled a UNIX program to run in Kali in Batch!

Using These APIs From A Batch File
==================================

You can also use these APIs from a batch file. Here is an example:

```code
@echo off

set /p dir=Enter the directory name: 
set /p mode=Enter the mode: 

set /p kaliroot=<"%APPDATA%\kali_in_batch\kaliroot.txt"

rem You can also use any other implemented API here

"%kaliroot%\usr\lib\posix\mkdir.bat" %dir% %mode%
```endcode
