#!make

### Variables from top-level Makefile
# MAKEFILE
# DUT
# MODEL
# BUILD_DIRNAME
# BUILD_DIR

FLOW      := haps



# Benefit of this ifeq block:
# - It stops recursive inclusion of user defined configuration.
# - Makefile.ENV updates PATH, LD_LIBRARY_PATH etc variable.
#   Recursive inclusion might affect these variables.
ifeq ($(strip $(__MAKE_ENV_INCLUDED)),)

# include user configuration makefile
#================================================
include $(BUILD_DIR)/Makefile.cfg

#Use CTH_EMUROOT to point DVB_ROOT to different value.
#CTH_EMUROOT can be set in tool.cth
#Look if user set CTH_EMUROOT in tool.cth using cth_query as below.
CTH_EMUROOT ?= $(shell env BUILD_DIRNAME=$(BUILD_DIRNAME) cth_query -tool $(FLOW) envs CTH_EMUROOT -resolve)
ifneq ($(strip $(CTH_EMUROOT)),)
ifeq ($(wildcard $(CTH_EMUROOT)/../dvb),)
$(error Please set "CTH_EMUROOT" to a valid value in verif/emu/$(FLOW)/tool.cth. Currently set to: $(CTH_EMUROOT), which does not contain valid dvb path)
else
DVB_ROOT := $(CTH_EMUROOT)
endif
else
DVB_ROOT := $(shell env BUILD_DIRNAME=$(BUILD_DIRNAME) cth_query -tool $(FLOW) envs DVB_ROOT -resolve)
endif

ifeq ($(strip $(DVB_ROOT)),)
$(error Please set "DVB_ROOT" in $(BUILD_DIR)/Makefile file.)
endif

FLOW_ROOT := $(DVB_ROOT)/makefiles/$(FLOW)

# include flow env-setup makefile
# - This Makefile.ENV sets __MAKE_ENV_INCLUDED
#================================================
include $(FLOW_ROOT)/Makefile.ENV

# include user defined configuration here, if any
#================================================
export FPGA_ROOT = $(WORKAREA)/verif/fpga/haps/fpga

endif

# To disable a variable coming from lite-infra, empty it out here
#================================================================
# JEM         :=
# SIMICS_HOME :=

# include flow makefile
#===============================================
include $(FLOW_ROOT)/Makefile.$(FLOW)

export

# Build a complete haps model in TARGET_DIR
#===============================================
ifeq ($(strip $(UNIFIED_COMPILE)),)
$(SHADOW_DIR)/pre_instrument: $(SHADOW_DIR)/gen_pfl_lmf
else
$(SHADOW_DIR)/pre_instrument : $(SHADOW_DIR)/gen_analyze_make $(SHADOW_DIR)/dw_gen $(SHADOW_DIR)/gen_elab_src
endif

.DEFAULT_GOAL := all
.PHONY: all
ifeq ($(strip $(UNIFIED_COMPILE)),)
#all: $(SHADOW_DIR)/prerequisite   $(SHADOW_DIR)/gen_dv_flist \
	 $(SHADOW_DIR)/pre_instrument $(SHADOW_DIR)/compile        $(SHADOW_DIR)/pre_partition   \
	 $(SHADOW_DIR)/partition      $(SHADOW_DIR)/system_route   $(SHADOW_DIR)/system_generate \
	 vivado        $(SHADOW_DIR)/post_pnr
all: $(SHADOW_DIR)/post_pnr
else
#all: $(SHADOW_DIR)/prerequisite   $(SHADOW_DIR)/gen_dv_flist \
	 $(SHADOW_DIR)/compile        $(SHADOW_DIR)/pre_partition   \
	 $(SHADOW_DIR)/partition      $(SHADOW_DIR)/system_route   $(SHADOW_DIR)/system_generate \
	 vivado        $(SHADOW_DIR)/post_pnr
all: $(SHADOW_DIR)/post_pnr
endif

