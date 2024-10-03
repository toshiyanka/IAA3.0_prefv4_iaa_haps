#-*- makefile -*--------------------------------------------------------------
# Default test make -- Include the ace_test_base.mak
# #-----------------------------------------------------------------------------
#
# # Need to set -I or --include_dir on gmake command-line to find 
include $(BASE_MAKE_FILE)
#
#
# # file extensions for verilog include files.  Project may want to override this list
 VLOG_INCLUDE_EXT                = vic vh svh v sv inc vm

ifeq ($(RTL_COMPILER),vcs)
  # Create VCS args for the VCS command  
  VCS_ARGS       := $(TOP) $(SLAVE)  
  VCS_ARGS_FILE  := $(SCOPE)_vcs_args
  PREV_VCS_ARGS  := $(strip $(shell cat $(VCS_ARGS_FILE)) 2>/dev/null)
  NEW_VCS_ARGS   := $(strip $(VCS_OPTS)) $(strip $(VCS_ARGS)) $(strip $(ELAB_OPTS))
  
  # Create SIM args for the simulation command
  SIM_ARGS      := 
endif

ifeq ($(RTL_COMPILER),mti)
    # Create SIM args for simulation command
    SIM_ARGS   := $(HDL_TEST_LIB).tb_$(NETWORK) -L $(HDL_TEST_LIB) +NETWORK=$(NETWORK_DIR)/$(NETWORK).xml
endif
PREV_SIM_ARGS   := $(strip $(shell cat $(SIM_ARGS_FILE) 2>/dev/null))
NEW_SIM_ARGS    := $(strip $(SIM_ARGS))

#--------------------------------------------
# Compile the verilog portion of the test
#--------------------------------------------
$(HDL_TEST): $(WORKDIR)/$(HDL_TEST_LIB) $(VLOG_SRC) $(OTHER_VLOG_FILES) $(VLOG_INC_FILES) $(VLOG_LIB_DEPS)
ifeq ($(RTL_COMPILER),vcs)
	rm -rf $(HDL_TEST_LIB)/*
endif
	$(IGNORE_CHAR)$(VLOG_TOOL) $(VLOG_LIB_KW) $(HDL_TEST_LIB) $(OTHER_VLOG_FILES) $(VLOG_SRC) tb_$(NETWORK).sv $(VLOG_ARGS) $(VLOG_OPTS) 
	@echo "$(HDL_TEST_LIB).$(TEST_MODULE)" > $@

#	$(IGNORE_CHAR)$(VLOG_TOOL) $(VLOG_LIB_KW) $(HDL_TEST_LIB) $(OTHER_VLOG_FILES) *.sv $(VLOG_ARGS) $(VLOG_OPTS) 


#--------------------------------------------
# Each makefile that includes this one should
# create a target like this
#
#--------------------------------------------
$(SIM_ARGS_FILE) : $(HDL_TEST) $(VCS_EXEC)
	@echo Creating SIM_ARGS_FILE
	echo $(NEW_SIM_ARGS) > $(SIM_ARGS_FILE)

#------------------------------------------
# display some internal variables for debug
#------------------------------------------
.PHONY: debug
debug: iosf_sbc_config all

.PHONY: iosf_sbc_config
p2config: config
	@echo --------------------------------------------------
	@echo NETWORK:      $(NETWORK)
	@echo NETWORK_DIR:  $(NETWORK_DIR)
	@echo --------------------------------------------------