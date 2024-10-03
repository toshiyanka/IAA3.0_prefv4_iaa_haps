MAKEFLAGS += -rR --no-print-directory
DUTNAME         := ClockDomainController

LINTRA_ROOT     ?= /p/hdk/rtl/cad/x86-64_linux30/dt
LINTRA_INSTALL  := $(LINTRA_ROOT)/lintra

LINTRA_VER      ?= 15.3p15_shOpt64
LINTRA_PATH     := $(LINTRA_INSTALL)/$(LINTRA_VER)

LINTRARULEVER   ?= 1.07.01.15_3
LINTRARULES     := $(LINTRA_ROOT)/../intel/lintra-rules/$(LINTRARULEVER)
LINTRA_CFG_FILE ?= $(LINTRARULES)/cfg/LintraSoCConfig_WF.xml

VB = @
ifneq ($(QUIET), 1)
    VB =
endif

.PHONY : run_lintra
run_lintra:
	$(VB)export CAD_ROOT=$(LINTRA_ROOT) && export LINTRA=$(LINTRA_PATH) && $(LINTRA_PATH)/bin/lintra -top $(DUTNAME) -cfg $(LINTRA_CFG_FILE) -lira -f ../../dut_inf/list/$(DUTNAME).f $(LINTRA_SWITCHES)

.PHONY : run_lintra_gui
run_lintra_gui:
	$(VB)export CAD_ROOT=$(LINTRA_ROOT) && export LINTRA=$(LINTRA_PATH) && $(LINTRA_PATH)/bin/lintra -gui -ov $(DUTNAME)_violations.xml

help :
	@echo "make [run_lintra] [run_lintra_gui] [LINTRA_ROOT=<Lintra install path>] [LINTRA_VER=<version>] [LINTRARULEVER=<rule version>] [LINTRA_CFG_FILE=<Config file>] [LINTRA_SWITCHES=<switches>]"

