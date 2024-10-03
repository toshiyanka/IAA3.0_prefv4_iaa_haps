MAKEFLAGS += -rR --no-print-directory
DUTNAME       := ClockDomainController

DC_ROOT ?= /p/com/eda/synopsys/designcompiler
DC_VER  ?= K-2015.06-SP3

DC_LC_FILE ?= 26586@fmylic7000.fm.intel.com:26586@fmylic7002.fm.intel.com

DC_MANPATH  := $(DC_ROOT)/$(DC_VER)/doc/syn/man:$(DC_ROOT)/$(DC_VER)/doc/psyn/man:$(DC_ROOT)/$(DC_VER)/doc/snps_tcl/man
MANPATH     := $(DC_MANPATH):$(MANPATH)
DC_BINPATH  := $(DC_ROOT)/$(DC_VER)/suse64/syn/bin:$(DC_ROOT)/$(DC_VER)/linux/syn/bin

ifeq ($(GUI), 1)
    DC_RUNMODE := -gui
endif

VB = @
ifneq ($(QUIET), 1)
    VB =
endif

.PHONY : run_dc
run_dc :
	$(VB)export MANPATH=$(DC_MANPATH):$(MANPATH) && export PATH=$(DC_BINPATH):$(PATH) && export SNPSLMD_LICENSE_FILE=$(DC_LC_FILE) && dc_shell -f $(DUTNAME).tcl -output_log_file $(DUTNAME).log $(DC_RUNMODE) $(DC_OPTS)

help :
	$(VB)echo make [GUI=1] [DC_OPTS="Any Synopsis DC options"] [DC_ROOT=<DC install path>] [DC_VER=<DC version>] [DC_LC_FILE=<license server host>]

