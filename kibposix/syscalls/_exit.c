// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <windows.h>

__declspec(dllexport) void posix_exit(int status) {
    ExitProcess(status);
} // _exit() is redefined as this function in unistd.h
