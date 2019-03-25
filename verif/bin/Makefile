TESTCASES_JOBS              ?=  1
TESTCASES_LIM               :=  $(shell find $(CCPROC_HOME)/verif/testcases -type f -name "*.vh" | wc -l | awk '{print int($$1/$(TESTCASES_JOBS)+1)}')

NCSIM_IDCACHE_MISS_TEST     =   "-define ICACHE_MISS_TEST -define DCACHE_MISS_TEST"
VLOG_IDCACHE_MISS_TEST      =   "+define+ICACHE_MISS_TEST +define+DCACHE_MISS_TEST"

NCSIM_DEBUG_BREAK_TEST      =   "-define ICACHE_MISS_TEST -define DCACHE_MISS_TEST -define DEBUG_BREAK_TEST"
VLOG_DEBUG_BREAK_TEST       =   "+define+ICACHE_MISS_TEST +define+DCACHE_MISS_TEST +define+DEBUG_BREAK_TEST"

NUMBER                      ?=  ""

TEST_ARCH                   ?=  "mi32st"

torture-run:
	@echo "torture job $(NUMBER) is running" > ../.torture_job_$(NUMBER).lock
	@cp configpar.vh configpar.bak
	@for tc in `ls ./testcases | sort -r`; do \
		cp ./testcases/$$tc configpar.vh ;\
		sed -i -- "s/CFG_BOOT_EN(32'd1)/CFG_BOOT_EN(32'd0)/g" configpar.vh ;\
		if [ `echo $(RTPG_ENGINE)` = "agatrpg" ] ; then \
			sed -i -- "s/CFG_MI16_EN(32'd1)/CFG_MI16_EN(32'd0)/g" configpar.vh ;\
		fi ;\
		if [ `grep "CFG_ICACHE_FTBITS" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
			sed -i -- "s/CFG_ICACHE_LRR(32'd1)/CFG_ICACHE_LRR(32'd0)/g" configpar.vh ;\
			sed -i -- "s/CFG_ICACHE_RND(32'd0)/CFG_ICACHE_RND(32'd1)/g" configpar.vh ;\
		fi ;\
		make clean ;\
		make WORKLIBDIR=$(WORKLIBDIR) NCSIM_OTHER_PARAMS=$(NCSIM_IDCACHE_MISS_TEST) VLOG_OTHER_PARAMS=$(VLOG_IDCACHE_MISS_TEST) $(PROG) ;\
		echo "" >> logs/testcases_summary.log ;\
		echo "---------------------------------------------------------------" >> logs/testcases_summary.log ;\
		echo "TESTCASE: $$tc" >> logs/testcases_summary.log ;\
		echo "---------------------------------------------------------------" >> logs/testcases_summary.log ;\
		echo "ENGINE:   $(RTPG_ENGINE)" >> logs/testcases_summary.log ;\
		echo "---------------------------------------------------------------" >> logs/testcases_summary.log ;\
		echo "" >> logs/testcases_summary.log ;\
		make RTPG_ENGINE=$(RTPG_ENGINE) RTPG_RUNS=$(RTPG_RUNS) torture ;\
		mkdir $(CURDIR)/torture_failed_$$tc ;\
		mv $(CURDIR)/*.failed $(CURDIR)/torture_failed_$$tc ;\
		tail --line=+6 $(TORTURE_LOG_FILE) >> logs/testcases_summary.log ;\
	done
	@mv configpar.bak configpar.vh
	@rm -rf ../.torture_job_$(NUMBER).lock
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)END TESTCASES TORTURE ENGINE $(RTPG_ENGINE) JOB $(NUMBER)$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"

testcases-run:
	@echo "testcase job $(NUMBER) is running" > ../.testcase_job_$(NUMBER).lock
	@echo "----------------------------------------------------------------------------------" > logs/testcases.log
	@echo "-------------------- START TESTCASES ---------------------------------------------" >> logs/testcases.log
	@echo "----------------------------------------------------------------------------------" >> logs/testcases.log
	@echo "" >> logs/testcases.log
	@cp configpar.vh configpar.bak
	@for tc in `ls ./testcases | sort -r`; do \
		cp ./testcases/$$tc configpar.vh ;\
		if [ `grep "CFG_ICACHE_FTBITS" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` != "32'd0" ] ; then \
			sed -i -- "s/CFG_ICACHE_LRR(32'd1)/CFG_ICACHE_LRR(32'd0)/g" configpar.vh ;\
			sed -i -- "s/CFG_ICACHE_RND(32'd0)/CFG_ICACHE_RND(32'd1)/g" configpar.vh ;\
		fi ;\
		if [ `grep "CFG_ICACHE_WAY" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` == "32'd1" ] ; then \
			sed -i -- "s/CFG_ICACHE_LRR(32'd1)/CFG_ICACHE_LRR(32'd0)/g" configpar.vh ;\
			sed -i -- "s/CFG_ICACHE_RND(32'd1)/CFG_ICACHE_RND(32'd0)/g" configpar.vh ;\
		fi ;\
		make clean ;\
		make WORKLIBDIR=$(WORKLIBDIR) NCSIM_OTHER_PARAMS=$(NCSIM_IDCACHE_MISS_TEST) VLOG_OTHER_PARAMS=$(VLOG_IDCACHE_MISS_TEST) $(PROG) ;\
		echo "" >> logs/testcases.log ;\
		echo "---------------------------------------------------------------" >> logs/testcases.log ;\
		echo "TESTCASE: $$tc" >> logs/testcases.log ;\
		echo "---------------------------------------------------------------" >> logs/testcases.log ;\
		echo "DATE:     $$(date)" >> logs/testcases.log ;\
		echo "---------------------------------------------------------------" >> logs/testcases.log ;\
		while read -r i; do \
			make clean-soft ;\
			$$i ;\
			if [ -f "mem.hex" ]; then \
				echo "" >> logs/testcases.log ;\
				echo "---------------------------------------------------------------" >> logs/testcases.log ;\
				echo "TEST ARGS: $$i" >> logs/testcases.log ;\
				echo "---------------------------------------------------------------" >> logs/testcases.log ;\
				echo "DATE:      $$(date)" >> logs/testcases.log ;\
				echo "---------------------------------------------------------------" >> logs/testcases.log ;\
				echo "" >> logs/testcases.log ;\
				echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
				echo -ne "$(ANSI_COLOR)TEST ARGS: $$i$(ANSI_RESET)\n" ;\
				echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
				echo -ne "$(ANSI_COLOR)DATE:      $$(date)$(ANSI_RESET)\n" ;\
				echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
				echo "" ;\
				$(PROGPARAMS) | tee -a logs/testcases.log ;\
			fi ;\
		done < $(CCPROC_TESTS_LIST) ;\
		if [ `echo $(PROG)` != "vlsim" ] ; then \
			if [ `grep "CFG_LOCKSTEP_EN" configpar.vh | cut -f2 -d'(' | cut -f1 -d')'` == "32'd0" ] ; then \
				make clean ;\
				make WORKLIBDIR=$(WORKLIBDIR) NCSIM_OTHER_PARAMS=$(NCSIM_DEBUG_BREAK_TEST) VLOG_OTHER_PARAMS=$(VLOG_DEBUG_BREAK_TEST) $(PROG) ;\
				make clean-soft ;\
				make MISC=stress ITERATIONS=1 MI16_ENABLE=1 MI16_FLIP=1 MULTITHREAD=1 NO_DMA_STRESS=1 misc ;\
				if [ -f "mem.hex" ]; then \
					echo "" >> logs/testcases.log ;\
					echo "---------------------------------------------------------------" >> logs/testcases.log ;\
					echo "DEBUG BREAK TEST" >> logs/testcases.log ;\
					echo "---------------------------------------------------------------" >> logs/testcases.log ;\
					echo "DATE:      $$(date)" >> logs/testcases.log ;\
					echo "---------------------------------------------------------------" >> logs/testcases.log ;\
					echo "" >> logs/testcases.log ;\
					echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
					echo -ne "$(ANSI_COLOR)DEBUG BREAK TEST\n" ;\
					echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
					echo -ne "$(ANSI_COLOR)DATE:      $$(date)$(ANSI_RESET)\n" ;\
					echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n" ;\
					echo "" ;\
					$(PROGPARAMS) | tee -a logs/testcases.log ;\
				fi ;\
			fi ;\
		fi ;\
		echo "---------------------------------------------------------------" >> logs/testcases_summary.log ;\
		echo "TESTCASE: $$tc" >> logs/testcases_summary.log ;\
		echo "---------------------------------------------------------------" >> logs/testcases_summary.log ;\
		echo "" >> logs/testcases_summary.log ;\
		grep 'tests failed!' logs/testcases.log >> logs/testcases_summary.log ;\
		grep '_ERROR:' logs/testcases.log >> logs/testcases_summary.log ;\
		echo "" >> logs/testcases_summary.log ;\
		sed -i -- 's/failed!/failed./g' logs/testcases.log ;\
		sed -i -- 's/ERROR:/ERR:/g' logs/testcases.log ;\
	done
	@echo "----------------------------------------------------------------------------------" >> logs/testcases.log
	@echo "-------------------- END TESTCASES -----------------------------------------------" >> logs/testcases.log
	@echo "----------------------------------------------------------------------------------" >> logs/testcases.log
	@mv configpar.bak configpar.vh
	@rm -rf ../.testcase_job_$(NUMBER).lock
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)END TESTCASES JOB $(NUMBER)$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"

testcases-copy:
	@rsync -r --exclude=.svn "$(CCPROC_HOME)/verif/testcases/" "testcases_bak"
	@for ((NUMBER=1; NUMBER <= ${TESTCASES_JOBS}; ++NUMBER)) ; do \
		echo "$(CURDIR)_$${NUMBER}" ; \
		rsync -r --exclude=.svn --exclude=logs --exclude=testcases --exclude=testcases_bak "$(CURDIR)/" "$(CURDIR)_$${NUMBER}" ; \
		mkdir "$(CURDIR)_$${NUMBER}/logs" ; \
		mkdir "$(CURDIR)_$${NUMBER}/testcases" ; \
		echo "rm -rf $(WORKLIBDIR)_testcase_$${NUMBER}" > "$(CURDIR)_$${NUMBER}/run.sh" ; \
		echo "mkdir -p $(WORKLIBDIR)_testcase_$${NUMBER}" >> "$(CURDIR)_$${NUMBER}/run.sh" ; \
		if [ `echo $(PROG)` = "vsim" ] ; then \
			echo -e "(exec make WORKLIBDIR=$(WORKLIBDIR)_testcase_$${NUMBER} PROGPARAMS=\"$(PROGPARAMS) -lib $(WORKLIBDIR)_testcase_$${NUMBER}/work testbench\" PROG=$(PROG) NUMBER=$${NUMBER} $(JOB) &)" >> "$(CURDIR)_$${NUMBER}/run.sh" ; \
		else \
			echo -e "(exec make WORKLIBDIR=$(WORKLIBDIR)_testcase_$${NUMBER} PROGPARAMS=\"$(PROGPARAMS)\" PROG=$(PROG) NUMBER=$${NUMBER} $(JOB) &)" >> "$(CURDIR)_$${NUMBER}/run.sh" ; \
		fi ;\
		chmod +x "$(CURDIR)_$${NUMBER}/run.sh" ; \
		find testcases_bak -maxdepth 1 -type f -name "*.vh" | head -${TESTCASES_LIM} | xargs mv -t "$(CURDIR)_$${NUMBER}/testcases" ; \
	done
	@rm -rf testcases_bak

ncsim-testcases-copy:
	@make JOB="testcases-run" PROGPARAMS="ncsim -nontcglitch -licqueue testbench" PROG=ncsim testcases-copy

iveri-testcases-copy:
	@make JOB="testcases-run" PROGPARAMS="vvp -n testbench.vvp" PROG=iveri testcases-copy

vlsim-testcases-copy:
	@make JOB="testcases-run" PROGPARAMS="./obj_dir/ccproc_simulator" PROG=vlsim testcases-copy

vsim-testcases-copy:
	@make JOB="testcases-run" PROGPARAMS="vsim -c -vopt -do $(CCPROC_HOME)/bin/utils/vsim.do -onfinish exit" PROG=vsim testcases-copy

ncsim-torture-copy:
	@make JOB="RTPG_ENGINE=$(RTPG_ENGINE) RTPG_RUNS=$(RTPG_RUNS) torture-run" PROGPARAMS="ncsim -nontcglitch -licqueue testbench" PROG=ncsim testcases-copy

iveri-torture-copy:
	@make JOB="RTPG_ENGINE=$(RTPG_ENGINE) RTPG_RUNS=$(RTPG_RUNS) torture-run" PROGPARAMS="vvp -n testbench.vvp" PROG=iveri testcases-copy

vlsim-torture-copy:
	@make JOB="RTPG_ENGINE=$(RTPG_ENGINE) RTPG_RUNS=$(RTPG_RUNS) torture-run" PROGPARAMS="./obj_dir/ccproc_simulator" PROG=vlsim testcases-copy

vsim-torture-copy:
	@make JOB="RTPG_ENGINE=$(RTPG_ENGINE) RTPG_RUNS=$(RTPG_RUNS) torture-run" PROGPARAMS="vsim -c -vopt -do $(CCPROC_HOME)/bin/utils/vsim.do -onfinish exit" PROG=vsim testcases-copy

testcases-delete:
	@rm -rf testcases_bak
	@for ((NUMBER=1; NUMBER <= ${TESTCASES_JOBS}; ++NUMBER)) ; do \
		rm -rf "$(CURDIR)_$${NUMBER}" ; \
		echo "rm -rf $(CURDIR)_$${NUMBER}" ; \
	done
	@rm -rf ../.testcase_*.lock

ncsim-testcases-delete:
	@make testcases-delete

iveri-testcases-delete:
	@make testcases-delete

vlsim-testcases-delete:
	@make testcases-delete

vsim-testcases-delete:
	@make testcases-delete

ncsim-torture-delete:
	@make testcases-delete

iveri-torture-delete:
	@make testcases-delete

vlsim-torture-delete:
	@make testcases-delete

vsim-torture-delete:
	@make testcases-delete

common-run:
	@make clean
	@for ((NUMBER=1; NUMBER <= ${TESTCASES_JOBS}; ++NUMBER)) ; do \
		cd "$(CURDIR)_$${NUMBER}" ; \
		./run.sh ; \
	done

ncsim-testcases-run: ncsim-testcases-delete ncsim-testcases-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/testcasesWait.sh &

iveri-testcases-run: iveri-testcases-delete iveri-testcases-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/testcasesWait.sh &

vlsim-testcases-run: vlsim-testcases-delete vlsim-testcases-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/testcasesWait.sh &

vsim-testcases-run: vsim-testcases-delete vsim-testcases-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/testcasesWait.sh &

ncsim-torture-run: ncsim-torture-delete ncsim-torture-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/tortureWait.sh &

iveri-torture-run: iveri-torture-delete iveri-torture-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/tortureWait.sh &

vlsim-torture-run: vlsim-torture-delete vlsim-torture-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/tortureWait.sh &

vsim-torture-run: vsim-torture-delete vsim-torture-copy
	@make TESTCASES_JOBS=${TESTCASES_JOBS} common-run
	@$(CCPROC_HOME)/bin/utils/tortureWait.sh &

testcases-merge:
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)MERGING $(TESTCASES_JOBS) TESTCASES JOBS$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"
	@echo "" > logs/$(TEST_ARCH)_testcases_merged.log
	@for ((NUMBER=1; NUMBER <= ${TESTCASES_JOBS}; ++NUMBER)) ; do \
		cat $(CURDIR)_$${NUMBER}/logs/testcases_summary.log >> logs/$(TEST_ARCH)_testcases_merged.log ; \
	done
	@echo "" >> logs/$(TEST_ARCH)_testcases_merged.log
	@echo "----------------------------------------------------------------------------------" >> logs/$(TEST_ARCH)_testcases_merged.log
	@echo "-------------------- SUMMARY -----------------------------------------------------" >> logs/$(TEST_ARCH)_testcases_merged.log
	@echo "----------------------------------------------------------------------------------" >> logs/$(TEST_ARCH)_testcases_merged.log
	@echo "" >> logs/$(TEST_ARCH)_testcases_merged.log
	@echo "Date:                 $$(date)" >> logs/$(TEST_ARCH)_testcases_merged.log
	@$(CCPROC_HOME)/bin/utils/logParser.sh logs/$(TEST_ARCH)_testcases_merged.log
	@echo "" >> logs/$(TEST_ARCH)_testcases_merged.log

ncsim-testcases-merge:
	@make testcases-merge

iveri-testcases-merge:
	@make testcases-merge

vlsim-testcases-merge:
	@make testcases-merge

vsim-testcases-merge:
	@make testcases-merge

torture-merge:
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)MERGING $(TESTCASES_JOBS) TORTURE JOBS$(ANSI_RESET)\n"
	@echo -ne "$(ANSI_COLOR)---------------------------------------------------------------$(ANSI_RESET)\n"
	@echo "" > logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@for ((NUMBER=1; NUMBER <= ${TESTCASES_JOBS}; ++NUMBER)) ; do \
		cat $(CURDIR)_$${NUMBER}/logs/testcases_summary.log >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log ; \
	done
	@echo "" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo "----------------------------------------------------------------------------------" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo "-------------------- SUMMARY -----------------------------------------------------" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo "----------------------------------------------------------------------------------" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo "" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo "Date:                         $$(date)" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo -ne "Extecuted testcases:          " >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@grep 'TESTCASE:' logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log | wc -l >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo "Extecuted runs per testcases: $(RTPG_RUNS)" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@echo "" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log
	@if [[ `grep -oP "FAILURES DETECTED" "logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log"` ]] ; then \
		echo FAILURES DETECTED >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log ;\
	else \
		echo TESTS PASSED >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log ;\
	fi
	@echo "" >> logs/$(TEST_ARCH)_torture_$(RTPG_ENGINE)_merged.log

ncsim-torture-merge:
	@make torture-merge

iveri-torture-merge:
	@make torture-merge

vlsim-torture-merge:
	@make torture-merge

help-verif:
	@echo ""
	@echo "Processor verification using direct tests:"
	@echo "  iveri-testcases-run       - run verification suite using Icarus Verilog"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 iveri-testcases-run'"
	@echo "  vlsim-testcases-run       - run verification suite using Verilator (only with simulator design)"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 vlsim-testcases-run'"
	@echo "  ncsim-testcases-run       - run verification suite using Cadence Incisive Enterprise Simulator"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 ncsim-testcases-run'"
	@echo "  vsim-testcases-run        - run verification suite using Questa Advanced Simulator"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 vsim-testcases-run'"
	@echo "  iveri-testcases-merge     - manually merge verification results"
	@echo "  vlsim-testcases-merge     - manually merge verification results"
	@echo "  ncsim-testcases-merge     - manually merge verification results"
	@echo "  vsim-testcases-merge      - manually merge verification results"
	@echo "  iveri-testcases-delete    - manually delete testcases folders"
	@echo "  vlsim-testcases-delete    - manually delete testcases folders"
	@echo "  ncsim-testcases-delete    - manually delete testcases folders"
	@echo "  vsim-testcases-delete     - manually delete testcases folders"
	@echo ""
	@echo "Processor verification using random tests:"
	@echo "  iveri-torture-run         - run verification suite using Icarus Verilog"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 RTPG_ENGINE=csmith RTPG_RUNS=1000 iveri-torture-run'"
	@echo "  vlsim-torture-run         - run verification suite using Verilator (only with simulator design)"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 RTPG_ENGINE=csmith RTPG_RUNS=1000 vlsim-torture-run'"
	@echo "  ncsim-torture-run         - run verification suite using Cadence Incisive Enterprise Simulator"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 RTPG_ENGINE=csmith RTPG_RUNS=1000 ncsim-torture-run'"
	@echo "  vsim-torture-run          - run verification suite using Questa Advanced Simulator"
	@echo "                                e.g. 'make TESTCASES_JOBS=12 RTPG_ENGINE=csmith RTPG_RUNS=1000 vsim-torture-run'"
	@echo "  iveri-torture-merge       - manually merge verification results"
	@echo "  vlsim-torture-merge       - manually merge verification results"
	@echo "  ncsim-torture-merge       - manually merge verification results"
	@echo "  vsim-torture-merge        - manually merge verification results"
	@echo "  iveri-torture-delete      - manually delete testcases folders"
	@echo "  vlsim-torture-delete      - manually delete testcases folders"
	@echo "  ncsim-torture-delete      - manually delete testcases folders"
	@echo "  vsim-torture-delete       - manually delete testcases folders"
	@echo ""
