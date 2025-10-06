#include <stdio.h>
#include <string.h>

__declspec(dllexport) int optind = 1;
__declspec(dllexport) char *optarg = NULL;
__declspec(dllexport) int opterr = 1;
__declspec(dllexport) int optopt = 0;

__declspec(dllexport) int getopt(int argc, char * const argv[], const char *optstring) {
    static int argpos = 1;
    char *arg;

    if (optind >= argc) return -1;

    arg = argv[optind];
    if (arg[0] != '-' || arg[1] == '\0') return -1;

    optopt = arg[argpos];
    const char *optchar = strchr(optstring, optopt);

    if (!optchar) {
        if (opterr) fprintf(stderr, "Unknown option -%c\n", optopt);
        if (arg[argpos + 1] == '\0') { optind++; argpos = 1; }
        else argpos++;
        return '?';
    }

    if (*(optchar + 1) == ':') {
        if (arg[argpos + 1] != '\0') {
            optarg = &arg[argpos + 1];
            optind++;
        } else if (optind + 1 < argc) {
            optind++;
            optarg = argv[optind++];
        } else {
            if (opterr) fprintf(stderr, "Option -%c requires an argument\n", optopt);
            argpos = 1;
            optind++;
            return '?';
        }
        argpos = 1;
    } else {
        if (arg[argpos + 1] == '\0') {
            argpos = 1;
            optind++;
        } else argpos++;
        optarg = NULL;
    }

    return optopt;
}

/* GNU extensions */
#define no_argument 0
#define required_argument 1
#define optional_argument 2

struct option {
    const char *name;
    int has_arg;
    int *flag;
    int val;
};

__declspec(dllexport) int getopt_long(int argc, char *const argv[], const char *optstring,
                                      const struct option *longopts, int *longindex) 
{
    if (optind >= argc) return -1;
    char *arg = argv[optind];
    if (arg[0] != '-' || arg[1] == '\0') return -1;
    if (strcmp(arg, "--") == 0) { optind++; return -1; }

    if (arg[1] == '-') {
        arg += 2;
        for (int i = 0; longopts[i].name; i++) {
            size_t len = strlen(longopts[i].name);
            if (strncmp(arg, longopts[i].name, len) == 0) {
                if (longindex) *longindex = i;
                optarg = NULL;
                if (longopts[i].has_arg != no_argument) {
                    char *eq = strchr(arg, '=');
                    if (eq) optarg = eq + 1;
                    else if (longopts[i].has_arg == required_argument) {
                        if (optind + 1 < argc) optarg = argv[++optind];
                        else { if (opterr) fprintf(stderr, "Option --%s requires argument\n", longopts[i].name); optind++; return '?'; }
                    }
                }
                optind++;
                if (longopts[i].flag) { *longopts[i].flag = longopts[i].val; return 0; }
                return longopts[i].val;
            }
        }
        if (opterr) fprintf(stderr, "Unknown option --%s\n", arg);
        optind++;
        return '?';
    }

    return getopt(argc, argv, optstring);
}

__declspec(dllexport) int getopt_long_only(int argc, char *const argv[], const char *optstring,
                                           const struct option *longopts, int *longindex)
{
    if (optind >= argc) return -1;
    char *arg = argv[optind];
    if (arg[0] != '-' || arg[1] == '\0') return -1;

    if (arg[1] != '-') arg--; // treat -option as --option
    return getopt_long(argc, argv, optstring, longopts, longindex);
}
