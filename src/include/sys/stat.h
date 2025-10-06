#ifndef _SYS_STAT_H
#define _SYS_STAT_H

#include <windows.h>
#include <sys/types.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _STAT_STRUCT_DEFINED
struct stat {
    dev_t st_dev;
    ino_t st_ino;
    mode_t st_mode;
    nlink_t st_nlink;
    uid_t st_uid;
    gid_t st_gid;
    off_t st_size;
    time_t st_atime;
    time_t st_mtime;
    time_t st_ctime;
};
#define _STAT_STRUCT_DEFINED
#endif

#ifndef S_IFMT
#endif

#ifndef S_IFREG
#define S_IFREG  0x8000
#endif

#ifndef S_IFDIR
#define S_IFDIR  0x4000
#endif

#ifndef S_IFCHR
#define S_IFCHR  0x2000
#endif

#ifndef S_IFBLK
#define S_IFBLK  0x6000
#endif

#ifndef S_IFIFO
#define S_IFIFO  0x1000
#endif

#ifndef S_IFLNK
#define S_IFLNK  0xA000
#endif

#ifndef S_IFSOCK
#define S_IFSOCK 0xC000
#endif

#ifndef S_IRUSR
#define S_IRUSR 0x0100
#endif

#ifndef S_IWUSR
#define S_IWUSR 0x0080
#endif

#ifndef S_IXUSR
#define S_IXUSR 0x0040
#endif

#ifndef S_IRGRP
#define S_IRGRP 0x0020
#endif

#ifndef S_IWGRP
#define S_IWGRP 0x0010
#endif

#ifndef S_IXGRP
#define S_IXGRP 0x0008
#endif

#ifndef S_IROTH
#define S_IROTH 0x0004
#endif

#ifndef S_IWOTH
#define S_IWOTH 0x0002
#endif

#ifndef S_IXOTH
#define S_IXOTH 0x0001
#endif

int stat(const char *path, struct stat *buf);
int fstat(int fd, struct stat *buf);
int lstat(const char *path, struct stat *buf);

#ifdef __cplusplus
}
#endif

#endif
