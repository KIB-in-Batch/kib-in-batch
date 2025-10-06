// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <windows.h>

typedef long ssize_t;

extern HANDLE fd_get_handle(int fd);
extern int errno;

__declspec(dllexport) ssize_t posix_read(int fd, void *buf, size_t count) {
    HANDLE hFile = fd_get_handle(fd);
    if (hFile == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    if (fd == 0) {
        DWORD bytesRead;
        if (!ReadFile(hFile, buf, (DWORD)count, &bytesRead, NULL)) {
            DWORD err = GetLastError();
            switch (err) {
                case ERROR_BROKEN_PIPE:
                    return 0;  // EOF
                case ERROR_OPERATION_ABORTED:
                    errno = EINTR;
                    return -1;
                default:
                    errno = EIO;
                    return -1;
            }
        }
        return (ssize_t)bytesRead;
    }

    DWORD bytesRead;
    if (!ReadFile(hFile, buf, (DWORD)count, &bytesRead, NULL)) {
        // Map Windows errors to POSIX errno
        DWORD err = GetLastError();
        switch (err) {
            case ERROR_HANDLE_EOF:
                return 0;  // EOF
            case ERROR_ACCESS_DENIED:
                errno = EACCES;
                break;
            case ERROR_INVALID_HANDLE:
                errno = EBADF;
                break;
            case ERROR_OPERATION_ABORTED:
                errno = EINTR;
                break;
            case ERROR_NOT_ENOUGH_MEMORY:
                errno = ENOMEM;
                break;
            default:
                errno = EIO;
                break;
        }
        return -1;
    }

    // Handle EOF condition
    if (bytesRead == 0 && count != 0) {
        return 0;  // EOF
    }

    return (ssize_t)bytesRead;
}
