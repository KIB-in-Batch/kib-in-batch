#ifndef _SYS_TYPES_H
#define _SYS_TYPES_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include <time.h>

#ifndef _U_CHAR_DEFINED
typedef unsigned char u_char;
#define _U_CHAR_DEFINED
#endif

#ifndef _U_SHORT_DEFINED
typedef unsigned short u_short;
#define _U_SHORT_DEFINED
#endif

#ifndef _U_INT_DEFINED
typedef unsigned int u_int;
#define _U_INT_DEFINED
#endif

#ifndef _U_LONG_DEFINED
typedef unsigned long u_long;
#define _U_LONG_DEFINED
#endif

#ifndef _PID_T_DEFINED
typedef int pid_t;
#define _PID_T_DEFINED
#endif

#ifndef _KEY_T_DEFINED
typedef int key_t;
#define _KEY_T_DEFINED
#endif

#ifndef _SSIZE_T_DEFINED
typedef ptrdiff_t ssize_t;
#define _SSIZE_T_DEFINED
#endif

#ifndef _OFF_T_DEFINED
typedef int64_t off_t;
#define _OFF_T_DEFINED
#endif

#ifndef _MODE_T_DEFINED
typedef unsigned int mode_t;
#define _MODE_T_DEFINED
#endif

#ifndef _UID_T_DEFINED
typedef unsigned int uid_t;
#define _UID_T_DEFINED
#endif

#ifndef _GID_T_DEFINED
typedef unsigned int gid_t;
#define _GID_T_DEFINED
#endif

#ifndef _NLINK_T_DEFINED
typedef unsigned int nlink_t;
#define _NLINK_T_DEFINED
#endif

#ifndef _DEV_T_DEFINED
typedef uint64_t dev_t;
#define _DEV_T_DEFINED
#endif

#ifndef _INO_T_DEFINED
typedef uint64_t ino_t;
#define _INO_T_DEFINED
#endif

#ifndef _USECONDS_T_DEFINED
typedef unsigned int useconds_t;
#define _USECONDS_T_DEFINED
#endif

#ifndef _SUSECONDS_T_DEFINED
typedef long suseconds_t;
#define _SUSECONDS_T_DEFINED
#endif

#ifndef _SIG_ATOMIC_T_DEFINED
typedef int sig_atomic_t;
#define _SIG_ATOMIC_T_DEFINED
#endif

#ifndef _BLKSIZE_T_DEFINED
typedef long long blksize_t;
#define _BLKSIZE_T_DEFINED
#endif

#ifndef _BLKCNT_T_DEFINED
typedef long long blkcnt_t;
#define _BLKCNT_T_DEFINED
#endif

#ifndef _FSID_T_DEFINED
typedef unsigned int fsid_t;
#define _FSID_T_DEFINED
#endif

#ifdef __cplusplus
}
#endif

#endif
