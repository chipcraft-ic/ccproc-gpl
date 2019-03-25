ifneq (,$(wildcard configpar.vh))
	ifeq ($(shell grep "CFG_RV32_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'),32'd0)
		include $(CCPROC_HOME)/software/Makefile.mi32
	else
		include $(CCPROC_HOME)/software/Makefile.rv32
	endif
endif
