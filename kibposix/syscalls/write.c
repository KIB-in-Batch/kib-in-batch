// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>
#include <windows.h>

typedef long ssize_t;

/* Forward declarations from lib/fd_table.c */
extern HANDLE fd_get_handle(int fd);

__declspec(dllexport) ssize_t write(int fd, const void *buf, size_t count) {
    HANDLE handle = fd_get_handle(fd);
    if (handle == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    DWORD bytes_written;
    if (!WriteFile(handle, buf, (DWORD)count, &bytes_written, NULL)) {
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
            default:
                errno = EIO;
                break;
        }
        return -1;
    }

    return (ssize_t)bytes_written;
}
