#ifndef _UNISTD_H
#define _UNISTD_H

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/types.h>
#include <stddef.h>

/* DLL import/export */
#ifdef KIBPOSIX_BUILD_DLL
#define KIBPOSIX_API __declspec(dllexport)
#else
#define KIBPOSIX_API __declspec(dllimport)
#endif

/* Standard file descriptors */
#define STDIN_FILENO  0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

/* lseek() constants */
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

/* Functions exported from kibposix.dll */
KIBPOSIX_API int posix_close(int fd);
KIBPOSIX_API ssize_t posix_read(int fd, void *buf, size_t count);
KIBPOSIX_API ssize_t posix_write(int fd, const void *buf, size_t count);
KIBPOSIX_API int chdir(const char *path);
KIBPOSIX_API char *getcwd(char *buf, size_t size);
KIBPOSIX_API int mkdir(const char *pathname, mode_t mode);
KIBPOSIX_API int rmdir(const char *pathname);
KIBPOSIX_API int execl(const char *path, const char *arg, ...);
KIBPOSIX_API pid_t getpid(void);
KIBPOSIX_API unsigned int sleep(unsigned int seconds);
KIBPOSIX_API int unlink(const char *pathname);
KIBPOSIX_API int getopt(int argc, char * const argv[], const char *optstring); 

#define close posix_close
#define read posix_read
#define write posix_write

#ifdef __cplusplus
}
#endif

#endif /* _UNISTD_H */
