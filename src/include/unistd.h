#ifndef UNISTD_H
#define UNISTD_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <process.h>
#include <time.h>
#include <stdarg.h>
#include <windows.h>
#define getpid _getpid

#define MAX_PATH_LEN 1024
// Define mode_t
typedef unsigned int mode_t;
// Define pid_t
typedef unsigned int pid_t;

/* Helper to read kaliroot from file, returns 0 on success, -1 on failure */
static inline int read_kaliroot(char *kaliroot, size_t size) {
    const char *appdata = getenv("APPDATA");
    if (!appdata) {
        errno = EIO;
        return -1;
    }

    char kaliroot_file[MAX_PATH_LEN];
    snprintf(kaliroot_file, sizeof(kaliroot_file), "%s/kali_in_batch/kaliroot.txt", appdata);

    FILE *froot = fopen(kaliroot_file, "r");
    if (!froot) {
        errno = EIO;
        return -1;
    }

    if (!fgets(kaliroot, (int)size, froot)) {
        fclose(froot);
        errno = EIO;
        return -1;
    }
    fclose(froot);

    /* Strip newline */
    size_t len = strlen(kaliroot);
    while (len > 0 && (kaliroot[len - 1] == '\n' || kaliroot[len - 1] == '\r'))
        kaliroot[--len] = '\0';

    /* Replace backslashes with forward slashes */
    for (size_t i = 0; i < len; i++) {
        if (kaliroot[i] == '\\') kaliroot[i] = '/';
    }

    return 0;
}

static inline int chdir(const char* path) {
    wchar_t wpath[MAX_PATH];
    if (MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, MAX_PATH) == 0) {
        errno = EINVAL;  // Set errno for POSIX compliance
        return -1;
    }
    if (SetCurrentDirectoryW(wpath)) {
        return 0; // Success
    }
    // Set errno based on Windows error for better POSIX compliance
    DWORD err = GetLastError();
    switch (err) {
        case ERROR_FILE_NOT_FOUND:
        case ERROR_PATH_NOT_FOUND:
            errno = ENOENT;
            break;
        case ERROR_ACCESS_DENIED:
            errno = EACCES;
            break;
        default:
            errno = EIO;
            break;
    }
    return -1; // Failure
}

static inline int posix_execl(const char *path, const char *arg, ...) {
    char kaliroot[MAX_PATH_LEN];
    if (read_kaliroot(kaliroot, sizeof(kaliroot)) < 0)
        return -1;
    
    char cmd[2048];
    int pos = 0;
    
    // Build command with execl.bat
    int needed = snprintf(cmd + pos, sizeof(cmd) - pos, 
                         "%s/usr/lib/posix/execl.bat %s", kaliroot, path);
    if (needed < 0 || needed >= (int)(sizeof(cmd) - pos)) {
        return -1;
    }
    pos += needed;
    
    // Add variable arguments starting with arg
    va_list args;
    va_start(args, arg);
    const char *current_arg = arg;
    while (current_arg != NULL) {
        needed = snprintf(cmd + pos, sizeof(cmd) - pos, " \"%s\"", current_arg);
        if (needed < 0 || needed >= (int)(sizeof(cmd) - pos)) {
            va_end(args);
            return -1;
        }
        pos += needed;
        current_arg = va_arg(args, const char *);
    }
    va_end(args);
    
    // Replace current process - this should not return
    exit(system(cmd));
}

#define execl posix_execl

static inline pid_t fork(void) {
    if (getenv("FORK_CHILD")) {
        return 0; // Child process, don't fork
    }
    
    char kaliroot[MAX_PATH_LEN];
    if (read_kaliroot(kaliroot, sizeof(kaliroot)) < 0)
        return -1;
   
    // Get command line arguments
    extern char **__argv;
    extern int __argc;
   
    char cmd[2048];  // Larger buffer for arguments
    int pos = 0;
   
    // Start with setting environment variable and fork.bat path
    int needed = snprintf(cmd + pos, sizeof(cmd) - pos, "set FORK_CHILD=1 && \"%s/usr/lib/posix/fork.bat\"", kaliroot);
    if (needed < 0 || needed >= (int)(sizeof(cmd) - pos)) {
        return -1;
    }
    pos += needed;
   
    // Add program name (argv[0]) first
    needed = snprintf(cmd + pos, sizeof(cmd) - pos, " \"%s\"", __argv[0]);
    if (needed < 0 || needed >= (int)(sizeof(cmd) - pos)) {
        return -1;
    }
    pos += needed;
    
    // Add remaining arguments from argv[1] onwards (skip duplicate argv[0])
    for (int i = 1; i < __argc && pos < sizeof(cmd) - 1; i++) {
        needed = snprintf(cmd + pos, sizeof(cmd) - pos, " \"%s\"", __argv[i]);
        if (needed < 0 || needed >= (int)(sizeof(cmd) - pos)) {
            return -1;  // Avoid overflow
        }
        pos += needed;
    }
   
    int result = system(cmd);
    return (result == 0) ? 123 : -1;  // Return fake PID on success, -1 on error
    // TOOD: Make the child inherit the parent's current program counter
}

