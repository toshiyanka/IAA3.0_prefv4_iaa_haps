MAKEFLAGS += -rR --no-print-directory

TESTS := $(shell find . -mindepth 1 -maxdepth 1 -type d \( -name elab_test -prune -o -print \) | while read d; do test -f ./$$d/$${d}.svh && echo $$d; done)
#$(info Tests: $(TESTS))
CLEAN_TESTS := $(addprefix clean_, $(TESTS))

.PHONY: all $(TESTS) clean $(CLEAN_TESTS)

VB = @
ifneq ($(QUIET), 1)
    VB =
endif

all: $(TESTS)
$(TESTS):
	$(VB)$(MAKE) -C $@

clean: $(CLEAN_TESTS)
$(CLEAN_TESTS):
	$(VB)$(MAKE) -C $(subst clean_,,$@) clean

.PHONY : run_jg
run_jg:
	$(VB)cd ../jg_tb/bin; jg -allow_unsupported_OS pgcbunit.tcl &

.PHONY : run_urg
run_urg:
	$(VB)cd ../sim_res && find . -name "*.vdb" -print | grep -v merged > vdb_list && urg -lca -f vdb_list -dbname merged -metric +line+fsm+cond+tgl+branch+assert && cd urgReport && firefox dashboard.html

# Remind the user of the available options.
help:
	 'Type "make" or "make all" to run all tests.'
	 'Type "make <testname>" or cd to <testname>/ and run "make" to run that specific test.'
	 'Type "make clean" to remove all generated files (test results, etc.)'
	 'For any of the above, supply "-j <n>" where n is the number of desired parallel jobs to execute.'

