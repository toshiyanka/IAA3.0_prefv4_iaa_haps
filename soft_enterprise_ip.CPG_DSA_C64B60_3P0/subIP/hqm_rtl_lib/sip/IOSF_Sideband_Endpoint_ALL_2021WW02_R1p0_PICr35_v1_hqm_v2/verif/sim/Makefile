#------------------------------------------------------------------------------
#
#  -- Intel Proprietary
#  -- Copyright (C) 2015 Intel Corporation
#  -- All Rights Reserved
#
#  INTEL CONFIDENTIAL
#
#  Copyright 2009-2021 Intel Corporation All Rights Reserved.
#
#  The source code contained or described herein and all documents related
#  to the source code (Material) are owned by Intel Corporation or its
#  suppliers or licensors. Title to the Material remains with Intel
#  Corporation or its suppliers and licensors. The Material contains trade
#  secrets and proprietary and confidential information of Intel or its
#  suppliers and licensors. The Material is protected by worldwide copyright
#  and trade secret laws and treaty provisions. No part of the Material may
#  be used, copied, reproduced, modified, published, uploaded, posted,
#  transmitted, distributed, or disclosed in any way without Intel's prior
#  express written permission.
#
#  No license under any patent, copyright, trade secret or other intellectual
#  property right is granted to or conferred upon you by disclosure or
#  delivery of the Materials, either expressly, by implication, inducement,
#  estoppel or otherwise. Any license under such intellectual property rights
#  must be express and approved by Intel in writing.
#
#------------------------------------------------------------------------------
#
#  Collateral Description:
#  IOSF - Sideband Channel IP
#
#  Source organization:
#  SEG / SIP / IOSF IP Engineering
#
#  Support Information:
#  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
#  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
#
#  Revision:
#  2021WW02_PICr35
#
#
#  Usage:
#
#        Main Targets:
#
#        make (or make questa)     # run RTL based testbench (see below for default network and test) 
#        make questa-batch         # same as above but in batch mode
#        make questa-tlm           # same as make / make questa but TLM only (no RTL)
#        make questa-tlm-batch     # same as questa-tlm but in batch mode
#        make visual               # display nework topology graph from last sim
#
#        Shortcuts:
#
#        make 8port                # run 8 port synchronous router test
#        make async                # run 8 port asynchronous router test
#        make patsburg             # run patsburg multi-router test
#        make random               # generate a random TLM network test
#        make patsburg_tlm         # patsburg multi-router TLM only test
#        make iptest               # SBE testbench for VCS
#        make iptest-batch         # batch version of iptest for VCS
#        make iptest-questa        # SBE testbench for Questa
#        make iptest--questa-batch # batch version of iptest for Questa
#
#        Cleaning:
#
#        make clean                # Cleans all DUT and TB compile results
#        make cleanall             # same as clean but also cleans OVM and supporting libraries, log/coverage files
#
#        Make Options:
#
#        DYNAMO=<enable>           Default = 0, set to 1 to enable Dynamo mode
#        OPTIONS=+IOSF_PC          Run test with protocol checkers (the default)
#        TEST=<test name>          Run a specific test.  Default: rtr_rnd_test
#        NETWORK=<network>         Use specified network for the test. Default = 8port_async  
#                                  Networks are defined in the tests/ directory using IPXACT xml files.
#        UPF=<0|1>                 UPF=1 enables power-aware simulation. UPF=0 (default) disables power
#                                  aware simulation.
#        TYPE=<type>               Save graphical network output in a particular format. Default=svg
#        TXLIMIT=<number>          Stop sending xactions after sending TXLIMIT xactions. Default = 500
#        ERRCNT=<number>           Stop test after specified number of ovm_errors. Default = 1
#        TIMEOUT_DELAY=<number>    Arbitary time out delay for aging xactions. Default = 30100000
#        TIMEOUT_TEST=<number>     OVM Watchdog timer delay in ps units, test will timeout after this timer units
#        SEED=<number>             Use specified random seed.  Default = random
#        VERBOSITY=<setting>       Default = OVM_NOE
#        OVM_DEBUG           = 500, // OVM_FULL + OVM debug messages
#        OVM_FULL            = 400, // OVM_HIGH + VERBOSITY_ALL
#        OVM_HIGH            = 300, // OVM_MEDIUM + VERBOSITY_DEBUG_2
#        OVM_MEDIUM          = 200, // OVM_LOW + VERBOSITY_DEBUG_1
#        OVM_LOW             = 100, // OVM_NONE + VERBOSITY_PATH,VERBOSE_TX_RX, VERBOSE_PROGRESS
#        OVM_NONE            = 0, // Print FATAL, INFO, WARNING
#
#        Coverage	 MSIM_CM=1
#        PLATFORM=<string>         Option to pass to gcc when compiling supporting libraries.
#                                  Defaults to -m64 (x86-64 compile).  For 32-bit compile, 
#                                  use PLATFORM=-m32
include ../scripts/Makefile

