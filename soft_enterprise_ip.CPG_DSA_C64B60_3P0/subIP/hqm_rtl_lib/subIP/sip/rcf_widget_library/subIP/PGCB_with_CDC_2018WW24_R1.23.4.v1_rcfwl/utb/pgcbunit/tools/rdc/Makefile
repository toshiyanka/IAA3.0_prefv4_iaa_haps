MAKEFLAGS           += -rR --no-print-directory
DUTNAME             := pgcbunit

SPYG_VER            ?= 5.6.0.4
SPYG_INSTALL        ?= /p/com/eda/atrenta/spyglass
SPYG_HOME           ?= $(SPYG_INSTALL)/$(SPYG_VER)/SPYGLASS_HOME
LM_PROJECT          := EIG_CSME

SET_SPGY_PATH       := export PATH=$(SPYG_HOME)/bin:$(PATH)
SET_LM_LIC          := export LM_LICENSE_FILE=$(LM_LICENSE_FILE):26586@synopsys21p.elic.intel.com:26586@synopsys35p.elic.intel.com:26586@synopsys08p.elic.intel.com:26586@synopsys04p.elic.intel.com:26586@synopsys36p.elic.intel.com:26586@synopsys05p.elic.intel.com
SET_LDLIB_PATH      := export LD_LIBRARY_PATH=$(SPYG_HOME)/SPYGLASS_HOME/lib:$(SPYG_HOME):$(LD_LIBRARY_PATH)
SET_SPY_PLAT        := export SPYPLAT=Linux2
SET_SPYGLASS_HOME   := export SPYGLASS_HOME=$(SPYG_HOME)
SET_ATRENTA_LF      := export ATRENTA_LICENSE_FILE=7595@fmylic7010.fm.intel.com:7595@atrenta01p.elic.intel.com:7595@atrenta05p.elic.intel.com:$(ATRENTA_LICENSE_FILE)
SET_SH_LIB_PATH     := export SH_LIB_PATH=$(SPYG_HOME)/lib:$(SH_LIB_PATH)
SET_LM_PROJECT      := export LM_PROJECT=$(LM_PROJECT)
SETUP_SPG_RDC       := $(SET_SPGY_PATH) && $(SET_LM_LIC) && $(SET_LDLIB_PATH) && $(SET_SPY_PLAT) && $(SET_SPYGLASS_HOME) && $(SET_ATRENTA_LF) && $(SET_SH_LIB_PATH) $(SET_LM_PROJECT) 

#source /p/com/env/psetup/prod/bin/setupTool spyglass 5.5.1.1
#source /nfs/site/eda/group/cse/setups/atrenta/atrenta.lic
#setenv ATRENTA_LICENSE_FILE 7595@fmylic7010.fm.intel.com:$ATRENTA_LICENSE_FILE
#setenv LM_PROJECT EIG_USB
#SETUP_SPYG         := tsetup spyglass $(SPYG_VER)
#TSETUP_ALIAS       := alias tsetup 'source /p/com/env/psetup/prod/bin/setupTool'
#SRC_LIC            := source /nfs/site/eda/group/cse/setups/atrenta/atrenta.lic

SPYG_SWITCHES       ?=
DESIGNREAD_SWITCHES ?=
SETUP_SWITCHES      ?=
SETUPCHECK_SWITCHES ?=
RDCRUN_SWITCHES     ?=

SPYGCMD             := spyglass

SPYG_LOG_BASE       := spyglass
SPYG_LOG_FILE       := $(SPYG_LOG_BASE).log 
SPYG_LOG_DIRBASE    := $(DUTNAME)/consolidated_reports/$(DUTNAME)

DESIGNREAD_LOGDIR   := $(SPYG_LOG_DIRBASE)_Design_Read
DESIGNREAD_LOG      := $(DESIGNREAD_LOGDIR)/$(SPYG_LOG_FILE)
DESIGNREAD_STATUS   := $(DESIGNREAD_LOGDIR)/$(SPYG_LOG_BASE).pass

SETUP_LOGDIR        := $(SPYG_LOG_DIRBASE)_cdc_cdc_setup
SETUP_LOG           := $(SETUP_LOGDIR)/$(SPYG_LOG_FILE)
SETUP_STATUS        := $(SETUP_LOGDIR)/$(SPYG_LOG_BASE).pass

SETUPCHECK_LOGDIR   := $(SPYG_LOG_DIRBASE)_cdc_cdc_setup_check
SETUPCHECK_LOG      := $(SETUPCHECK_LOGDIR)/$(SPYG_LOG_FILE)
SETUPCHECK_STATUS   := $(SETUPCHECK_LOGDIR)/$(SPYG_LOG_BASE).pass

RDCRUN_LOGDIR       := $(SPYG_LOG_DIRBASE)_cdc_cdc_verify_struct
RDCRUN_LOG          := $(RDCRUN_LOGDIR)/$(SPYG_LOG_FILE)
RDCRUN_STATUS       := $(RDCRUN_LOGDIR)/$(SPYG_LOG_BASE).pass

SPYG_RUNMODE := -batch
ifeq ($(GUI), 1)
        SPYG_RUNMODE := -run
