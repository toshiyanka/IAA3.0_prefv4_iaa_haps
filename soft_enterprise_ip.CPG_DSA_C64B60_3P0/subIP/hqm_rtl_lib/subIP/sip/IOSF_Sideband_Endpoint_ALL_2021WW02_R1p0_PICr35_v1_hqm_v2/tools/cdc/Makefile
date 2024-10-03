ZEROIN_OPT   = +0in_debug+nl_prop_const_thru_reg+nl_path_split+-blackbox_unresolved_modules
PERF_OPT     = +cdc_optimize_perf2+cdc_optimize_perf3+hcdc_check_hier+hcdc_suggest_hb+cdc_check_boundary_threshold
CDC_OPT      = +cdc_support_multi_through+allow_diff_flags+cdc_vclk_for_hier_cdc
VLOG_OPT     = -sv -oldsv -skipsynthoffregion -mfcu -mixedansiports -permissive -convertallparams  -nopsl -suppress 7033 -suppress 3838 -suppress 2583
VLOG_DEFINES = +define+SVA_OFF
#######################################################################
BLOCK_NAME     := sbendpoint
TOP_BLOCK_NAME := $(BLOCK_NAME)
RTL_LIST       := rtl.list
DIRS           := $(shell find . -mindepth 1 -maxdepth 1 -type d -printf "%f ")
FILE_LIST      := $(shell awk '$$0!~/[+]/{printf("%s ",$$0);}' $(BLOCK_NAME)/$(RTL_LIST))
CTRL_FILE_V    := $(TOP_BLOCK_NAME)_cdc_ctrl.v
BLOCK_LIB_DIR  := $(TOP_BLOCK_NAME)_cdc_lib
TCL_CTRL_DIR   := tcl_ctrl_files
CTRL_FILE_TCL  := $(TCL_CTRL_DIR)/$(CTRL_FILE_V).tcl
DBGF_FILE_TCL  := $(TCL_CTRL_DIR)/debug_flags.v.tcl
RESULTS_DIR    := $(TOP_BLOCK_NAME)_cdc_results
CDCDB          := $(TOP_BLOCK_NAME)_cdc_results/cdc.db
PARAM_DEFINES  :=

# Endpoint Specific Parameters

# Process Specific Values
PROCESS       := UNDEFINED
#SPT uses 1271
#CHV uses 1273
LIBTYPE       := UNDEFINED
#SPT uses B05.8
#CHV uses D04
LIBTYPE_STRIP := UNDEFINED
#SPT uses B05
#CHV uses D04
PROCVER       := UNDEFINED
#SPT uses 8.2.0
#CHV uses 0.8.0
VTTYPE        := UNDEFINED
#SPT uses LN/UN
#CHV uses WN
CUSTNAME      := default
#should always use default, SPT library does not have this though


ifeq "$(PROCESS)" "1273"
ifeq "$(LIBTYPE)" "UNDEFINED"
LIBTYPE       := d04
LIBTYPE_STRIP := d04
endif
ifeq "$(PROCVER)" "UNDEFINED"
PROCVER       := 0.8.0
endif
ifeq "$(VTTYPE)" "UNDEFINED"
VTTYPE        := wn
endif
endif

ifeq "$(PROCESS)" "1271"
ifeq "$(LIBTYPE)" "UNDEFINED"
LIBTYPE       := b12.4
LIBTYPE_STRIP := b12
endif
ifeq "$(PROCVER)" "UNDEFINED"
PROCVER       := 8.2.0
endif
ifeq "$(VTTYPE)" "UNDEFINED"
VTTYPE        := un
endif
endif

ifneq "$(HIER)" "UNDEFINED"
HIEREN := 
else
HIEREN := "-hier"
endif


ifneq "$(PROCESS)" "UNDEFINED"
VLOG_DEFINES  := $(VLOG_DEFINES)+DC+SYNTH+SIPINT_$(PROCESS)
endif

ifneq "$(PROCESS)" "UNDEFINED"
VLOG_LIBS := -v /p/kits/intel/p$(PROCESS)/p$(PROCESS)_$(PROCVER)/stdcells/$(LIBTYPE)/$(CUSTNAME)/latest/v/$(VTTYPE)/$(LIBTYPE_STRIP)_$(VTTYPE)_core.v
VLOG_LIBS := $(VLOG_LIBS) -v /p/kits/intel/p$(PROCESS)/p$(PROCESS)_$(PROCVER)/stdcells/$(LIBTYPE)/$(CUSTNAME)/latest/v/primitives/$(LIBTYPE_STRIP)_primitive_verilog.v
endif

.PHONY: all cleanall
all:
	$(foreach bdir,$(DIRS),$(shell $(MAKE) cdc BLOCK_NAME=$(bdir)))

com: $(BLOCK_NAME)/$(RTL_LIST)
	cd $(BLOCK_NAME)/; \
   rm -fr $(BLOCK_LIB_DIR); \
   vlib $(BLOCK_LIB_DIR); \
   vlog $(VLOG_OPT) $(VLOG_DEFINES) -f $(RTL_LIST) $(VLOG_LIBS) -work $(BLOCK_LIB_DIR) $(DEFINEPROCESS) | tee $(TOP_BLOCK_NAME)_vlog.log;

opt:
	cd $(BLOCK_NAME)/; \
   vopt -work $(BLOCK_LIB_DIR) $(TOP_BLOCK_NAME) -o $(TOP_BLOCK_NAME)_opt | tee $(TOP_BLOCK_NAME)_vopt.log;

tclc: $(BLOCK_NAME)/$(CTRL_FILE_V)
	cd $(BLOCK_NAME)/; \
   rm -f $(CTRL_FILE_TCL); \
   0in2tcl -ctrl_file $(CTRL_FILE_V) -od $(TCL_CTRL_DIR);

cdc: com tclc
	cd $(BLOCK_NAME)/; \
   rm -fr $(RESULTS_DIR); \
   ZI_STAT_LEVEL=3;export ZI_STAT_LEVEL; \
   qcdc -od $(RESULTS_DIR) -c -licq -do " \
      do $(CTRL_FILE_TCL); \
      do $(DBGF_FILE_TCL); \
      cdc run -d $(TOP_BLOCK_NAME) $(PARAM_DEFINES) -work $(BLOCK_LIB_DIR) $(HIEREN); \
      exit" | tee $(TOP_BLOCK_NAME)_qcdc.log

gui: $(BLOCK_NAME)/$(CDCDB)
	cd $(BLOCK_NAME); \
   qcdc $(CDCDB);

verify: $(BLOCK_NAME)/$(TOP_BLOCK_NAME)_qcdc.log
	perl -ne'/Violations \((\d+)\)/; die( "$(TOP_BLOCK_NAME) has $$1 Violations\n" ) if $$1 != 0' $(BLOCK_NAME)/$(TOP_BLOCK_NAME)_qcdc.log
	perl -ne'/Cautions \((\d+)\)/;   die( "$(TOP_BLOCK_NAME) has $$1 Cautions\n" ) if $$1 != 0' $(BLOCK_NAME)/$(TOP_BLOCK_NAME)_qcdc.log

clean:
	rm -fr $(BLOCK_NAME)/$(RESULTS_DIR)
	rm -fr $(BLOCK_NAME)/$(BLOCK_LIB_DIR)
	rm -f  $(BLOCK_NAME)/*.log
	rm -f  $(BLOCK_NAME)/$(CTRL_FILE_TCL)

cleanall:
	$(foreach bdir,$(DIRS),$(shell $(MAKE) clean BLOCK_NAME=$(bdir)))