export GEN_DIR = ../../unsupported/gen
export DYNAMO = 0
export DO_NOT_MAKE_TB = 0
export GLS = 0
export EP_NETLIST_DIR = ../../tools/syn/syn_1271/gls_config/rdt/outputs/
export LIB_1271_DIR = /p/kits/intel/p1271/p1271_8.2.0/stdcells/b12.4/default/latest/v
export LIB_1273_DIR =
XML2CSV_OPTIONS = 
SBCCFG_OPTIONS =
export VC_PH2  = 0

#export LTESCALE ?= 1

clean-dev:
ifeq ($(DYNAMO),0)
	rm -Rf ../tb/top_tb
endif

clean: clean-dev

build-questa:
	mkdir -p $(ROOT)/bin
	if [ ! -e $(VLOG_WORK)/_info  ]; then vlib $(VLOG_WORK); fi
	$(MAKE) build-questa -C $(VC_DIR)/ovmlib
	$(MAKE) build-questa -C $(VC_DIR)/svlib
	$(MAKE) build-questa -C $(VC_DIR)/tb
	$(MAKE) build-questa -C $(VC_DIR)/tests
	$(MAKE) build-questa -C $(VC_DIR)/tb/intf


rtl: 
	make ../tb/top_tb/$(NETWORK)/tb_$(NETWORK).sv


8port:
	make NETWORK=lv0_sbr_cfg_1 TEST=rtr_rnd_test 

async:
	make NETWORK=lv0_sbr_async_cfg_18 TEST=rtr_rnd_test 

patsburg:
	make NETWORK=lv0_sbn_cfg_1 TEST=rtr_rnd_test 

##$(GEN_DIR)/sbccfg: $(GEN_DIR)/sbccfg.c
##	gcc -D LTESCALE=$(LTESCALE) $(GEN_DIR)/sbccfg.c -o $(GEN_DIR)/sbccfg
$(GEN_DIR)/sbccfg: $(GEN_DIR)/sbccfg.c
	gcc $(GEN_DIR)/sbccfg.c -o $(GEN_DIR)/sbccfg

.tb_$(NETWORK).ts: ../tb/top_tb/$(NETWORK)/tb_$(NETWORK).sv
.sbc_top_tb_lib_$(NETWORK): ../tb/top_tb/$(NETWORK)/tb_$(NETWORK).sv

ifeq ($(DO_NOT_MAKE_TB),0)
../tb/top_tb/$(NETWORK)/tb_$(NETWORK).sv:$(GEN_DIR)/sbccfg ../tests/networks/$(NETWORK).xml $(GEN_DIR)/xml2csv.pl $(GEN_DIR)/iosf_sbc_tb_template.sv
	mkdir -p ../tb/top_tb 
	mkdir -p ../tb/top_tb/$(NETWORK) 
	mkdir -p ../tb/top_tb/$(NETWORK)/TestIsland
	$(GEN_DIR)/xml2csv.pl --ipxact_file ../tests/networks/$(NETWORK).xml --repeater_flop ../../../fabric_specs/iosf_sb_fabric_main/repeater_flop.tcl --sbr_repeater ../../../fabric_specs/iosf_sb_fabric_main/sbr_repeater.txt --sbr_switch ../../../fabric_specs/iosf_sb_fabric_main/sbr_switch.txt --tb_template $(GEN_DIR)/iosf_sbc_tb_template.sv --tb_output_dir ../tb/top_tb/$(NETWORK) --csv_output_file ../tb/top_tb/$(NETWORK)/$(NETWORK).csv --ep_type $(EP_TYPE) $(XML2CSV_OPTIONS) --gls $(GLS) --swap_ism 0 
	$(GEN_DIR)/sbccfg ../tb/top_tb/$(NETWORK)/$(NETWORK).csv -d ../tb/top_tb/$(NETWORK)/ $(SBCCFG_OPTIONS) -n $(NETWORK) 
	mv ../tb/top_tb/$(NETWORK)/$(NETWORK)*.upf ../../tools/upf/router
	mv ../tb/top_tb/$(NETWORK)/$(NETWORK)*_clamp_upf.cfg ../../tools/upf/router
    
else
../tb/top_tb/$(NETWORK)/tb_$(NETWORK).sv:
endif

random: build-questa
	make questa-tlm TEST=rand_test TOP=tb_tlm

patsburg_tlm: build-questa
	make questa-tlm TOP=tb_tlm NETWORK=3rtr_network_tlm TEST=rtr_rnd_test 

