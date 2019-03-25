#CCPROC_HOME=../..
ifndef CCPROC_HOME
  $(error Define CCPROC_HOME variable, eg.: $(HOME)/ccproc!)
endif

TOP             =   core_template

include $(CCPROC_HOME)/bin/Makefile

help: help-bin help-defines help-soft

SREC_SIZE       ?=  256
CCSDK_BOARD     =   sim

VLSIMCOMMON     =   -Wno-COMBDLY \
                    -Wwarn-IMPLICIT \
                    -Wwarn-UNOPTFLAT \
                    -O3 \
                    --unroll-count 157248 \
                    --unroll-stmts 157248 \
                    -CFLAGS '-O3' \
                    --x-assign 0 \
                    --x-initial-edge \
                    --stats \
                    --noassert \
                    --top-module testbench \
                    -DVERILATOR_COMPILATION \
                    -DGATE \

VLSIMSIM        =   -Wno-lint 

VLSIMTRACE      =   --trace

vlsimcheck:
	@if [ ! -f "$(VERILATOR_ROOT)/bin/verilator_includer" ]; then \
		ln -s $(VERILATOR_ROOT)/share/verilator/include $(VERILATOR_ROOT)/include ;\
		ln -s $(VERILATOR_ROOT)/share/verilator/bin/verilator_includer $(VERILATOR_ROOT)/bin/verilator_includer ;\
	fi

vlsimclean:
	@rm -rf obj_dir/*.o obj_dir/*.d obj_dir/*.a obj_dir/*.cpp obj_dir/*.h obj_dir/*.txt obj_dir/*.mk obj_dir/Vtestbench* obj_dir/core_template*

vlsimlist:
	@cat compile.list > compile.vlsim
	@echo "" > exclude.sh
	@for i in `cat $(CCPROC_HOME)/lint/exclude.vlsim`; do \
		echo "sed -i 's@$$i@@' compile.vlsim" >> exclude.sh; \
	done
	@sed -i 's@$(BASEDIR)@$(CCPROC_HOME)@' exclude.sh
	@sh exclude.sh
	@grep '[^[:blank:]]' < compile.vlsim > compile.tmp
	@mv compile.tmp compile.vlsim

vlsim: vlsimcheck lconfig.tk mkhelp mkdefine compilelist vlsimclean vlsimlist
	$(eval INCDIR := -I)
	@-verilator --cc -f compile.vlsim $(VLSIMCOMMON) $(VLSIMSIM) $(INCLIST) $(VLOTHER) --exe core_template.cpp
	@cd obj_dir && make OPT_FAST="-O2" -j -f Vtestbench.mk Vtestbench && mv Vtestbench core_template

vlsim-trace:
	@make VLOTHER="$(VLSIMTRACE)" vlsim

vlsim-launch:
	@./obj_dir/core_template

vlsim-wave:
	@gtkwave vlsim.vcd &

include $(CCPROC_HOME)/software/Makefile