static inline int mkdir(const char *path, mode_t mode) {
    char kaliroot[MAX_PATH_LEN];
    if (read_kaliroot(kaliroot, sizeof(kaliroot)) < 0)
        return -1;

    char cmd[512];
    int needed = snprintf(NULL, 0, "%s/usr/lib/posix/mkdir.bat \"%s\" %o", kaliroot, path, mode);
    if (needed < 0 || needed >= (int)sizeof(cmd)) {
        return -1;  // Avoid overflow
    }
    snprintf(cmd, sizeof(cmd), "%s/usr/lib/posix/mkdir.bat \"%s\" %o", kaliroot, path, mode);
    return system(cmd);
}

static inline int rmdir(const char *path) {
    char kaliroot[MAX_PATH_LEN];
    if (read_kaliroot(kaliroot, sizeof(kaliroot)) < 0)
        return -1;

    char cmd[512];
    int needed = snprintf(NULL, 0, "%s/usr/lib/posix/rmdir.bat \"%s\"", kaliroot, path);
    if (needed < 0 || needed >= (int)sizeof(cmd)) {
        return -1;  // Avoid overflow
    }
    snprintf(cmd, sizeof(cmd), "%s/usr/lib/posix/rmdir.bat \"%s\"", kaliroot, path);
    return system(cmd);
}

static char *getcwd(char *buf, size_t size) {
    // Handle NULL buf case properly
    int allocated = 0;
    if (!buf) {
        if (size == 0) size = MAX_PATH_LEN;
        buf = malloc(size);
        if (!buf) {
            errno = ENOMEM;
            return NULL;
        }
        allocated = 1;
    }
    
    // Validate size
    if (size == 0) {
        errno = EINVAL;
        return NULL;
    }

    char kaliroot[MAX_PATH_LEN];
    if (read_kaliroot(kaliroot, sizeof(kaliroot)) < 0) {
        if (allocated) free(buf);
        return NULL;
    }

    /* Use a unique temp file to avoid conflicts */
    char tmpfile[MAX_PATH_LEN];
    snprintf(tmpfile, sizeof(tmpfile), "%s/tmp/getcwd_%d_%ld.tmp", 
             kaliroot, getpid(), (long)time(NULL));

    /* Build command */
    char cmd[MAX_PATH_LEN * 2];
    snprintf(cmd, sizeof(cmd),
             "\"%s/usr/lib/posix/getcwd.bat\" > %s",
             kaliroot, tmpfile);

    if (system(cmd) != 0) {
        if (allocated) free(buf);
        errno = EIO;
        return NULL;
    }

    FILE *tmpf = fopen(tmpfile, "r");
    if (!tmpf) {
        if (allocated) free(buf);
        errno = EIO;
        return NULL;
    }

    if (!fgets(buf, (int)size, tmpf)) {
        fclose(tmpf);
        remove(tmpfile);  // Clean up temp file
        if (allocated) free(buf);
        errno = EIO;
        return NULL;
    }
    fclose(tmpf);
    remove(tmpfile);  // Clean up temp file

    /* Strip trailing newline */
    size_t len = strlen(buf);
    while (len > 0 && (buf[len - 1] == '\n' || buf[len - 1] == '\r'))
        buf[--len] = '\0';

    /* Check if result fits in buffer */
    if (len >= size) {
        if (allocated) free(buf);
        errno = ERANGE;
        return NULL;
    }

    return buf;
}

#endif // UNISTD_H
