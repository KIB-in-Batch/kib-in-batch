CC = clang
CFLAGS = -Wall -Wextra -O2 -DKIBPOSIX_BUILD_DLL
LDFLAGS = -shared -lkernel32 -ladvapi32 -luser32

# Source files
SYSCALL_SRCS = $(wildcard syscalls/*.c)
LIB_SRCS = $(wildcard lib/*.c)
ALL_SRCS = $(SYSCALL_SRCS) $(LIB_SRCS)
ALL_OBJS = $(ALL_SRCS:.c=.o)

# Output files
DLL = kibposix.dll
IMPLIB = libkibposix.dll.a

# Build rules
all: $(DLL)

$(DLL): $(ALL_OBJS)
	$(CC) -o $@ $^ $(LDFLAGS) -Xlinker /IMPLIB:$(IMPLIB)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm syscalls/*.o lib/*.o $(DLL) $(IMPLIB) kibposix.dll.exp

.PHONY: all clean