endif

VB = @
ifneq ($(QUIET), 1)
    VB =
endif

.PHONY: all
all: $(RDCRUN_STATUS)

.NOTPARALLEL:

.PHONY: elab
elab: $(DESIGNREAD_STATUS)
$(DESIGNREAD_STATUS): $(DUTNAME).prj $(DUTNAME).f Makefile
	$(VB)$(SETUP_SPG_RDC) && $(SPYGCMD) -project $(DUTNAME).prj -designread $(SPYG_RUNMODE) $(SPYG_SWITCHES) $(DESIGNREAD_SWITCHES)
	cd $(DESIGNREAD_LOGDIR) && grep -c "SpyGlass Exit Code 0" $(SPYG_LOG_FILE) && ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).pass || ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).fail 

.PHONY : setup
setup: $(SETUP_STATUS)
$(SETUP_STATUS): $(DUTNAME)_clocks.sgdc $(DUTNAME)_resets.sgdc 
	$(VB)$(SETUP_SPG_RDC) && $(SPYGCMD) -project $(DUTNAME).prj  -goal cdc/cdc_setup $(SPYG_RUNMODE) $(SPYG_SWITCHES) $(SETUP_SWITCHES)
	test -s $(DUTNAME)_resets.sgdc || cp $(DUTNAME)/$(DUTNAME)/cdc/cdc_setup/spyglass_reports/clock-reset/autoresets.sgdc $(DUTNAME)_resets.sgdc 
	test -s $(DUTNAME)_clocks.sgdc || cp $(DUTNAME)/$(DUTNAME)/cdc/cdc_setup/spyglass_reports/clock-reset/autoclocks.sgdc $(DUTNAME)_clocks.sgdc 
	cat $(DUTNAME)/$(DUTNAME)/cdc/cdc_setup/spyglass_reports/clock-reset/reset_sig.csv | grep PRIMARY | cut -d, -f 1 | cut -d. -f2 | sort -u > RESETS_IOPIN
	test -e $(DUTNAME)_ResetMatrix.csv || (for i in $$(cat RESETS_IOPIN); do echo -n ",$${i}"; done; echo; for i in $$(cat RESETS_IOPIN); do echo -n "$${i}"; for c in $$(cat RESETS_IOPIN); do echo -n ", "; done; echo; done) > $(DUTNAME)_ResetMatrix.csv 
	cd $(SETUP_LOGDIR) && grep -c "SpyGlass Exit Code 0" $(SPYG_LOG_FILE) && ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).pass || ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).fail 

.PHONY : setupcheck
setupcheck: $(SETUPCHECK_STATUS)
$(SETUPCHECK_STATUS): 
	$(VB)$(SETUP_SPG_RDC) && $(SPYGCMD) -project $(DUTNAME).prj  -goal cdc/cdc_setup_check $(SPYG_RUNMODE) $(SPYG_SWITCHES) $(SETUPCHECK_SWITCHES)
	cd $(SETUPCHECK_LOGDIR) && grep -c "SpyGlass Exit Code 0" $(SPYG_LOG_FILE) && ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).pass || ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).fail 

.PHONY : runrdc
runrdc : $(RDCRUN_STATUS)
$(RDCRUN_STATUS): 
	$(VB)$(SETUP_SPG_RDC) && $(SPYGCMD) -project $(DUTNAME).prj  -goal cdc/cdc_verify_struct $(SPYG_RUNMODE) $(SPYG_SWITCHES) $(RDCRUN_SWITCHES)
	cd $(RDCRUN_LOGDIR) && grep -c "SpyGlass Exit Code 0" $(SPYG_LOG_FILE) && ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).pass || ln -s -f $(SPYG_LOG_FILE) $(SPYG_LOG_BASE).fail 

.PHONY : clean
clean : clean_all
clean_all :
	rm -f $(DESIGNREAD_LOGDIR)/$(SPYG_LOG_BASE).* $(SETUP_LOGDIR)/$(SPYG_LOG_BASE).* $(SETUPCHECK_LOGDIR)/$(SPYG_LOG_BASE).* $(RDCRUN_LOGDIR)/$(SPYG_LOG_BASE).*

clean_deasignread :
	rm -f $(DESIGNREAD_LOGDIR)/$(SPYG_LOG_BASE).*

clean_setup :
	rm -f $(SETUP_LOGDIR)/$(SPYG_LOG_BASE).*

clean_setupcheck :
	rm -f $(SETUPCHECK_LOGDIR)/$(SPYG_LOG_BASE).*

clean_rdcrun :
	rm -f $(RDCRUN_LOGDIR)/$(SPYG_LOG_BASE).*

clean_reset :
	rm -f RESETS_IOPIN

clean_reset_matrix :
	rm -f $(DUTNAME)_ResetMatrix.csv

clean_result :
	rm -rf $(DUTNAME)

help :
	@echo make [GUI=1] [all] [elab] [setup] [setupcheck] [runrdc] [clean] [clean_all] [clean_designread] [clean_setup] [clean_setupcheck] [clean_rdcrun]

