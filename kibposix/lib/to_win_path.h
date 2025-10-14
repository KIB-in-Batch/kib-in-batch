// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#ifndef TO_WIN_PATH_H
#define TO_WIN_PATH_H

#include <windows.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static inline char* to_win_path(const char* path) {
    if (!path || !*path) {
        errno = EINVAL;
        return NULL;
    }

    // Invalid if contains backslashes, Unix paths don't contain backslashes
    if (strchr(path, '\\')) {
        errno = ENOENT;
        return NULL;
    }

    // Invalid if starts with drive letter, Unix paths don't contain drive letters
    if (path[1] == ':') {
        errno = ENOENT;
        return NULL;
    }

    // If it doesn't start with '/', not a Unix path
    if (path[0] != '/') {
        errno = ENOENT;
        return NULL;
    }

    size_t len = strlen(path);
    char* win_path = (char*)malloc(len + 4);

    if (!win_path) {
        errno = ENOMEM;
        return NULL;
    }

    // TODO: Don't use a hardcoded Z:
    sprintf(win_path, "Z:%s", path);

    // Replace forward slashes with backslashes
    for (char* p = win_path; *p; ++p) {
        if (*p == '/') *p = '\\';
    }

    return win_path;
}

#endif // TO_WIN_PATH_H
