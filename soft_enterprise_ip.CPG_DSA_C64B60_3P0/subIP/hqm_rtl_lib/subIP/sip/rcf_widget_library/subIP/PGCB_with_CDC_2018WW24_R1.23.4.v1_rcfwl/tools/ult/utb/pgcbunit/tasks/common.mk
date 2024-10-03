MAKEFLAGS += -rR --no-print-directory

DUTNAME       := pgcbunit
TASKNAME      := $(shell basename $$PWD)
TASKDIR       := $(shell pwd)
INPUTS        := $(TASKNAME).tcl

DUT_TCL_DIR   := ../../jg_tb/bin

OUTDIR        := ../../jg_res/$(TASKNAME)
JGRUN_LOG     := jgrun.log
OUTPUTS       := $(OUTDIR)/$(TASKNAME).out
JG_CMD        := $(JG_HOME)/bin/jg -allow_unsupported_OS

UTB_XPROP_EN  ?= 0

include jg_run_mode.mk 

.PHONY: all
all: run

SWITCHES := -batch
JGTASKELABSETUP := JG_TASK_ELAB_TCL=$(TASKDIR)/$(TASKNAME)_elab.tcl; export JG_TASK_ELAB_TCL; USE_TASK_ELAB_CMD=1; export USE_TASK_ELAB_CMD; export UTB_XPROP_EN 

VB = @
ifneq ($(QUIET), 1)
    VB =
endif

ifeq ($(GUI), 1)
    #$(info GUI selected)
    SWITCHES :=
endif

.PHONY : build
build : $(OUTPUTS)
$(OUTPUTS) : $(INPUTS)
	$(VB)test -f $(OUTDIR)/$(TASKNAME).pass && rm -f $(OUTDIR)/$(TASKNAME).pass || true
	$(VB)test -f $(OUTDIR)/$(TASKNAME).fail && rm -f $(OUTDIR)/$(TASKNAME).fail || true
	$(VB)test -f $(OUTPUTS) && rm -f $(OUTPUTS) || true
	$(VB)mkdir -p $(OUTDIR) && (cd $(OUTDIR) && $(JGTASKELABSETUP) && $(JG_CMD) $(SWITCHES) $(DUT_TCL_DIR)/$(DUTNAME).tcl -tcl $(TASKDIR)/$(TASKNAME).tcl 2>&1 > $(JGRUN_LOG))
	$(VB)test -f $(OUTPUTS) || echo "ERROR: please check jgrun.log" > $(OUTPUTS)

.PHONY : run
run : $(OUTPUTS)
	$(VB)test -f $(OUTPUTS) || { echo "Could not find the JG run output, please check $(OUTDIR)/jgrun.log for errors." >&2; false; }
	$(VB)if [ $$(grep -c ERROR: $(OUTPUTS)) -ne 0 ]; then \
		echo Task $(TASKNAME) Status : FAIL; \
		ln -sf $(OUTDIR)/$(TASKNAME).out $(OUTDIR)/$(TASKNAME).fail; \
		rm -f $(OUTDIR)/$(TASKNAME).pass; \
		false; \
	else \
		echo Task $(TASKNAME) Status : PASS; \
		ln -sf $(OUTDIR)/$(TASKNAME).out $(OUTDIR)/$(TASKNAME).pass; \
		rm -f $(OUTDIR)/$(TASKNAME).fail; \
		true; \
	fi

.PHONY : clean
clean:
	$(VB)rm -rf $(OUTDIR)

.PHONY : run_jg
run_jg:
	$(VB)cd $(DUT_TCL_DIR); $(JG_CMD) $(DUTNAME).tcl &