#################################################################
## For running cfg test for lv2_sbn_cfg_8_pbg network
cfgtest: NETWORK=lv2_sbn_cfg_8_pbg
cfgtest: TOP=tb_lv2_sbn_cfg_8_pbg_cfg
cfgtest: TEST=rtr_directed_cfg_test
cfgtest: COMPILER = vlogan
cfgtest: VLOG_WORK = sbc_common_lib
cfgtest: VLOG_ARGS = $(VLOGAN_ARGS)
cfgtest: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT)
cfgtest: setup_env prep cfgtest-compile
	mkdir -p log
	./bin/cfgtest/simv_cfgtest \
	$(VCS_ARGS) $(TB_ARGS) \
	-l log/cfgtest_$(SEED)_$(TEST).log 

cfgtest-compile: compile-cfgtest-tb
	mkdir -p ./bin/cfgtest
	vcs \
	$(VCS_COMPILE_ARGS) \
	$(TOP) \
	-o ./bin/cfgtest/simv_cfgtest	

compile-cfgtest-tb: VLOG_WORK = sbc_common_lib
compile-cfgtest-tb: 
		vlogan -work $(VLOG_WORK) \
		-sverilog \
		-timescale=1ps/1ps \
		-ntb_opts dtm+pcs \
		+incdir+$(RTL_ROOT_DIR)/iosfsbc/common \
		../tb/debug_tb/sbr1.sv ../tb/debug_tb/sbr2.sv ../tb/debug_tb/sbra.sv ../tb/debug_tb/ccsb.sv ../tb/debug_tb/tb_lv2_sbn_cfg_8_pbg.sv 


#used for certitude
cfgtest-batch-certitude: 
	./bin/cfgtest/simv_cfgtest \
	$(VCS_ARGS) $(TB_ARGS) \
	-l $(CER_LOG_FILE) 

#used for regression
cfgtest-batch: 
	mkdir -p log
	./bin/cfgtest/simv_cfgtest \
	$(VCS_ARGS) $(TB_ARGS) \
	-l log/cfgtest_$(SEED)_$(TEST).log 

cfgtest-compile-batch: setup_env compile-cfgtest-tb
	mkdir -p ./bin/cfgtest
	vcs \
	$(VCS_COMPILE_ARGS) \
	tb_lv2_sbn_cfg_8_pbg \
	-o ./bin/cfgtest/simv_cfgtest	

#################################################################
## For running pwr test for BVL network
pwrtest: NETWORK=lv2_sbn_cfg_9_BVL
pwrtest: TOP=tb_lv2_sbn_cfg_9_BVL_pwr
pwrtest: TEST=rtr_directed_pwr_test
pwrtest: COMPILER = vlogan
pwrtest: VLOG_WORK = sbc_common_lib
pwrtest: VLOG_ARGS = $(VLOGAN_ARGS)
pwrtest: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT)
pwrtest: setup_env prep pwrtest-compile
	mkdir -p log
	./bin/pwrtest/simv_pwrtest \
	$(VCS_ARGS) $(TB_ARGS) \
	-l log/pwrtest_$(SEED)_$(TEST).log 

pwrtest-compile: compile-pwrtest-tb
	mkdir -p ./bin/pwrtest
	vcs \
	$(VCS_COMPILE_ARGS) \
	tb_lv2_sbn_cfg_9_BVL_pwr \
	-o ./bin/pwrtest/simv_pwrtest	

