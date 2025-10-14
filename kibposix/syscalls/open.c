// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>
#include <fcntl.h>
#include <windows.h>
#include <stdarg.h>
#include <stdlib.h>
#include "../lib/to_win_path.h"

typedef unsigned int mode_t;

extern int fd_alloc(HANDLE h, int type);

__declspec(dllexport) int posix_open(const char *pathname, int flags, ...) {
    // Handle mode parameter for O_CREAT
    mode_t mode = 0;
    if (flags & O_CREAT) {
        va_list args;
        va_start(args, flags);
        mode = va_arg(args, mode_t);
        va_end(args);
    }

    // Convert POSIX flags to Windows access flags
    DWORD access = 0;
    if (flags & O_RDWR) access = GENERIC_READ | GENERIC_WRITE;
    else if (flags & O_WRONLY) access = GENERIC_WRITE;
    else access = GENERIC_READ;  // Default to read-only

    // Convert POSIX flags to Windows creation flags
    DWORD disposition = OPEN_EXISTING;
    if (flags & O_CREAT) {
        disposition = (flags & O_EXCL) ? CREATE_NEW : OPEN_ALWAYS;
        if (flags & O_TRUNC) disposition = CREATE_ALWAYS;
    } else if (flags & O_TRUNC) {
        disposition = TRUNCATE_EXISTING;
    }

    // Convert Unix-style path to Windows-style
    char* win_path = to_win_path(pathname);
    if (!win_path) {
        // errno already set by to_win_path()
        return -1;
    }

    // Convert to wide characters
    wchar_t wpath[MAX_PATH];
    if (MultiByteToWideChar(CP_UTF8, 0, win_path, -1, wpath, MAX_PATH) == 0) {
        free(win_path);
        errno = EINVAL;
        return -1;
    }

    free(win_path); // Cleanup

    // Create or open the file
    HANDLE hFile = CreateFileW(
        wpath,
        access,
        FILE_SHARE_READ | FILE_SHARE_WRITE,  // Share mode
        NULL,
        disposition,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );

    if (hFile == INVALID_HANDLE_VALUE) {
        // Map Windows error to POSIX errno
        DWORD err = GetLastError();
        switch (err) {
            case ERROR_FILE_NOT_FOUND:
            case ERROR_PATH_NOT_FOUND:
                errno = ENOENT;
                break;
            case ERROR_ACCESS_DENIED:
                errno = EACCES;
                break;
            case ERROR_FILE_EXISTS:
                errno = EEXIST;
                break;
            case ERROR_DISK_FULL:
                errno = ENOSPC;
                break;
            case ERROR_SHARING_VIOLATION:
                errno = EBUSY;
                break;
            case ERROR_TOO_MANY_OPEN_FILES:
                errno = EMFILE;
                break;
            default:
                errno = EIO;
                break;
        }
        return -1;
    }

    // Set append mode if requested
    if (flags & O_APPEND) {
        SetFilePointer(hFile, 0, NULL, FILE_END);
    }

    // Allocate new file descriptor
    int fd = fd_alloc(hFile, 1);
    if (fd < 0) {
        CloseHandle(hFile);
        return -1;
    }

    return fd;
}
