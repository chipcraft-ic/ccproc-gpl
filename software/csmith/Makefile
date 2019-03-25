PROGNAME       := csmith-test

CSMITH_INCDIR  ?= $(shell ls -d ~/csmith/include/csmith-* | head -n1)

COMMON_SOURCES := syscalls.c uart.c

CPPFLAGS += -D_EXEC_TIMEOUT=8192
CPPFLAGS += -D_DONT_BREAK_ON_EXCEPTION
CPPFLAGS += -I$(CSMITH_INCDIR)

ifdef MI16_ENABLE
	CPPFLAGS += -D_MI16_ENABLE -mips16
	CPPFLAGS += -mflip-mips16
endif

include $(COMMON_DIR)/generic.mk