compile-pwrtest-tb: VLOG_WORK = sbc_common_lib
compile-pwrtest-tb: 
		vlogan -work $(VLOG_WORK) \
		-sverilog \
		-timescale=1ps/1ps \
		-ntb_opts dtm+pcs \
		+incdir+$(RTL_ROOT_DIR)/iosfsbc/common \
		+incdir+$(VC_DIR)/tb/ip_vc \
		$(VC_DIR)/tb/intf/iosfsb_ep_mon.sv \
		../tb/debug_tb/pwr_tb/*.sv 

#used for regression
pwrtest-batch: 
	mkdir -p log
	./bin/pwrtest/simv_pwrtest \
	$(VCS_ARGS) $(TB_ARGS) \
	-l log/pwrtest_$(SEED)_$(TEST).log 

pwrtest-compile-batch: setup_env compile-pwrtest-tb
	mkdir -p ./bin/pwrtest
	vcs \
	$(VCS_COMPILE_ARGS) \
	tb_lv2_sbn_cfg_9_BVL_pwr \
	-o ./bin/pwrtest/simv_pwrtest	

#################################################################
# For LNC_BFM integration, using lv0_sbr_cfg_1 network
# Can only use VCS for this, make lnc_bfm_vcs TEST=directed_test
export VCS_COMPILE_ARGS_lncbfm = \
			+plusarg_ignore \
			-LDFLAGS \
			"-L${ROOT}/../bfm/sideband_vc/svlib/bin -lxmlpp_cwrap" \
			-assert enable_diag \
			-debug_all 

export VCS_ARGS_lncbfm = \
		+ntb_enable_solver_trace_on_failure=2 \
		+ntb_random_seed=${SEED} \
		+define+IOSFSBM_COVERAGE_OFF \
		${OPTIONS} \
		-assert nopostproc 

export VLOGAN_ARGS_lncbfm = \
	+incdir+$(OVM_HOME)/src \
	+define+VCS \
	+define+IOSFSBM_COVERAGE_OFF \
	-sverilog \
	-timescale=1ps/1ps \
	-ntb_opts dtm+pcs \
	+define+IOSF_SB_ASSERT_OFF \
	-work $(VLOG_WORK) 

export TB_ARGS_lncbfm = \
		+OVM_TESTNAME=iosfsbm_rtr_tests::${TEST} \
		+NETWORK=../tests/networks/8port_lncbfm.xml\
		+OVM_VERBOSITY=$(VERBOSITY) \
		+ERRCNT=$(ERRCNT) \
		+TXLIMIT=$(TXLIMIT) \
		+TIMEOUT_TEST=$(TIMEOUT_TEST) \
		+TIMEOUT_DELAY=$(TIMEOUT_DELAY) 

lnc_bfm_vcs: COMPILER = vlogan
lnc_bfm_vcs: VLOG_WORK = sbc_tb_lib
lnc_bfm_vcs: VLOG_ARGS = $(VLOGAN_ARGS_lncbfm)


ifeq ($(INT),1)
	VCS_ARGS_lncbfm += -gui
endif

lnc_bfm_vcs: lncbfm_compile_vcs
	/tmp/netbatch/lnc_bfm_$(SEED)/simv_lnc_bfm_$(SEED) \
	$(VCS_ARGS_lncbfm) $(TB_ARGS_lncbfm) \
	-l log/tb_8port_lncbfm_$(SEED)_$(TEST).log 

lncbfm_compile_vcs: setup_env_lncbfm prep sbc_lncbfm_lib sbc_lncbfm_top_tb_lib 
	mkdir -p log
	mkdir -p $(ROOT)/bin
	mkdir -p /tmp/netbatch/lnc_bfm_$(SEED)
	vcs -l build.log\
	$(VCS_COMPILE_ARGS_lncbfm) \
	tb_8port_lncbfm \
	-o /tmp/netbatch/lnc_bfm_$(SEED)/simv_lnc_bfm_$(SEED)

sbc_lncbfm_lib: 
	vlogan -work sbc_lncbfm_lib \
	-sverilog \
	-timescale=1ps/1ps \
	-ntb_opts dtm+pcs \
	-f ${ROOT}/../scripts/compile_avmtb.f

sbc_lncbfm_top_tb_lib: VLOG_WORK = sbc_tb_lib
sbc_lncbfm_top_tb_lib: 
	vlogan \
	$(VLOGAN_ARGS_lncbfm) \
	-f ${ROOT}/../scripts/avmbfm_list.f

setup_env_lncbfm:
	@mkdir -p ./bin
	@rm -f $(SYNOPSYS_SIM_SETUP)
	@echo "sbc_tb_lib : $(ROOT)/bin/sbc_tb_lib" >> $(SYNOPSYS_SIM_SETUP);
	@echo "sbc_lncbfm_lib : $(ROOT)/bin/sbc_lncbfm_lib" >> $(SYNOPSYS_SIM_SETUP);
	@echo "WORK > sbc_tb_lib" >> $(SYNOPSYS_SIM_SETUP)
	@echo "tb_8port_lncbfm_lib : $(ROOT)/bin/tb_8port_lncbfm_lib" >> $(SYNOPSYS_SIM_SETUP)

#########################################################################
# To run test for endpoint
# for SBE Testbench only with IPVC
export ASYNC_RESET=0
export ASYNC_CLK=0

ifeq ($(IPTEST_CM), 1)
   IPTEST_COV_VCS_FLAGS := -cm line+path+cond+tgl+assert+fsm+branch -lca
   IPTEST_COV_VCS_SAVE := -cm_dir log/tb_$(TEST)_$(SEED)
   IPTEST_COV_FLAGS := -cover bcestf
   IPTEST_COV_SIM_FLAGS := -coverage
   IPTEST_COV_SAVE := coverage save -onexit -assert -directive -cvg -code bcestf log/tb_$(TEST)_$(SEED).ucdb;
else
   IPTEST_COV_VCS_FLAGS := 
   IPTEST_COV_VCS_SAVE := 
   IPTEST_COV_FLAGS := 
   IPTEST_COV_SIM_FLAGS := 
   IPTEST_COV_SAVE := 
endif

#VCS args
export VCS_COMPILE_ARGS_IPTEST = \
			+plusarg_ignore \
			-assert enable_diag \
			$(IPTEST_COV_VCS_FLAGS) \
			$(IPTEST_COV_VCS_SAVE) \
			-debug_all \
			+vpi+cli+1 $(SAOLA_HOME)/libs/Linux_x86_64/libsla.so \
			-ntb_opts ext

export VCS_COMPILE_ARGS_IPTEST_CERTITUDE = \
			+plusarg_ignore \
			-assert enable_diag \
			$(IPTEST_COV_VCS_FLAGS) \
			$(IPTEST_COV_VCS_SAVE) \
			-debug_all ${CER_VCS_PLI}\
			-ntb_opts ext
export TB_ARGS_IPTEST = \
		+OVM_TESTNAME=iosftest_pkg::${TEST} \
		+OVM_VERBOSITY=$(VERBOSITY)\
		+ERRCNT=$(ERRCNT) \
		+TXLIMIT=$(TXLIMIT) \
		+TIMEOUT_TEST=$(TIMEOUT_TEST) \
		+TIMEOUT_DELAY=$(TIMEOUT_DELAY) \
		+DISABLE_TIMEOUT=$(DISABLE_TIMEOUT) 

export VCS_ARGS_IPTEST = \
		+ntb_enable_solver_trace_on_failure=2 \
		+ntb_random_seed=${SEED} \
		-assert nopostproc \
		$(IPTEST_COV_VCS_FLAGS) \
		$(IPTEST_COV_VCS_SAVE) \
		-covg_no_override_test

export VLOGAN_ARGS_IPTEST = \
	+incdir+$(OVM_HOME)/src \
	+define+VCS \
	+define+SVC_USE_CCU_VC \
	-sverilog \
	-timescale=1ps/1ps \
	-ntb_opts dtm+pcs+ext \
	-work $(VLOG_WORK) 

export VLOGAN_ARGS_DUT_IPTEST = \
	+incdir+$(OVM_HOME)/src \
	+define+VCS \
	-sverilog \
	-timescale=1ps/1ps \
	-ntb_opts dtm+pcs+ext \
	-work $(VLOG_WORK) \
	$(IPTEST_COV_VCS_FLAGS)

ifeq ($(UPF),1)
	VLOGAN_ARGS_IPTEST += -power=lp_assert +warn=noTFIPC +define+SBEP_POWER_AWARE_SIM+VCSSIM
	VCS_COMPILE_ARGS_IPTEST += -power=dccompat_gen_separator \
                              -upf $(BINDIR)/container.upf \
                              -power=lp_assert \
                              +warn=noTFIPC
	VLOGAN_ARGS += -power=lp_assert +warn=noTFIPC +define+SBEP_POWER_AWARE_SIM+VCSSIM
	VCS_COMPILE_ARGS += -power=dccompat_gen_separator \
                       -upf $(BINDIR)/containertr.upf \
                       -power=lp_assert \
                       +warn=noTFIPC
endif

export P1271_COMPILE = \
	-v $(LIB_1271_DIR)/ln/b12_ln_core.v \
	-v $(LIB_1271_DIR)/ln/b12_ln_core_udp.v \
	-v $(LIB_1271_DIR)/un/b12_un_core.v \
	-v $(LIB_1271_DIR)/un/b12_un_core_udp.v \
	-v $(LIB_1271_DIR)/nn/b12_nn_core.v \
	-v $(LIB_1271_DIR)/nn/b12_nn_core_udp.v \
	-v $(LIB_1271_DIR)/primitives/b12_primitive_verilog.v

export P1273_COMPILE = \


ifeq ($(ASYNC_RESET), 1)
	VLOGAN_ARGS_IPTEST += +define+ASYNC_RESET
	VCS_ARGS_IPTEST += +define+ASYNC_RESET
	VLOG_ARGS_IPTEST += +define+ASYNC_RESET
endif

ifeq ($(RESET_TEST), 1)
	VLOGAN_ARGS_IPTEST += +define+RESET_TEST
	VCS_ARGS_IPTEST += +define+RESET_TEST
	VLOG_ARGS_IPTEST += +define+RESET_TEST
endif

ifeq ($(ASYNC_CLK), 1)
	VLOGAN_ARGS_IPTEST += +define+ASYNC_CLK
	VCS_ARGS_IPTEST += +define+ASYNC_CLK
	VLOG_ARGS_IPTEST += +define+ASYNC_CLK
endif

ifeq ($(FSDB), 1)
	VCS_COMPILE_ARGS_IPTEST += -fsdb
	VCS_COMPILE_ARGS_IPTEST_CERTITUDE += -fsdb
	VCS_ARGS_IPTEST += +fsdbfile+log/$(TOP)_$(SEED).fsdb
	VLOGAN_ARGS_IPTEST += +define+FSDB
	VCS_ARGS_IPTEST += +define+FSDB
	VLOG_ARGS_IPTEST += +define+FSDB
endif

ifeq ($(VC_PH2),1)
#	VCS_COMPILE_ARGS_IPTEST += +define+IOSF_SB_PH2
#	VCS_COMPILE_ARGS_IPTEST_CERTITUDE += +define+IOSF_SB_PH2
	VLOGAN_ARGS_IPTEST += +define+IOSF_SB_PH2
	VLOG_ARGS_IPTEST += +define+IOSF_SB_PH2
	VCS_ARGS_IPTEST += +define+IOSF_SB_PH2
endif

ifeq ($(INT),1)
	VCS_COMPILE_ARGS_IPTEST += -gui
	VCS_COMPILE_ARGS_IPTEST_CERTITUDE += -gui
endif

ifeq ($(LIB_NAME), P1273)
	LIB_COMPILE = $(P1273_COMPILE)
else
	LIB_COMPILE = $(P1271_COMPILE)
endif

ifeq ($(GLS),1)
	VLOGAN_ARGS_IPTEST += +define+GLS
	VCS_ARGS_IPTEST += +define+GLS
	VLOG_ARGS_IPTEST+= +define+GLS
endif

#for VCS
iptest: COMPILER = vlogan
iptest: VLOG_WORK = sbc_common_lib
iptest: VLOG_ARGS = $(VLOGAN_ARGS_IPTEST)
iptest: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT_IPTEST)
iptest: setup_env gen_param prep-iptest iptest-compile
	mkdir -p log
	$(BINDIR)/simv_$(NETWORK) \
	$(VCS_ARGS_IPTEST) $(TB_ARGS_IPTEST) \
	-l log/$(TEST)_$(SEED).log 
	rm -Rf $(BINDIR)

# separate prep operation for VCS batch processing.
iptest-batch: COMPILER = vlogan
iptest-batch: VLOG_WORK = sbc_common_lib
iptest-batch: VLOG_ARGS = $(VLOGAN_ARGS_IPTEST)
iptest-batch: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT_IPTEST)
iptest-batch: setup_env iptest-compile
	mkdir -p log
	$(BINDIR)/simv_$(NETWORK) \
	$(VCS_ARGS_IPTEST) $(TB_ARGS_IPTEST) \
	-l log/$(TEST)_$(SEED).log 
	rm -Rf $(BINDIR)

iptest-compile: setup_env compile-iptest-tb
	mkdir -p $(BINDIR)
ifeq ($(UPF),1)
	echo -e "set_design_top tb_top\nload_upf ../../tools/upf/sbendpoint/sbe_top.upf" >$(BINDIR)/container.upf
endif
	vcs \
	$(VCS_COMPILE_ARGS_IPTEST) \
	tb_top \
	-o $(BINDIR)/simv_$(NETWORK) \
	-Mdir=$(BINDIR)/csrc_$(NETWORK) \
	|tee log/$(TEST)_$(SEED).elab.log

ifeq ($(GLS),0)
fpv_target =  ../tb/ep_tb/agent_compliance/agent_fpv_bind.sv
else
fpv_target = 
endif

compile-iptest-tb: VLOG_WORK = $(NETWORK)_lib
compile-iptest-tb:
		vlogan $(VLOGAN_ARGS_IPTEST) \
		+incdir+$(VC_DIR)/tb/ip_vc \
		+incdir+../tb/ep_tb/agent_compliance \
		+incdir+../tests/ep_tests \
		+incdir+$(VC_DIR)/tb/common \
		+incdir+$(VC_DIR)/tb/intf \
		$(VC_DIR)/tb/ip_vc/ep_ti.svh \
		$(VC_DIR)/tb/intf/iosfsb_ep_mon.sv \
		../tb/ep_tb/agent_compliance/agent_mmsg_compliance.sv \
		../tb/ep_tb/agent_compliance/agent_mreg_compliance.sv \
		../tb/ep_tb/agent_compliance/agent_compliance.sv \
		$(fpv_target)\
		${ROOT}/../tb/iosf_sb_ti.sv \
		../tb/ep_tb/tb_top.sv 

# separate prep operation for VCS batch processing.
# also used for certitude
iptest-prep: COMPILER = vlogan
iptest-prep: VLOG_WORK = sbc_common_lib
iptest-prep: VLOG_ARGS = $(VLOGAN_ARGS_IPTEST)
iptest-prep: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT_IPTEST)
iptest-prep: setup_env prep-iptest

prep-iptest:
	rm -rf log/$(TEST)_$(SEED).compile.log
	$(MAKE) build -C $(VC_DIR)/ovmlib 
	$(MAKE) build -C $(SV_UTIL_ROOT) 
	$(MAKE) build -C $(CCU_VC_HOME)/ 
	if [ $(GLS) == 1 ]; then $(COMPILER) $(VLOG_ARGS_DUT) +incdir$(EP_NETLIST_DIR) $(EP_NETLIST_DIR)sbendpoint.syn_final.vg $(LIB_COMPILE) +notimingcheck +delay_mode_zero;	else $(MAKE) build-ep -C $(RTL_ROOT_DIR); fi 
	$(MAKE) build-iptest -C $(VC_DIR)/tb 
	$(MAKE) build-iptest -C ../tests 
	$(MAKE) build -C $(VC_DIR)/compmon 
	$(MAKE) build-iptest -C $(VC_DIR)/tb/intf 
	@echo "Completed compile for common components"

ifeq ($(GLS),1)
gen_param:../tests/ep_tests/ep_params_gls.svh
else
gen_param:
	../../scripts/iptest_gen_params $(SEED)
	@echo "Completed generating Parameters"
endif
#####################################################################
# for SBE certitude
iptest-certitude: COMPILER = vlogan
iptest-certitude: VLOG_WORK = sbc_common_lib
iptest-certitude: VLOG_ARGS = $(VLOGAN_ARGS_IPTEST)
iptest-certitude: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT_IPTEST)
iptest-certitude: setup_env prep-iptest iptest-compile-certitude
	$(BINDIR)/simv_$(NETWORK) \
	$(VCS_ARGS_IPTEST) $(TB_ARGS_IPTEST) \
	-l $(CERT_LOG_FILE)
	rm -Rf $(BINDIR)

iptest-compile-certitude: setup_env compile-iptest-tb
	mkdir -p $(BINDIR)
	vcs \
	$(VCS_COMPILE_ARGS_IPTEST_CERTITUDE) \
	tb_top \
	-o $(BINDIR)/simv_$(NETWORK) \
	-Mdir=$(BINDIR)/csrc_$(NETWORK)


######################################################################
# for SBE QuestaSim
export VLOG_ARGS_IPTEST = \
	-sv -novopt -nologo \
	-timescale 1ps/1ps \
	+incdir+. -work $(VLOG_WORK_MSIM) \
	+incdir+$(OVM_HOME)/src \
	-suppress 2217 \
	$(IPTEST_COV_FLAGS)

export VLOG_ARGS_DUT_IPTEST = \
	-sv -novopt -nologo \
	-timescale 1ps/1ps \
	+incdir+. -work $(VLOG_WORK_MSIM)\
	+incdir+$(OVM_HOME)/src \
	-suppress 2217  \
	$(IPTEST_COV_FLAGS)

export VSIM_ARGS_IPTEST = \
		$(TOP)  -sv_lib $(ROOT)/../bfm/sideband_vc/svlib/bin/libxmlpp_cwrap \
		+define+IOSF_SB_PH2 \
		-sv_seed ${SEED} \
		-suppress 3839,3829,3838 \
		-solveengine bdd \
		+nowarnTFMPC \
		-novopt \
		-solvefaildebug \
		$(IPTEST_COV_SIM_FLAGS) \
		-permit_unmatched_virtual_intf

iptest-questa: NETWORK = lv0_sbr_cfg_1
iptest-questa: TOP = tb_top
iptest-questa: COMPILER = vlog
iptest-questa: VLOG_ARGS = $(VLOG_ARGS_IPTEST)
iptest-questa: VLOG_ARGS_DUT = $(VLOG_ARGS_DUT_IPTEST)
iptest-questa: gen_param prep-iptest-questa compile-iptest-tb-questa
	mkdir -p log
	vsim $(VSIM_ARGS_IPTEST) $(TB_ARGS_IPTEST) \
	-L $(VLOG_WORK_MSIM) -lib $(MSIM_NETBATCH_LIB) \
	-do "$(IPTEST_COV_SAVE) do misc/startup.do" \
	-assertdebug -l log/$(TEST)_$(SEED).log \
	-wlf log/${TOP}_${SEED}_${TEST}.wlf 
	rm -Rf $(MSIM_NETBATCH_LIB)

iptest-questa-batch: NETWORK = lv0_sbr_cfg_1
iptest-questa-batch: TOP = tb_top
iptest-questa-batch: COMPILER = vlog
iptest-questa-batch: VLOG_ARGS = $(VLOG_ARGS_IPTEST)
iptest-questa-batch: VLOG_ARGS_DUT = $(VLOG_ARGS_DUT_IPTEST)
iptest-questa-batch: gen_param prep-iptest-questa compile-iptest-tb-questa
	mkdir -p log
	vsim $(VSIM_ARGS_IPTEST) $(TB_ARGS_IPTEST) \
	-L $(VLOG_WORK_MSIM) -lib $(MSIM_NETBATCH_LIB) \
	-c -do "$(IPTEST_COV_SAVE) do misc/startup_batch.do" \
	-assertdebug -l log/$(TEST)_$(SEED).log \
	-wlf log/${TOP}_${SEED}_${TEST}.wlf 
	rm -Rf $(MSIM_NETBATCH_LIB)

compile-iptest-tb-questa: 
		mkdir -p log
		mkdir -p $(MSIM_NETBATCH_LIB)
		mkdir -p $(ROOT)/bin
		if [ ! -e $(MSIM_NETBATCH_LIB)/_info  ]; then vlib $(MSIM_NETBATCH_LIB); fi
		vlog $(VLOG_ARGS_DUT_IPTEST) \
		-work $(MSIM_NETBATCH_LIB) -L $(VLOG_WORK_MSIM) \
		+incdir+$(VC_DIR)/tb/ip_vc \
		$(VC_DIR)/tb/intf/iosfsb_ep_mon.sv \
		${ROOT}/../tb/iosf_sb_ti.sv \
		../tb/ep_tb/tb_top.sv

prep-iptest-questa:
	mkdir -p bin
	mkdir -p $(MSIM_NETBATCH_LIB)
	if [ ! -e $(VLOG_WORK_MSIM)/_info  ]; then vlib $(VLOG_WORK_MSIM); fi
	$(MAKE) build -C $(VC_DIR)/ovmlib
	$(MAKE) build -C $(SV_UTIL_ROOT)
	$(MAKE) build-ep -C $(RTL_ROOT_DIR)
	$(MAKE) build-iptest -C $(VC_DIR)/tb
	$(MAKE) build-iptest -C ../tests
	$(MAKE) build -C $(VC_DIR)/compmon
	$(MAKE) build -C $(VC_DIR)/tb/intf
	@echo "Completed compile for common components"

##############################################################
#for SBR Certitude
# simv executable for this network
bin/simv_$(NETWORK): setup_env .sbc_top_tb_lib_$(NETWORK)
	mkdir -p ./bin/$(NETWORK)
	vcs -l compile_$(CER_LOG_FILE)\
	$(VCS_COMPILE_ARGS_CERTITUDE) \
	$(TOP) \
	-Mdir=./bin/$(NETWORK)/csrc_$(NETWORK) \
	-o ./bin/$(NETWORK)/simv_$(NETWORK)

vcs-certitude:setup_env
	./bin/$(NETWORK)/simv_$(NETWORK) \
	$(VCS_ARGS) $(TB_ARGS) \
	-l $(CER_LOG_FILE)

##############################################################
#for VCS batch processing
tb_build_$(NETWORK): ../tb/top_tb/$(NETWORK)/tb_$(NETWORK).sv

####################################################################
# special target for SBR to have ep_rtls with different spec version

# get 2010ww46 endpoint release
get_ep:
	if [ $(MIXED_EP_SPEC) == 1 -a ! -e ../lib/ip-iosf-sideband-endpoint-2010ww46/verif/sim/README.txt ]; then git clone ip-iosf-sideband-rtl ../lib/ip-iosf-sideband-endpoint-2010ww46; cd ../lib/ip-iosf-sideband-endpoint-2010ww46; git checkout ip-iosf-sideband-endpoint-2010ww46; cd source/rtl; cp ../../../../../unsupported/scripts/unilist_sbe_090 .; puni -filelist unilist_sbe_090; rm -rf iosfsbc/common/sb*; rm -rf iosfsbc/endpoint/sb*; fi
	@echo "Completed getting 2010ww46 ep release"

# overall vcs target
vcs-mixed-spec: COMPILER = vlogan
vcs-mixed-spec: VLOG_WORK = sbc_common_lib
vcs-mixed-spec: VLOG_ARGS = $(VLOGAN_ARGS)
vcs-mixed-spec: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT)
vcs-mixed-spec: setup_env get_ep prep vcs-test-cmpl_$(NETWORK) $(BINDIR)/simv_$(NETWORK)
	mkdir -p log
	$(BINDIR)/simv_$(NETWORK) \
	$(VCS_ARGS) $(TB_ARGS) \
	-l log/$(TOP)_$(SEED)_$(TEST).log 
	rm -Rf $(BINDIR)
