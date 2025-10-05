// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <windows.h>
#include <errno.h>

#define FD_TABLE_SIZE 256

typedef struct {
    HANDLE handle;
    int type;
    int flags;
} fd_entry_t;

static fd_entry_t fd_table[FD_TABLE_SIZE];
static int fd_table_init = 0;
static CRITICAL_SECTION fd_lock;

static void fd_init(void) {
    if (fd_table_init) return;
    
    InitializeCriticalSection(&fd_lock);
    
    fd_table[0].handle = GetStdHandle(STD_INPUT_HANDLE);
    fd_table[0].type = 1;
    fd_table[1].handle = GetStdHandle(STD_OUTPUT_HANDLE);
    fd_table[1].type = 1;
    fd_table[2].handle = GetStdHandle(STD_ERROR_HANDLE);
    fd_table[2].type = 1;
    
    for (int i = 3; i < FD_TABLE_SIZE; i++) {
        fd_table[i].handle = INVALID_HANDLE_VALUE;
    }
    
    fd_table_init = 1;
}

int fd_alloc(HANDLE handle, int type) {
    if (!fd_table_init) fd_init();
    
    EnterCriticalSection(&fd_lock);
    
    int fd = -1;
    for (int i = 3; i < FD_TABLE_SIZE; i++) {
        if (fd_table[i].handle == INVALID_HANDLE_VALUE) {
            fd_table[i].handle = handle;
            fd_table[i].type = type;
            fd_table[i].flags = 0;
            fd = i;
            break;
        }
    }
    
    LeaveCriticalSection(&fd_lock);
    
    if (fd < 0) errno = EMFILE;
    return fd;
}

HANDLE fd_get_handle(int fd) {
    if (!fd_table_init) fd_init();
    
    if (fd < 0 || fd >= FD_TABLE_SIZE) {
        return INVALID_HANDLE_VALUE;
    }
    
    return fd_table[fd].handle;
}

void fd_free(int fd) {
    if (fd < 0 || fd >= FD_TABLE_SIZE) return;
    
    EnterCriticalSection(&fd_lock);
    fd_table[fd].handle = INVALID_HANDLE_VALUE;
    fd_table[fd].type = 0;
    fd_table[fd].flags = 0;
    LeaveCriticalSection(&fd_lock);
}
