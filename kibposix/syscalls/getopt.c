#include <stdio.h>
#include <string.h>

int optind = 1;
char *optarg = NULL;
int opterr = 1;
int optopt = 0;

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

