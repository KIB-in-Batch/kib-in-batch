// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>
#include <windows.h>

#define FD_TABLE_SIZE 256

extern HANDLE fd_get_handle(int fd);
HANDLE fd_table[FD_TABLE_SIZE];
extern void fd_free(int fd);

__declspec(dllexport) int posix_close(int fd) {
    if (fd < 0 || fd >= FD_TABLE_SIZE) {
        errno = EBADF;
        return -1;
    }

    HANDLE hFile = fd_table[fd];
    if (hFile == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    // Don't close standard streams
    if (fd >= 0 && fd <= 2) {
        return 0;
    }

    if (!CloseHandle(hFile)) {
        // Map Windows error to POSIX errno
        DWORD err = GetLastError();
        switch (err) {
            case ERROR_INVALID_HANDLE:
                errno = EBADF;
                break;
            default:
                errno = EIO;
                break;
        }
        return -1;
    }

    fd_table[fd] = INVALID_HANDLE_VALUE;
    return 0;
}
