#ifndef _SYS_TYPES_H
#define _SYS_TYPES_H

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned int mode_t; // File mode
typedef int pid_t; // Process ID
typedef long ssize_t; // Signed size
typedef long off_t; // File offset
typedef unsigned int uid_t; // User ID
typedef unsigned int gid_t; // Group ID
typedef unsigned int useconds_t; // Microseconds

typedef int dev_t; // Device ID
typedef unsigned int ino_t; // Inode number
typedef unsigned short nlink_t; // Number of hard links
typedef long time_t; // Time values

#ifdef __cplusplus
}
#endif

#endif
