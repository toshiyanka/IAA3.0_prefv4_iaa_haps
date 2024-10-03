MAKEFLAGS += -rR --no-print-directory

TASKS := $(shell find . -maxdepth 1 -mindepth 1 -type d \( -name fsm -prune -o -name sps -prune -o -name xprop -o -print \) | while read d; do test -f ./$$d/$${d}.tcl && echo $$d; done)
#$(info Tasks: $(TASKS))
CLEAN_TASKS := $(addprefix clean_, $(TASKS))

DUT_TCL_DIR := ../jg_tb/bin
DUTNAME := ClockDomainController
JG_LAUNCH_CMD := $(JG_HOME)/bin/jg

VB = @
ifneq ($(QUIET), 1)
    VB =
endif

.PHONY: all $(TASKS) clean $(CLEAN_TASKS)

all: $(TASKS)
$(TASKS):
	$(VB)$(MAKE) -C $@

clean: $(CLEAN_TASKS)
$(CLEAN_TASKS):
	$(VB)$(MAKE) -C $(subst clean_,,$@) clean

.PHONY : run_jg
run_jg:
	$(VB)cd $(DUT_TCL_DIR) && $(JG_LAUNCH_CMD) -proj . $(DUTNAME).tcl &

# Remind the user of the available options.
help:
	 'Type "make" or "make all" to run all Tasks.'
	 'Type "make <Taskname>" or cd to <Taskname> and run "make" to run that specific Task.'
	 'Type "make clean" to remove all generated files (Task results, etc.)'
	 'For any of the above, supply "-j <n>" where n is the number of desired parallel jobs to execute.'

