#ifndef _FCNTL_H
#define _FCNTL_H

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/types.h>

#define O_RDONLY    0x0000
#define O_WRONLY    0x0001
#define O_RDWR      0x0002

#define O_CREAT     0x0100
#define O_EXCL      0x0200
#define O_TRUNC     0x0400
#define O_APPEND    0x0800

int posix_open(const char *path, int flags, ...);

#define open posix_open

#ifdef __cplusplus
}
#endif

#endif /* _FCNTL_H */
