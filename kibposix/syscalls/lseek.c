// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>
#include <windows.h>

typedef long off_t;

extern HANDLE fd_get_handle(int fd);

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

__declspec(dllexport) off_t lseek(int fd, off_t offset, int whence) {
    HANDLE handle = fd_get_handle(fd);
    if (handle == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    DWORD move_method;
    switch (whence) {
        case SEEK_SET:
            move_method = FILE_BEGIN;
            break;
        case SEEK_CUR:
            move_method = FILE_CURRENT;
            break;
        case SEEK_END:
            move_method = FILE_END;
            break;
        default:
            errno = EINVAL;
            return -1;
    }

    LARGE_INTEGER li;
    li.QuadPart = offset;

    li.LowPart = SetFilePointer(handle, li.LowPart, &li.HighPart, move_method);

    if (li.LowPart == INVALID_SET_FILE_POINTER && GetLastError() != NO_ERROR) {
        errno = EIO;
        return -1;
    }

    return (off_t)li.QuadPart;
}
