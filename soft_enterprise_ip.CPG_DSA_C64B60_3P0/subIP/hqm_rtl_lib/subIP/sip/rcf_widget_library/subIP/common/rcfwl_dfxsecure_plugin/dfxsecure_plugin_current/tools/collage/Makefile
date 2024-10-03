ifeq ($(COLLAGE_BATCH_MODE),1) 
  CB = $(CORE_TOOLS_DIR)/$(CORE_TOOLS_VER)/bin/coreBuilder -shell -x 'source $(COLLAGE_ROOT)/core/common/tcl/collage_init.tcl'
  CA = $(CORE_TOOLS_DIR)/$(CORE_TOOLS_VER)/bin/coreAssembler -shell -x 'source $(COLLAGE_ROOT)/core/common/tcl/collage_init.tcl'
else 
  CB = $(CORE_TOOLS_DIR)/$(CORE_TOOLS_VER)/bin/coreBuilder -x 'source $(COLLAGE_ROOT)/core/common/tcl/collage_init.tcl'
  CA = $(CORE_TOOLS_DIR)/$(CORE_TOOLS_VER)/bin/coreAssembler -x 'source $(COLLAGE_ROOT)/core/common/tcl/collage_init.tcl'
endif

none:
	echo "select make target"

all:
	cd $(COLLAGE_WORK); \rm -rf IpBuilder_rcfwl_dfxsecure_plugin; \rm -rf work; $(CB)  -f $(IP_ROOT)/tools/collage/build/builder.rcfwl_dfxsecure_plugin.tcl
