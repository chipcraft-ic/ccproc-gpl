ifndef CCPROC_HOME
  $(error Define CCPROC_HOME variable, eg.: $(HOME)/ccproc!)
endif

CC                  =   gcc

TKCONFIG            =   $(CCPROC_HOME)/bin/tkconfig
INOUT               =   $(CCPROC_HOME)/lib/inout
DEFINE              =   $(CCPROC_HOME)/lib/define

CURDIR              :=  $(shell pwd)
BUILDDIR            :=  $(shell echo $(CURDIR) | md5sum | cut -f1 -d' ')

ANSI_COLOR          :=  \e[34;1m
ANSI_RESET          :=  \e[0m

BASEDIR             =   ../..

LINT_TARGET         ?=  $(TOP)

INCLIST             =   $(INCDIR)"$(CCPROC_HOME)/lib/CORE/extensions" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/CORE/include" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/UART/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/SPI/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/I2C_MST/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/I2C_SLV/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/TIMER/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/SYSTICK/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/WATCHDOG/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/PDMA/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/GPIO/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/REGISTERS/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/RTC/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/HHG110ULLFMC/rtl/" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/HHG110ULLFMC/rtl/bist/RTL" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/AMBA/HHG110ULLFMC/rtl/bist/test_bench" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/OPENCORES/CAN/rtl/verilog" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/OPENCORES/ETH/rtl/verilog" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/OPENCORES/ETH/bench/verilog" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/OPENCORES/MOR1KX" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/MBIST/rtl" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/FPU/beh" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/JTAG/tasks" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/FT" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/debug/tasks" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/define" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/inout/auto" \
                        $(INCDIR)"$(CCPROC_HOME)/lib/sim"

RTPG_RUNS           ?=  500

#WORKLIBBASE         ?=  $(CURDIR)
ifndef WORKLIBBASE
  $(error Define WORKLIBBASE variable, eg.: $(CURDIR)!)
endif

WORKLIBDIR          =   $(WORKLIBBASE)/$(TOP)_$(BUILDDIR)

VLOGSTART           =   vlog
VLOGPARAMS          =   -sv -quiet +define+ASSERTIONS $(VLOG_OTHER_PARAMS) -work $(WORKLIBDIR)/work

NCSIMSTART          =   ncvlog
NCSIMBASE           =   -sv -quiet -work worklib
NCSIMASSERT         =   -define ASSERTIONS
NCSIMPARAMS         =   $(NCSIMBASE) $(NCSIMASSERT) $(NCSIM_OTHER_PARAMS)
NCELABPARAMS        =   -timescale 100ps/10ps -nowarn MEMODR -access +rwc $(NCELAB_OTHER_PARAMS)

IVERIPARAMS         =   -Wno-timescale \
                        -Wno-sensitivity-entire-array \
                        -Wno-sensitivity-entire-vector \
                        -g2012 \
                        -DICARUS_COMPILATION

ifneq (,$(wildcard configpar.vh))
	ifeq ($(shell grep "CFG_RV32_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'),32'd0)
		CCPROC_TESTS_LIST   ?=  $(CCPROC_HOME)/verif/tests/mi32_tests.list
	else
		CCPROC_TESTS_LIST   ?=  $(CCPROC_HOME)/verif/tests/rv32_tests.list
	endif
endif

RTPG_ENGINE         ?=  csmith
RTPG_LOG_FILES      =   logs/*rtpg_results.txt
TESTS_LOG_FILE      ?=  logs/tests.log
BENCHMARKS_LOG_FILE ?=  logs/benchmarks.log
TORTURE_LOG_FILE    ?=  logs/torture_$(RTPG_ENGINE).log
TORTURE_PART_FILE   ?=  logs/torture.part

mkdevice.o: $(TKCONFIG)/mkdevice.c
	@$(CC) -g -c $<

mkmbist.o: $(TKCONFIG)/mkmbist.c
	@$(CC) -g -c -lm $<

mkdefine.o: $(TKCONFIG)/mkdefine.c
	@$(CC) -g -c $<

tkparse.o: $(TKCONFIG)/tkparse.c
	@$(CC) -g -c $<

tkcond.o: $(TKCONFIG)/tkcond.c
	@$(CC) -g -c $<

tkgen.o: $(TKCONFIG)/tkgen.c
	@$(CC) -g -c $<

tkparse.exe: tkparse.o tkcond.o tkgen.o
	@$(CC) -g tkparse.o tkcond.o tkgen.o -o tkparse.exe

mkdevice.exe: mkdevice.o
	@$(CC) -g mkdevice.o -o mkdevice.exe

mkmbist.exe: mkmbist.o
	@$(CC) -g mkmbist.o -lm -o mkmbist.exe

mkdefine.exe: mkdefine.o
	@$(CC) -g mkdefine.o -o mkdefine.exe

mkinout.exe:
	@$(CC) -g $(TKCONFIG)/mkinout.c -o mkinout.exe

lconfig.tk: config.in
	make main.tk
	cat $(TKCONFIG)/header.tk main.tk $(TKCONFIG)/tail.tk > lconfig.tk
	chmod a+x lconfig.tk

main.tk : config.in tkparse.exe mkdefine.exe mkdevice.exe mkmbist.exe mkinout.exe
	./tkparse.exe config.in $(CCPROC_HOME) > main.tk

mkhelp:
	@cat $(CCPROC_HOME)/lib/synthesis/synthesis.in.help > config.help
	@cat $(CCPROC_HOME)/lib/sim/clock.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/CORE/integer.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/FPU/fpu.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/GNSS/gnss.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/memory/memory.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/memory/icache.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/memory/dcache.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/MBIST/mbist.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/FT/ft.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/mtctrl.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/power.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/irq.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/count.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/stack.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/mpu.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/fft.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/pmem.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/peripherals/gnss.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/AMBA/amba0.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/AMBA/dma.in.help >> config.help
	@cat $(CCPROC_HOME)/lib/AMBA/serial.in.help >> config.help

xconfig: lconfig.tk mkhelp inoutcheck
	@echo "" > defconfig
	@if type wish86 &> /dev/null; then \
		wish86 -f lconfig.tk; \
	else \
		wish -f lconfig.tk; \
	fi ; \
	if [ $$? -eq 2 ] ; then \
		./mkdevice.exe < .config; \
		./mkdefine.exe < configpar.vh; \
		./mkmbist.exe configval.vh; \
	fi

mkdefine: mkdefine.exe
	@./mkdefine.exe < configpar.vh

inoutcheck:
	@if [ ! -d "$(INOUT)/auto" ] || [ ! -f "$(CCPROC_HOME)/lib/define/paths.vh" ]; then \
		make inoutlib ;\
	fi

configvalcheck:
	@if [ ! -f "configval.vh" ]; then \
		./mkdevice.exe < .config; \
	fi
	@./mkdefine.exe < configpar.vh
	@./mkmbist.exe configval.vh

inoutlib: mkinout.exe
	-rm -rf $(INOUT)/*~
	-rm -rf $(INOUT)/auto/*.v
	mkdir -p $(INOUT)/auto
	./mkinout.exe $(INOUT) $(DEFINE) CFG_CORE_NUM

iverilib:
	@mkdir -p $(WORKLIBDIR)/iveri
	@echo "" > $(WORKLIBDIR)/iveri/testbench.vcd
	@rm -rf testbench.vcd
	@ln -s $(WORKLIBDIR)/iveri/testbench.vcd testbench.vcd

vsimlib:
	-rm -rf $(WORKLIBDIR)/work
	mkdir -p $(WORKLIBDIR)/work
	vlib $(WORKLIBDIR)/work

ncsimlib:
	@rm -rf $(WORKLIBDIR)
	@mkdir -p $(WORKLIBDIR)/nxsim
	@echo "DEFINE WORK worklib" > hdl.var
	@echo "DEFINE worklib $(WORKLIBDIR)/nxsim" > cds.lib

compilelist: configvalcheck inoutcheck

	@cat $(CCPROC_HOME)/lib/arith/compile.list > compile.list
	@cat $(CCPROC_HOME)/lib/basic/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/clock/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/sim/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/disasm/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/dft/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/memory/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/debug/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/peripherals/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/peripherals/fifo/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/peripherals/adc/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/AMBA/UART/compile.list >> compile.list

	@if [ `grep "CFG_GNSS_ISE_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/GNSS/compile.list >> compile.list; fi

	@if [ `grep "CFG_FFT_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/peripherals/fft/compile.list >> compile.list; fi

	@if [ `grep "CFG_EMULATOR_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/emulator/compile.list >> compile.list; fi

	@if [ `grep "CFG_32BT_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] || [ `grep "CFG_16BT_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ]; then \
		cat $(CCPROC_HOME)/lib/AMBA/TIMER/compile.list >> compile.list; fi	

	@if [ `grep "CFG_RTC_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/RTC/compile.list >> compile.list; fi

	@if [ `grep "CFG_SYSTICK_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/SYSTICK/compile.list >> compile.list; fi

	@if [ `grep "CFG_WDT_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/WATCHDOG/compile.list >> compile.list; fi

	@if [ `grep "CFG_SPI_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/SPI/compile.list >> compile.list; fi

	@if [ `grep "CFG_I2C_MST_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/I2C_MST/compile.list >> compile.list; fi

	@if [ `grep "CFG_I2C_SLV_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/I2C_SLV/compile.list >> compile.list; fi

	@if [ `grep "CFG_GPIO_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/GPIO/compile.list >> compile.list; fi

	@if [ `grep "CFG_DMA_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/PDMA/compile.list >> compile.list; fi

	@if [ `grep "CFG_OCCAN_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/OPENCORES/CAN/compile.list >> compile.list; fi

	@if [ `grep "CFG_ONE_WIRE_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/OPENCORES/1WIRE/compile.list >> compile.list; fi

	@if [ `grep "CFG_OCETH_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/OPENCORES/ETH/compile.list >> compile.list; fi

	@if [ `grep "CFG_BLE_NUM" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/BLE/compile.list >> compile.list; fi

	@if [ `grep "CFG_MBIST_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/MBIST/compile.list >> compile.list; fi

	@if [ `grep "CFG_JTAG_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/JTAG/compile.list >> compile.list; fi

	@if [ `grep "CFG_FPU_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/FPU/compile.list >> compile.list; fi

	@if [ `grep "CFG_LOCKSTEP_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] || [ `grep "CFG_ICACHE_FTBITS" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] || [ `grep "CFG_DCACHE_FTBITS" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ]; then \
		cat $(CCPROC_HOME)/lib/FT/compile.list >> compile.list; fi

	@if [ `grep "CFG_TARGET_ASIC" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/tech/faraday130/compile.list >> compile.list; fi

	@if [ `grep "CFG_TARGET_ASIC" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd2" ] ; then \
		cat $(CCPROC_HOME)/lib/AMBA/HHG110ULLFMC/compile.list >> compile.list; \
		cat $(CCPROC_HOME)/lib/tech/hhg110ull/compile.list >> compile.list; fi

	@if [ `grep "CFG_RV32_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd0" ] ; then \
		cat $(CCPROC_HOME)/lib/CORE/mi32pipeline6s/compile.list >> compile.list; fi

	@if [ `grep "CFG_RV32_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd1" ] ; then \
		cat $(CCPROC_HOME)/lib/CORE/rv32pipeline1s/compile.list >> compile.list; fi

	@if [ `grep "CFG_RV32_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` = "32'd2" ] ; then \
		cat $(CCPROC_HOME)/lib/CORE/rv32pipeline6s/compile.list >> compile.list; fi

	@cat $(CCPROC_HOME)/lib/CORE/extensions/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/CORE/compile.list >> compile.list

	@cat $(CCPROC_HOME)/lib/AMBA/COMMON/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/AMBA/REGISTERS/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/WISHBONE/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/AMBA/APB/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/AMBA/AHB/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/AMBA/AXI/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/AMBA/compile.list >> compile.list
	@cat $(CCPROC_HOME)/lib/tech/models/compile.list >> compile.list

	@sed -i 's@$(BASEDIR)@$(CCPROC_HOME)@' compile.list

	@-cat compile.top >> compile.list

	@cat compile.list > compile.lint
	@echo "" > exclude.sh
	@for i in `cat $(CCPROC_HOME)/lint/exclude.lint`; do \
		echo "sed -i 's@$$i@@' compile.lint" >> exclude.sh; \
	done
	@sed -i 's@$(BASEDIR)@$(CCPROC_HOME)@' exclude.sh
	@sh exclude.sh
	@grep '[^[:blank:]]' < compile.lint > compile.tmp
	@mv compile.tmp compile.lint

iveri: lconfig.tk mkhelp mkdefine compilelist iverilib
	$(eval INCDIR := -I )
	iverilog \
	-c compile.list \
	-s testbench \
	-o testbench.vvp \
	-tvvp -Wall \
	$(IVERIPARAMS) \
	$(IVERIOTHER) \
	$(INCLIST) \

iveri-trace:
	@make IVERIOTHER="-DICARUS_DUMP" iveri

iveri-debug:
	@make IVERIOTHER="-pfileline=1" iveri

iveri-wave:
	@gtkwave testbench.vcd &

vsim: lconfig.tk mkhelp mkdefine compilelist vsimlib
	$(eval INCDIR := +incdir+)
	@for i in `cat compile.list`; do if [[ $$i == *.v ]] || [[ $$i == *.sv ]]; then $(VLOGSTART) $(VLOGPARAMS) \
	$(INCLIST) \
	$$i;\echo "$(VLOGSTART) $(VLOGPARAMS) $$i"; fi; done

ncsim: lconfig.tk mkhelp mkdefine compilelist ncsimlib
	$(eval INCDIR := -incdir )
	@for i in `cat compile.list`; do if [[ $$i == *.v ]] || [[ $$i == *.sv ]]; then $(NCSIMSTART) \
	$(INCLIST) \
	$(NCSIMPARAMS) $$i;\echo "$(NCSIMSTART) $(NCSIMPARAMS) $$i"; fi; done
	@ncelab $(NCELABPARAMS) testbench

ncsim-debug:
	make NCSIM_OTHER_PARAMS="-define DBG_TEST" ncsim

ncsim-debug-mbist:
	make NCSIM_OTHER_PARAMS="-define DBG_MBIST_TEST" ncsim

ncsim-jtag:
	make NCSIM_OTHER_PARAMS="-define JTAG_TEST" ncsim

ncsim-jtag-mbist:
	make NCSIM_OTHER_PARAMS="-define JTAG_MBIST_TEST" ncsim

ncsim-update:
	ncupdate -verbose work.testbench

irun: lconfig.tk mkhelp mkdefine compilelist ncsimlib
	$(eval INCDIR := -incdir )
	@irun -q -sv -gui \
	-ALLOWREDEFINITION \
	$(INCLIST) \
	-define ASSERTIONS \
	-F compile.list \
	-top testbench

irun-lint: mkdefine compilelist ncsimlib
	$(eval INCDIR := -incdir )
	@irun -superlint \
	-ALLOWREDEFINITION \
	-define LINT \
	$(INCLIST) \
	-F compile.lint \
	-l logs/superlint.log \
	-top $(LINT_TARGET)

tests:
	@echo "----------------------------------------------------------------------------------" > $(TESTS_LOG_FILE)
	@echo "-------------------- START TESTS -------------------------------------------------" >> $(TESTS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TESTS_LOG_FILE)
	@echo "" >> $(TESTS_LOG_FILE)
	@rm -f $(RTPG_LOG_FILES)
	@while read -r i; do \
		make clean-soft ;\
		$$i ;\
		if [ -f "mem.hex" ]; then \
			echo "" >> $(TESTS_LOG_FILE) ;\
			echo "---------------------------------------------------------------" >> $(TESTS_LOG_FILE) ;\
			echo "TEST ARGS: $$i" >> $(TESTS_LOG_FILE) ;\
			echo "---------------------------------------------------------------" >> $(TESTS_LOG_FILE) ;\
			echo "DATE:      $$(date)" >> $(TESTS_LOG_FILE) ;\
			echo "---------------------------------------------------------------" >> $(TESTS_LOG_FILE) ;\
			echo "" >> $(TESTS_LOG_FILE) ;\
			echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)TEST ARGS: $$i$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)DATE:      $$(date)$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo "" ;\
			$(PROGPARAMS) | tee -a $(TESTS_LOG_FILE) ;\
		fi ;\
	done < $(CCPROC_TESTS_LIST)
	@echo "" >> $(TESTS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TESTS_LOG_FILE)
	@echo "-------------------- SUMMARY $$(date)" >> $(TESTS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TESTS_LOG_FILE)
	@echo "" >> $(TESTS_LOG_FILE)
	@$(CCPROC_HOME)/bin/utils/logParser.sh $(TESTS_LOG_FILE)
	@echo "" >> $(TESTS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TESTS_LOG_FILE)
	@echo "-------------------- END TESTS ---------------------------------------------------" >> $(TESTS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TESTS_LOG_FILE)

irun-tests:
	make PROGPARAMS="irun -quiet -top testbench" tests

ncsim-tests:
	make PROGPARAMS="ncsim -nontcglitch -licqueue testbench" tests

vsim-tests:
	make PROGPARAMS="vsim -c -vopt -do $(CCPROC_HOME)/bin/utils/vsim.do -onfinish exit -lib $(WORKLIBDIR)/work testbench" tests

iveri-tests:
	make PROGPARAMS="vvp -n testbench.vvp" tests

vlsim-tests:
	make PROGPARAMS="./obj_dir/ccproc_simulator" tests

benchmarks:
	@echo "----------------------------------------------------------------------------------" > $(BENCHMARKS_LOG_FILE)
	@echo "-------------------- START BENCHMARKS --------------------------------------------" >> $(BENCHMARKS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(BENCHMARKS_LOG_FILE)
	@echo "" >> $(BENCHMARKS_LOG_FILE)
	@rm -f $(RTPG_LOG_FILES)
	@while read -r i; do \
		make clean-soft ;\
		$$i ;\
		if [ -f "mem.hex" ]; then \
			echo "" >> $(BENCHMARKS_LOG_FILE) ;\
			echo "---------------------------------------------------------------" >> $(BENCHMARKS_LOG_FILE) ;\
			echo "BENCHMARK ARGS: $$i" >> $(BENCHMARKS_LOG_FILE) ;\
			echo "---------------------------------------------------------------" >> $(BENCHMARKS_LOG_FILE) ;\
			echo "DATE:           $$(date)" >> $(BENCHMARKS_LOG_FILE) ;\
			echo "---------------------------------------------------------------" >> $(BENCHMARKS_LOG_FILE) ;\
			echo "" >> $(BENCHMARKS_LOG_FILE) ;\
			echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)BENCHMARK ARGS: $$i$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)DATE:           $$(date)$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo "" ;\
			$(PROGPARAMS) | tee -a $(BENCHMARKS_LOG_FILE) ;\
		fi ;\
	done < $(CCPROC_HOME)/verif/tests/benchmarks.list
	@echo "" >> $(BENCHMARKS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(BENCHMARKS_LOG_FILE)
	@echo "-------------------- END BENCHMARKS ----------------------------------------------" >> $(BENCHMARKS_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(BENCHMARKS_LOG_FILE)

irun-benchmarks:
	@make PROGPARAMS="irun -quiet -top testbench" benchmarks

ncsim-benchmarks:
	@make PROGPARAMS="ncsim -nontcglitch -licqueue testbench" benchmarks

iveri-benchmarks:
	@make PROGPARAMS="vvp -n testbench.vvp" benchmarks

vlsim-benchmarks:
	make PROGPARAMS="./obj_dir/ccproc_simulator" benchmarks

vsim-benchmarks:
	make PROGPARAMS="vsim -c -vopt -do $(CCPROC_HOME)/bin/utils/vsim.do -onfinish exit -lib $(WORKLIBDIR)/work testbench" benchmarks

torture:
	@rm -f $(CURDIR)/*.failed
	@echo "" > $(TORTURE_LOG_FILE)
	@echo "" > logs/torture.tmp
	@echo "" > logs/0rtpg_results.txt
	@echo "" > logs/1rtpg_results.txt
	@tortureIter=0
	@while [[ $$tortureIter -lt $(RTPG_RUNS) ]] ; do \
		make clean-soft ;\
		make RTPG_ENGINE=$(RTPG_ENGINE) torture-gen ;\
		if [ -f "mem.hex" ]; then \
			((tortureIter = tortureIter + 1)) ;\
			make RTPG_ENGINE=$(RTPG_ENGINE) torture-gen ;\
			echo -ne "$(ANSI_COLOR)----------------------------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)RTPG RUN: $$tortureIter of $(RTPG_RUNS)$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)----------------------------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)DATE:     $$(date)$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)----------------------------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)ENGINE:   $(RTPG_ENGINE)$(ANSI_RESET)\n" ;\
			echo -ne "$(ANSI_COLOR)----------------------------------------------------------------------------------$(ANSI_RESET)\n" ;\
			echo "----------------------------------------------------------------------------------" > $(TORTURE_PART_FILE) ;\
			echo "RTPG RUN: $$tortureIter" >> $(TORTURE_PART_FILE) ;\
			echo "----------------------------------------------------------------------------------" >> $(TORTURE_PART_FILE) ;\
			echo "DATE:     $$(date)" >> $(TORTURE_PART_FILE) ;\
			echo "----------------------------------------------------------------------------------" >> $(TORTURE_PART_FILE) ;\
			$(PROGPARAMS) | tee $(TORTURE_PART_FILE) ;\
			cat $(TORTURE_PART_FILE) >> logs/torture.tmp ;\
			if [[ `grep -oP "_ERROR" "$(TORTURE_PART_FILE)"` ]] ; then \
				cp $(RTPG_ENGINE)-test.srec $(RTPG_ENGINE)-test_$$tortureIter.failed ;\
			fi ;\
		fi ;\
	done
	@echo "----------------------------------------------------------------------------------" > $(TORTURE_LOG_FILE)
	@echo "-------------------- TORTURE TESTS -----------------------------------------------" >> $(TORTURE_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TORTURE_LOG_FILE)
	@echo "" >> $(TORTURE_LOG_FILE)
	@echo "DATE:      $$(date)" >> $(TORTURE_LOG_FILE)
	@echo "RTPG RUNS: $(RTPG_RUNS)" >> $(TORTURE_LOG_FILE)
	@if [[ `grep -oP "_ERROR" "logs/torture.tmp"` ]] ; then \
		echo FAILURES DETECTED >> $(TORTURE_LOG_FILE) ;\
		echo failing runs in x.failed >> $(TORTURE_LOG_FILE) ;\
	else \
		echo TESTS PASSED  >> $(TORTURE_LOG_FILE) ;\
		rm -f logs/torture.tmp ;\
	fi
	@echo "" >> $(TORTURE_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TORTURE_LOG_FILE)
	@echo "-------------------- RTPG SUMMARY ------------------------------------------------" >> $(TORTURE_LOG_FILE)
	@echo "----------------------------------------------------------------------------------" >> $(TORTURE_LOG_FILE)
	@echo "" >> $(TORTURE_LOG_FILE)
	@if [[ `head -c 10 logs/1rtpg_results.txt` = "RTPG_RESET" ]] ; then \
		cat logs/1rtpg_results.txt >> $(TORTURE_LOG_FILE) ;\
	else \
		cat logs/0rtpg_results.txt >> $(TORTURE_LOG_FILE) ;\
	fi
	@rm -f $(TORTURE_PART_FILE) ;\

irun-torture:
	@make PROGPARAMS="irun -quiet -top testbench" torture

ncsim-torture:
	@make PROGPARAMS="ncsim -nontcglitch -licqueue testbench" torture

vsim-torture:
	@make PROGPARAMS="vsim -c -novopt -do $(CCPROC_HOME)/bin/utils/vsim.do -onfinish exit -lib $(WORKLIBDIR)/work testbench" torture

iveri-torture:
	@make PROGPARAMS="vvp -n testbench.vvp" torture

iveri-launch:
	vvp -n testbench.vvp

vsim-launch:
	vsim -novopt -onfinish stop -lib $(WORKLIBDIR)/work -gui testbench &

ncsim-launch:
	ncsim -nontcglitch -licqueue -gui testbench &

ncsim-launch-nogui:
	ncsim -nontcglitch -licqueue testbench &

ncsim-vcd-script:
	@echo "database -open -vcd VCD_RESULTS -into $(WORKLIBDIR)/$(TOP).vcd -default -timescale ps" > ncsim.vcd
	@echo "probe -all -depth all -database VCD_RESULTS -create" >> ncsim.vcd
	@echo "run" >> ncsim.vcd
	@echo "database -close VCD_RESULTS" >> ncsim.vcd
	@echo "exit" >> ncsim.vcd

ncsim-launch-vcd: ncsim-vcd-script
	ncsim -gui -nontcglitch -licqueue -input "ncsim.vcd" testbench &

ncsim-launch-vcd-nogui: ncsim-vcd-script
	ncsim -nontcglitch -licqueue -input "ncsim.vcd" testbench &

corners-copy:
	@rsync -r --links --exclude=.svn "$(CURDIR)/" "$(CURDIR)_bc"
	@rsync -r --links --exclude=.svn "$(CURDIR)/" "$(CURDIR)_tc"
	@rsync -r --links --exclude=.svn "$(CURDIR)/" "$(CURDIR)_wc"
	@sed -i 's@CORNER              ?=  wc@CORNER              ?=  bc@' $(CURDIR)_bc/Makefile
	@sed -i 's@CORNER              ?=  wc@CORNER              ?=  tc@' $(CURDIR)_tc/Makefile
	@sed -i 's@CORNER              ?=  wc@CORNER              ?=  wc@' $(CURDIR)_wc/Makefile
	@sed -i 's@POSTFIX             ?=  @POSTFIX             ?=  _bc@' $(CURDIR)_bc/Makefile
	@sed -i 's@POSTFIX             ?=  @POSTFIX             ?=  _tc@' $(CURDIR)_tc/Makefile
	@sed -i 's@POSTFIX             ?=  @POSTFIX             ?=  _wc@' $(CURDIR)_wc/Makefile

corners-delete:
	rm -rf "$(CURDIR)_bc"
	rm -rf "$(CURDIR)_tc"
	rm -rf "$(CURDIR)_wc"

help-defines:
	@echo ""
	@echo "Defines:"
	@echo "  GATE                      - synthesis define"
	@echo "  LINT                      - linting define"
	@echo "  ASSERTIONS                - use assertions"
	@echo "  VERILATOR_COMPILATION     - indicate Verilator compilation"
	@echo "  IVERILOG_COMPILATION      - indicate Icarus Verilog compilation"
	@echo "  ICG_TE_TO_TM              - connect clock gating cells 'test_enable' to 'test_mode' signal"
	@echo "  ICG_TE_TO_SE              - connect clock gating cells 'test_enable' to 'scan_enable' signal"
	@echo "  ICG_TE_TO_NONE            - do not connect clock gating cells 'test_enable' signal"
	@echo ""

help-bin:
	@echo ""
	@echo "Configuration:"
	@echo "  xconfig                   - run graphical configuration tool"
	@echo ""
	@echo "Compilation:"
	@echo "  iveri                     - compile design using Icarus Verilog"
	@echo "  iveri-debug               - compile design using Icarus Verilog with '-pfileline=1' option"
	@echo "  iveri-trace               - compile design using Icarus Verilog with vcd dump"
	@echo "  vlsim                     - compile design using Verialtor (only with simulator or asic-core-template designs)"
	@echo "  vlsim-trace               - compile design using Verialtor with '--trace' option (only with simulator or asic-core-template designs)"
	@echo "  ncsim                     - compile design using Cadence Incisive Enterprise Simulator"
	@echo "  ncsim-debug               - compile design using Cadence Incisive Enterprise Simulator with '-define DBG_TEST' option"
	@echo "  ncsim-debug-mbist         - compile design using Cadence Incisive Enterprise Simulator with '-define DBG_MBIST_TEST' option"
	@echo "  ncsim-jtag                - compile design using Cadence Incisive Enterprise Simulator with '-define JTAG_TEST' option"
	@echo "  ncsim-jtag-mbist          - compile design using Cadence Incisive Enterprise Simulator with '-define JTAG_MBIST_TEST' option"
	@echo "  ncsim-update              - update Cadence Incisive Enterprise Simulator snapshot"
	@echo "  irun                      - compile and launch design using Cadence Incisive Enterprise Simulator"
	@echo "  vsim                      - compile design using Questa Advanced Simulator"
	@echo ""
	@echo "Simulation:"
	@echo "  iveri-launch              - simulate Icarus Verilog compiled design"
	@echo "  vlsim-launch              - simulate Verialtor compiled design (only with simulator or asic-core-template designs)"
	@echo "  ncsim-launch              - simulate Cadence Incisive Enterprise Simulator compiled design"
	@echo "  vsim-launch               - simulate Questa Advanced Simulator compiled design"
	@echo ""
	@echo "Show waveform:"
	@echo "  iveri-wave                - show Icarus Verilog waveform"
	@echo "  vlsim-wave                - show Verilator waveform"
	@echo ""
	@echo "Linting:"
	@echo "  vlsim-lint                - lint using Verilator"
	@echo "  irun-lint                 - lint using Cadence Formal Verifier"
	@echo ""
	@echo "Run tests:"
	@echo "  iveri-tests               - run tests using Icarus Verilog"
	@echo "  vlsim-tests               - run tests using Verialtor (only with simulator design)"
	@echo "  ncsim-tests               - run tests using Cadence Incisive Enterprise Simulator"
	@echo "  irun-tests                - run tests using Cadence Incisive Enterprise Simulator"
	@echo "  vsim-tests                - run tests using Questa Advanced Simulator"
	@echo ""
	@echo "Run benchmarks:"
	@echo "  iveri-benchmarks          - run benchmarks using Icarus Verilog"
	@echo "  vlsim-benchmarks          - run benchmarks using Verialtor (only with simulator design)"
	@echo "  ncsim-benchmarks          - run-benchmarks using Cadence Incisive Enterprise Simulator"
	@echo "  irun-benchmarks           - run benchmarks using Cadence Incisive Enterprise Simulator"
	@echo "  vsim-benchmarks           - run benchmarks using Questa Advanced Simulator"
	@echo ""
	@echo "Run torture tests:"
	@echo "  iveri-torture             - run torture tests using Icarus Verilog"
	@echo "                                e.g. 'make RTPG_ENGINE=csmith RTPG_RUNS=500 iveri-torture'"
	@echo "  ncsim-torture             - run torture tests using Cadence Incisive Enterprise Simulator"
	@echo "                                e.g. 'make RTPG_ENGINE=csmith RTPG_RUNS=500 ncsim-torture'"
	@echo "  irun-torture              - run torture tests using Cadence Incisive Enterprise Simulator"
	@echo "                                e.g. 'make RTPG_ENGINE=csmith RTPG_RUNS=500 irun-torture'"
	@echo "  vsim-torture              - run torture tests using Questa Advanced Simulator"
	@echo "                                e.g. 'make RTPG_ENGINE=csmith RTPG_RUNS=500 vsim-torture'"
	@echo ""
	@echo "Clean:"
	@echo "  clean                     - clean design"
	@echo ""

clean:
	rm -rf $(WORKLIBDIR) *nxsim* isim cds.lib DATA_OUT cov_work INCA_libs defconfig
	rm -rf hdl.var mkdevice* mkmbist* mkdefine* *.tk *.o *.h *.help *.exe vsim.wlf wlft* *~ nc*
	rm -rf *transcript* *waves* *.diag *.log *.txt *.vcd *.list *.lint exclude.sh .formalrun
	rm -rf .simvision *.key *.lock .lock *.log *.history .rtlchecks.log
	rm -rf hal.design_facts *.vvp *.dump *.objdump *.err
