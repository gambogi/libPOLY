# libPOLY Copyright (C) Travis Whitaker 2014

# This Makefile assumes Clang is available:
CC=clang
CFLAGS= -Wall -Wextra -Werror -pedantic -O2 -pipe -march=native
DEBUG_CFLAGS= -Wall -Wextra -Werror -pedantic -O0 -g -pipe -DDEBUG_MSG_ENABLE
INCLUDE= -I ./include

# You may need to change this to '-fpic' if you're using a strange
# architecture like ancient SPARC or MIPS:
FPIC = -fPIC

# Archiver fo rbuilding the static library:
AR=ar
ARFLAGS=rvs

# Default values for user-supplied compile time directives:
DEBUG_MSG=

# Enable debugging messages outside of the 'debug' target:
ifeq ($(DEBUG_MSG),y)
	CFLAGS += -DDEBUG_MSG_ENABLE
endif

.PHONY: all
all: libpoly.a

libpoly.a: client.o
	$(AR) $(ARFLAGS) libpoly.a client.o

client.o: src/client.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $(FPIC) src/client.c

.PHONY: debug
debug: libpolydebug.a

libpolydebug.a: client.o.debug
	$(AR) $(ARFLAGS) client.o.debug

client.o.debug:
	$(CC) -c $(DEBUG_CFLAGS) $(INCLUDE) $(FPIC) src/client.c -o client.o.debug

.PHONY: clean
clean:
	rm -f libpoly.a
	rm -f libpolydebug.a
	rm -f *.o
	rm -f *.o.debug
