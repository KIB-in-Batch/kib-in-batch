// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>
#include <fcntl.h>
#include <windows.h>
#include <sys/stat.h>

/* Forward declarations from lib/fd_table.c */
extern int fd_alloc(HANDLE h);

__declspec(dllexport) int open(const char *pathname, int flags, ...) {
    DWORD access = 0;
    DWORD creation = 0;
    DWORD attrs = FILE_ATTRIBUTE_NORMAL;
    HANDLE hFile;

    // Determine desired access
    if (flags & O_RDWR)
        access = GENERIC_READ | GENERIC_WRITE;
    else if (flags & O_WRONLY)
        access = GENERIC_WRITE;
    else
        access = GENERIC_READ;

    // Determine creation disposition
    if (flags & O_CREAT) {
        if ((flags & O_EXCL) && (flags & O_CREAT))
            creation = CREATE_NEW;
        else if (flags & O_TRUNC)
            creation = CREATE_ALWAYS;
        else
            creation = OPEN_ALWAYS;
    } else {
        if (flags & O_TRUNC)
            creation = TRUNCATE_EXISTING;
        else
            creation = OPEN_EXISTING;
    }

    // Append means write-only but positioned at EOF
    if (flags & O_APPEND)
        access |= FILE_APPEND_DATA;

    hFile = CreateFileA(
        pathname,
        access,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        NULL,
        creation,
        attrs,
        NULL
    );

    if (hFile == INVALID_HANDLE_VALUE) {
        DWORD err = GetLastError();
        switch (err) {
            case ERROR_FILE_NOT_FOUND:
                errno = ENOENT;
                break;
            case ERROR_PATH_NOT_FOUND:
                errno = ENOENT;
                break;
            case ERROR_ACCESS_DENIED:
                errno = EACCES;
                break;
            case ERROR_ALREADY_EXISTS:
                errno = EEXIST;
                break;
            default:
                errno = EIO;
                break;
        }
        return -1;
    }

    // Register handle in your fd_table
    return fd_alloc(hFile);
}
