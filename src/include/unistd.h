#ifndef UNISTD_H
#define UNISTD_H

#define _CRT_SECURE_NO_WARNINGS

// Define POSIX types
typedef unsigned int mode_t;
typedef unsigned int pid_t;
typedef long ssize_t;
typedef long off_t;

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <process.h>
#include <time.h>
#include <stdarg.h>
#include <windows.h>
#include <io.h>  // For _get_osfhandle
#include <fcntl.h>  // For file modes
#define getpid _getpid

#define MAX_PATH_LEN 1024
#define FD_TABLE_SIZE 256  // Maximum open files

// Define POSIX file constants
#define STDIN_FILENO 0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

// File open flags (from fcntl.h)
#define O_RDONLY     _O_RDONLY
#define O_WRONLY     _O_WRONLY
#define O_RDWR       _O_RDWR
#define O_APPEND     _O_APPEND
#define O_CREAT      _O_CREAT
#define O_EXCL       _O_EXCL
#define O_TRUNC      _O_TRUNC
#define O_TEXT       _O_TEXT
#define O_BINARY     _O_BINARY

static HANDLE fd_table[FD_TABLE_SIZE];
static int fd_table_initialized = 0;

static void init_fd_table(void) {
    if (!fd_table_initialized) {
        fd_table[0] = GetStdHandle(STD_INPUT_HANDLE);
        fd_table[1] = GetStdHandle(STD_OUTPUT_HANDLE);
        fd_table[2] = GetStdHandle(STD_ERROR_HANDLE);
        for (int i = 3; i < FD_TABLE_SIZE; i++) {
            fd_table[i] = INVALID_HANDLE_VALUE;
        }
        fd_table_initialized = 1;
    }
}

// Helper to allocate new file descriptor
static int alloc_fd(HANDLE handle) {
    static int initialized = 0;
    if (!initialized) {
        init_fd_table();
        initialized = 1;
    }
    
    for (int i = 3; i < FD_TABLE_SIZE; i++) {
        if (fd_table[i] == INVALID_HANDLE_VALUE) {
            fd_table[i] = handle;
            return i;
        }
    }
    
    errno = EMFILE;  // Too many open files
    return -1;
}

// Helper to get handle from descriptor
static HANDLE get_handle(int fd) {
    if (fd < 0 || fd >= FD_TABLE_SIZE) {
        return INVALID_HANDLE_VALUE;
    }
    return fd_table[fd];
}

/* Helper to read kibroot from file, returns 0 on success, -1 on failure */
static inline int read_kibroot(char *kibroot, size_t size) {
    const char *appdata = getenv("APPDATA");
    if (!appdata) {
        errno = EIO;
        return -1;
    }

    char kibroot_file[MAX_PATH_LEN];
    snprintf(kibroot_file, sizeof(kibroot_file), "%s/kib_in_batch/kibroot.txt", appdata);

    FILE *froot = fopen(kibroot_file, "r");
    if (!froot) {
        errno = EIO;
        return -1;
    }

    if (!fgets(kibroot, (int)size, froot)) {
        fclose(froot);
        errno = EIO;
        return -1;
    }
    fclose(froot);

    /* Strip newline */
    size_t len = strlen(kibroot);
    while (len > 0 && (kibroot[len - 1] == '\n' || kibroot[len - 1] == '\r'))
        kibroot[--len] = '\0';

    /* Replace backslashes with forward slashes */
    for (size_t i = 0; i < len; i++) {
        if (kibroot[i] == '\\') kibroot[i] = '/';
    }

    return 0;
}

static inline unsigned int sleep(unsigned int seconds) {
    // Get kib root
    char kibroot[MAX_PATH_LEN];
    if (read_kibroot(kibroot, sizeof(kibroot)) < 0)
        return 1;

    char cmd[2048];
    // We use kibroot/usr/lib/posix/sleep.bat to sleep
    snprintf(cmd, sizeof(cmd), "%s/usr/lib/posix/sleep.bat %d", kibroot, seconds);
    // Execute the command
    system(cmd);
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
    char kibroot[MAX_PATH_LEN];
    if (read_kibroot(kibroot, sizeof(kibroot)) < 0)
        return -1;
    
    char cmd[2048];
    int pos = 0;
    
    // Build command with execl.bat
    int needed = snprintf(cmd + pos, sizeof(cmd) - pos, 
                         "%s/usr/lib/posix/execl.bat %s", kibroot, path);
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
    errno = ENOSYS; // Function not implemented
    return -1;
}

