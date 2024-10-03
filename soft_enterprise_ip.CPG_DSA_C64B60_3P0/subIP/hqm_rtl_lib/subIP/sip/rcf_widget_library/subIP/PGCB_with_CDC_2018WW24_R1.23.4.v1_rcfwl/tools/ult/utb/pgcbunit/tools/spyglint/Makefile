MAKEFLAGS += -rR --no-print-directory
DUTNAME       := pgcbunit

SPYG_VER ?= 5.5.0.2
ATRENTA_LF ?= 7595@plxs0405.pdx.intel.com:7595@fmylic42.fm.intel.com
SPYG_INSTALL_PATH ?= /p/com/eda/atrenta/spyglass/$(SPYG_VER)/SPYGLASS_HOME/bin

SPYG_RUN_GOAL := -run
ifeq ($(SPYG_RUNMODE), -batch)
    SPYG_RUN_GOAL :=
endif

VB = @
ifneq ($(QUIET), 1)
    VB =
endif

.PHONY : run_spyglint
run_spyglint :
	$(VB)export ATRENTA_LICENSE_FILE=$(ATRENTA_LF) && export PATH=$(SPYG_INSTALL_PATH):$(PATH) && spyglass -project $(DUTNAME)_spyglint.prj $(SPYG_RUNMODE) -goals "lint/lint_rtl" $(SPYG_RUN_GOAL) $(SPY_OPTS)

help :
	 make [SPYG_RUNMODE=-batch] [SPYG_VER=<Spyg version>] [ATRENTA_LF=<Lic server>] [SPYG_INSTALL_PATH=<Install path>] [SPY_OPTS=<Any spyg option>]

