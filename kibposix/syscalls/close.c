// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>
#include <windows.h>

extern HANDLE fd_get_handle(int fd);
extern void fd_free(int fd);

__declspec(dllexport) int close(int fd) {
    HANDLE handle = fd_get_handle(fd);
    if (handle == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    if (!CloseHandle(handle)) {
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

    fd_free(fd);
    return 0;
}
