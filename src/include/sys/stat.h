#ifndef _SYS_STAT_H
#define _SYS_STAT_H

#include <windows.h>
#include <sys/types.h>

#ifdef __cplusplus
extern "C" {
#endif

struct stat {
dev_t st_dev;       // Device ID
ino_t st_ino;       // Inode number
mode_t st_mode;     // File mode
nlink_t st_nlink;   // Number of hard links
uid_t st_uid;       // User ID of owner
gid_t st_gid;       // Group ID of owner
off_t st_size;      // Total size in bytes
time_t st_atime;    // Time of last access
time_t st_mtime;    // Time of last modification
time_t st_ctime;    // Time of last status change
};

// File type macros
#define S_IFMT 0xF000
#define S_IFREG 0x8000
#define S_IFDIR 0x4000
#define S_IFCHR 0x2000
#define S_IFBLK 0x6000
#define S_IFIFO 0x1000
#define S_IFLNK 0xA000
#define S_IFSOCK 0xC000

// Permission macros
#define S_IRUSR 0x0100
#define S_IWUSR 0x0080
#define S_IXUSR 0x0040
#define S_IRGRP 0x0020
#define S_IWGRP 0x0010
#define S_IXGRP 0x0008
#define S_IROTH 0x0004
#define S_IWOTH 0x0002
#define S_IXOTH 0x0001

int stat(const char *path, struct stat *buf);
int fstat(int fd, struct stat *buf);
int lstat(const char *path, struct stat *buf);

#ifdef __cplusplus
}
#endif

#endif  // _SYS_STAT_H
