PROGNAME       := yarpgen-test

COMMON_SOURCES := syscalls.c uart.c

CPPFLAGS += -D_EXEC_TIMEOUT=8192
CPPFLAGS += -D_DONT_BREAK_ON_EXCEPTION

ifdef MI16_ENABLE
	CPPFLAGS += -D_MI16_ENABLE -mips16
endif

include $(COMMON_DIR)/generic.mk
