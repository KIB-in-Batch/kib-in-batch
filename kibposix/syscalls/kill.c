// Copyright (c) benja2998. All Rights Reserved.
// Licensed under the GPL-2.0-only license.

#include <errno.h>

#ifndef _PID_T_DEFINED
typedef int pid_t;
#define _PID_T_DEFINED
#endif

__declspec(dllexport) int kill(pid_t pid, int sig) {
    errno = ENOSYS;
    return -1;
} // TODO: Implement functionality