static inline int mkdir(const char *path, mode_t mode) {
    char kibroot[MAX_PATH_LEN];
    if (read_kibroot(kibroot, sizeof(kibroot)) < 0)
        return -1;

    char cmd[512];
    int needed = snprintf(NULL, 0, "%s/usr/lib/posix/mkdir.bat \"%s\" %o", kibroot, path, mode);
    if (needed < 0 || needed >= (int)sizeof(cmd)) {
        return -1;  // Avoid overflow
    }
    snprintf(cmd, sizeof(cmd), "%s/usr/lib/posix/mkdir.bat \"%s\" %o", kibroot, path, mode);
    return system(cmd);
}

static inline int rmdir(const char *path) {
    char kibroot[MAX_PATH_LEN];
    if (read_kibroot(kibroot, sizeof(kibroot)) < 0)
        return -1;

    char cmd[512];
    int needed = snprintf(NULL, 0, "%s/usr/lib/posix/rmdir.bat \"%s\"", kibroot, path);
    if (needed < 0 || needed >= (int)sizeof(cmd)) {
        return -1;  // Avoid overflow
    }
    snprintf(cmd, sizeof(cmd), "%s/usr/lib/posix/rmdir.bat \"%s\"", kibroot, path);
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

    char kibroot[MAX_PATH_LEN];
    if (read_kibroot(kibroot, sizeof(kibroot)) < 0) {
        if (allocated) free(buf);
        return NULL;
    }

    /* Use a unique temp file to avoid conflicts */
    char tmpfile[MAX_PATH_LEN];
    snprintf(tmpfile, sizeof(tmpfile), "%s/tmp/getcwd_%d_%ld.tmp", 
             kibroot, getpid(), (long)time(NULL));

    /* Build command */
    char cmd[MAX_PATH_LEN * 2];
    snprintf(cmd, sizeof(cmd),
             "\"%s/usr/lib/posix/getcwd.bat\" > %s",
             kibroot, tmpfile);

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

// POSIX write implementation
static inline ssize_t posix_write(int fd, const void *buf, size_t count) {
    HANDLE hFile = get_handle(fd);
    if (hFile == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    DWORD bytesWritten;
    if (!WriteFile(hFile, buf, (DWORD)count, &bytesWritten, NULL)) {
        // Map Windows error to POSIX errno
        DWORD err = GetLastError();
        switch (err) {
            case ERROR_ACCESS_DENIED:
                errno = EACCES;
                break;
            case ERROR_INVALID_HANDLE:
                errno = EBADF;
                break;
            case ERROR_BROKEN_PIPE:
                errno = EPIPE;
                break;
            case ERROR_NOT_ENOUGH_MEMORY:
                errno = ENOMEM;
                break;
            case ERROR_HANDLE_DISK_FULL:
                errno = ENOSPC;
                break;
            default:
                errno = EIO;
                break;
        }
        return -1;
    }

    return (ssize_t)bytesWritten;
}

// POSIX open implementation
static inline int posix_open(const char *path, int flags, ...) {
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

    // Convert path to wide characters
    wchar_t wpath[MAX_PATH];
    if (MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, MAX_PATH) == 0) {
        errno = EINVAL;
        return -1;
    }

    // Create the file
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
    int fd = alloc_fd(hFile);
    if (fd < 0) {
        CloseHandle(hFile);
        return -1;
    }

    return fd;
}

// POSIX close implementation
static inline int posix_close(int fd) {
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

// POSIX read implementation
static inline ssize_t posix_read(int fd, void *buf, size_t count) {
    HANDLE hFile = get_handle(fd);
    if (hFile == INVALID_HANDLE_VALUE) {
        errno = EBADF;
        return -1;
    }

    if (fd == STDIN_FILENO) {
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

#define open posix_open
#define close posix_close
#define read posix_read
#define write posix_write
#define unlink _unlink

#endif // UNISTD_H
