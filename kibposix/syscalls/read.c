// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <windows.h>

typedef long ssize_t;

extern HANDLE fd_get_handle(int fd);
extern int errno;

__declspec(dllexport) ssize_t read(int fd, void *buf, size_t count) {
    HANDLE handle = fd_get_handle(fd);
    if (handle == INVALID_HANDLE_VALUE) {
        errno = 9; // EBADF
        return -1;
    }

    DWORD bytes_read;
    if (!ReadFile(handle, buf, (DWORD)count, &bytes_read, NULL)) {
        return 0; // EOF or error
    }

    return (ssize_t)bytes_read;
}
