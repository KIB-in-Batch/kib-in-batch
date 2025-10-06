// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>
#include <windows.h>

typedef long ssize_t;

/* Forward declarations from lib/fd_table.c */
extern HANDLE fd_get_handle(int fd);

__declspec(dllexport) ssize_t posix_write(int fd, const void *buf, size_t count) {
    HANDLE hFile = fd_get_handle(fd);
    if (hFile == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    DWORD bytesWritten;
    if (!WriteFile(hFile, buf, (DWORD)count, &bytesWritten, NULL)) {
        // Map Windows error to POSIX errno
        DWORD err = GetLastError();
        switch (err) {
            case ERROR_ACCESS_DENIED:
                errno = EACCES;
                break;
            case ERROR_INVALID_HANDLE:
                errno = EBADF;
                break;
            case ERROR_BROKEN_PIPE:
                errno = EPIPE;
                break;
            case ERROR_NOT_ENOUGH_MEMORY:
                errno = ENOMEM;
                break;
            case ERROR_HANDLE_DISK_FULL:
                errno = ENOSPC;
                break;
            default:
                errno = EIO;
                break;
        }
        return -1;
    }

    return (ssize_t)bytesWritten;
}
