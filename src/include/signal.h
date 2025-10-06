#ifndef _SIGNAL_H
#define _SIGNAL_H

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/types.h>

/* DLL import/export */
#ifdef KIBPOSIX_BUILD_DLL
#define KIBPOSIX_API __declspec(dllexport)
#else
#define KIBPOSIX_API __declspec(dllimport)
#endif

#ifndef _PID_T_DEFINED
typedef int pid_t;
#define _PID_T_DEFINED
#endif

/* Functions exported from kibposix.dll */
KIBPOSIX_API int kill(pid_t pid, int sig);

#ifdef __cplusplus
}
#endif

#endif /* _SIGNAL_H */
