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
#        make visual NETWORK=<network>    # display nework topology graph from last sim
#
#        Cleaning:
#
#        make clean                # Cleans all DUT and TB compile results
#        make cleanall             # same as clean but also cleans OVM and supporting libraries, log/coverage files
#
#        Make Options:
#
#        DYNAMO=<enable>           Default = 0, set to 1 to enable Dynamo mode
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
#        Coverage        
#        MSIM_CM=1
#        PLATFORM=<string>         Option to pass to gcc when compiling supporting libraries.
#                                  Defaults to -m64 (x86-64 compile).  For 32-bit compile, 
#                                  use PLATFORM=-m32

# Constants
# =========
export GET = file
export RTL_ROOT_DIR     = ../../source/rtl
export VC_DIR = ../bfm/sideband_vc
export OOB_VC_HOME = ../bfm/psmi_oob
export CCU_VC_HOME = ../bfm/ccu_vc
export PGCB_VC_HOME= ../bfm/pgcb_vc
export JTAG_VC_HOME = ../../subIP/CHASSIS_JTAGBFM_2020WW16_R4.1
export RTL_GLS_DIR = ../../tools/syn/syn_1271/sbr*
export LIB_1271_DIR = /p/kits/intel/p1271/p1271_8.2.0/stdcells/b12.4/default/latest/v/

# Compile parameters
# Default to Modelsim (questa)
export DYNAMO           = 0
export ROOT             = $(PWD)
export COMPILER         = vlog
export VLOG_WORK_MSIM   = $(ROOT)/bin/vsimlib
export SV_UTIL_ROOT     = $(ROOT)/../bfm/sideband_vc/svlib
export VERIF_ROOT     = ..
export VLOGAN_TB_LIB    = sbc_tb_lib
export VLOGAN_RTR_LIB   = sbc_rtr_lib
export MSIM_NETBATCH_LIB = /tmp/netbatch/$(USER)/$(NETWORK)_$(TEST)_$(SEED)/vsimlib
export PGCB_EN  = 0
# Get a 32-bit hash of the current directory. By including this hash in BINDIR, the
# working directory is made unique per repo, allowing a single user to run concurrent
# regressions without colliding in the netbatch directory.
export DIRHASH := $(shell echo -n $(PWD) | md5sum | sed s/............//g | sed s/\-//g | sed -e 's/\s//g')
export BINDIR = /tmp/netbatch/$(USER)/$(NETWORK)_$(TEST)_$(SEED)_$(DIRHASH)
export VLOG_WORK        = $(BINDIR)/vsimlib

# Run options
export TEST     	= rtr_rnd_test
export NETWORK  	= lv0_sbr_async_cfg_18
export TOP      	= tb_$(NETWORK)
export TYPE     	= svg
export SEED     	= random
export VERBOSITY        = OVM_LOW
export TXLIMIT		= 50
export ERRCNT		= 1
export TIMEOUT_DELAY    = 90100000
#default 3ms
export TIMEOUT_TEST     = 3000000000
export LOG              = transcript
export PLATFORM         = -m64
export INT              = 1
export VC_PH2           = 0
export IOSF_SPEC         = 090
export FSDB		= 0
export DISABLE_TIMEOUT  = 0
export ENABLE_ORDERING_CHECK = 1
export USE_CMPLTIME_XMLPARSER = 1
export GLS = 0
#to ignore ep_tlm field of the xml, new define is added here
#for now all eps can be ep_tlm or ep_rtl
#if ep_rtl, sbendpoint will be instantiated with ipvc for each ep
#EP_TLM = 0 and EP_RTL = 1
export EP_TYPE = 0
# if used, parser script and testbench will
# instantiate endpoint based on ep_rtl defined in the XML
export MIXED_EP_TYPE = 0
# if used, parser script and testbench will
# instantiate different endpoint revisions based on ep_rtl defined in the XML
export MIXED_EP_SPEC = 0

# Modelsim Coverage Flags conditionally selected based off command line Coverage switch MSIM_CM=1
ifeq ($(MSIM_CM), 1)
   MSIM_COV_FLAGS := -cover bcestf
   MSIM_COV_SIM_FLAGS := -coverage
   MSIM_COV_SAVE := coverage save -onexit -assert -directive -cvg -code bcestf log/$(TOP)_$(SEED).ucdb;
   MSIM_COV_VCS_FLAGS := -cm line+path+cond+tgl+assert+fsm+branch -lca
   MSIM_COV_VCS_SAVE := -cm_dir log/$(TOP)_$(TEST)_$(SEED)
else
   MSIM_COV_FLAGS := 
   MSIM_COV_SIM_FLAGS :=  
   MSIM_COV_SAVE := 
   MSIM_COV_VCS_FLAGS := 
   MSIM_COV_VCS_SAVE := 
endif

ifeq ($(USE_CMPLTIME_XMLPARSER), 0)
	vcs_ldflag = -LDFLAGS "-L ${ROOT}/../bfm/sideband_vc/svlib/bin -lxmlpp_cwrap"
	sv_libflag = -sv_lib $(ROOT)/../bfm/sideband_vc/svlib/bin/libxmlpp_cwrap
endif

# Questa args
export VLOG_ARGS = \
	-sv -vopt -nologo \
	-timescale 1ps/1ps \
	+incdir+. -work $(VLOG_WORK_MSIM) \
	+incdir+$(OVM_HOME)/src \
	-suppress 2217

export VLOG_ARGS_DUT = \
	-sv -vopt -nologo \
	-timescale 1ps/1ps \
	+incdir+. -work $(VLOG_WORK_MSIM)\
	+incdir+$(OVM_HOME)/src \
	+incdir+$(SAOLA_HOME)/verilog \
	-suppress 2217  \
	$(MSIM_COV_FLAGS)

#VCS args
export VLOGAN_ARGS = \
	+incdir+$(OVM_HOME)/src \
	+incdir+$(SAOLA_HOME)/verilog \
	+incdir+$(ACE_HOME)/lib/Verilog \
	+define+VCS \
	-sverilog -debug \
	-timescale=1ps/1ps \
	-ntb_opts dtm+pcs+ext \
	-work $(VLOG_WORK) 

export VLOGAN_ARGS_DUT = \
	+incdir+$(OVM_HOME)/src \
	+define+VCS \
	-sverilog \
	-timescale=1ps/1ps \
	-ntb_opts dtm+pcs+ext \
	-work $(VLOG_WORK) \
	$(MSIM_COV_VCS_FLAGS)

# Events cause VCS to crash.
#	+define+EVENT_ON 

# Common TB arguments for all simulators.
export TB_ARGS = \
		+OVM_TESTNAME=iosfsbm_rtr_tests::${TEST} \
		+NETWORK=../tests/networks/$(NETWORK).xml\
		+OVM_VERBOSITY=$(VERBOSITY) \
		+ERRCNT=$(ERRCNT) \
		+TXLIMIT=$(TXLIMIT) \
		+TIMEOUT_TEST=$(TIMEOUT_TEST) \
		+TIMEOUT_DELAY=$(TIMEOUT_DELAY) \
		+DISABLE_TIMEOUT=$(DISABLE_TIMEOUT) \
		+network=$(NETWORK) 

export VSIM_ARGS = \
		$(TOP)  $(sv_libflag) \
		-sv_seed ${SEED} \
		-suppress 3838,3009,3010,3017,3722,3829,3839 \
		-solveengine bdd \
		+nowarnTFMPC \
		-vopt \
		-solvefaildebug \
		$(MSIM_COV_SIM_FLAGS) \
		-permit_unmatched_virtual_intf

export VCS_COMPILE_ARGS = \
			+plusarg_ignore \
			$(vcs_ldflag) \
			-assert enable_diag \
			$(MSIM_COV_VCS_FLAGS) \
			$(MSIM_COV_VCS_SAVE) \
			-debug_all \
			-debug \
			-fsdb \
			-ntb_opts ext \
			-sverilog +vpi+cli+1 $(SAOLA_HOME)/libs/Linux_x86_64/libsla.so

export VCS_COMPILE_ARGS_CERTITUDE = \
			+plusarg_ignore \
			$(vcs_ldflag) \
			-assert enable_diag \
			$(MSIM_COV_VCS_FLAGS) \
			$(MSIM_COV_VCS_SAVE) \
			-debug_all  ${CER_VCS_PLI} \
			-ntb_opts ext

export VCS_ARGS = \
		+ntb_enable_solver_trace_on_failure=2 \
		+ntb_random_seed=${SEED} \
		-assert nopostproc \
		$(MSIM_COV_VCS_FLAGS) \
		$(MSIM_COV_VCS_SAVE) 

ifeq ($(VC_PH2),1)
	VLOGAN_ARGS += +define+IOSF_SB_PH2
	VLOG_ARGS += +define+IOSF_SB_PH2
	VCS_ARGS += +define+IOSF_SB_PH2
endif

ifeq ($(INT),1)
	VCS_COMPILE_ARGS += -gui
	VCS_COMPILE_ARGS_CERTITUDE += -gui
endif

ifeq ($(ENABLE_ORDERING_CHECK), 1)
	VLOG_ARGS += +define+ENABLE_ORDERING_CHECK 
	VLOGAN_ARGS += +define+ENABLE_ORDERING_CHECK
	VCS_ARGS += +define+ENABLE_ORDERING_CHECK
endif

ifeq ($(IOSF_SPEC), 081)
	VLOG_ARGS += +define+IOSF_SB_081 
	VLOG_ARGS_DUT += +define+IOSF_SB_081
	VLOGAN_ARGS += +define+IOSF_SB_081
	VCS_ARGS += +define+IOSF_SB_081
endif

ifeq ($(IOSF_SPEC), 082)
	VLOG_ARGS += +define+IOSF_SB_082 
	VLOG_ARGS_DUT += +define+IOSF_SB_082
	VLOGAN_ARGS += +define+IOSF_SB_082
	VCS_ARGS += +define+IOSF_SB_082
endif

ifeq ($(IOSF_SPEC), 083)
	VLOG_ARGS += +define+IOSF_SB_083 
	VLOG_ARGS_DUT += +define+IOSF_SB_083
	VLOGAN_ARGS += +define+IOSF_SB_083
	VCS_ARGS += +define+IOSF_SB_083
endif

ifeq ($(FSDB), 1)
	VCS_COMPILE_ARGS += -fsdb
	VCS_COMPILE_ARGS_CERTITUDE += -fsdb
	VCS_ARGS += +fsdbfile+log/$(TOP)_$(SEED)_$(TEST).fsdb
	VLOGAN_ARGS += +define+FSDB
	VCS_ARGS += +define+FSDB
endif

ifeq ($(EP_TYPE), 1)
	VLOG_ARGS += +define+EP_TYPE_RTL 
	VLOG_ARGS_DUT += +define+EP_TYPE_RTL
	VLOGAN_ARGS += +define+EP_TYPE_RTL
	VCS_ARGS += +define+EP_TYPE_RTL
endif

ifeq ($(MIXED_EP_SPEC), 1)
	VLOG_ARGS += +define+MIXED_EP_SPEC 
	VLOG_ARGS_DUT += +define+MIXED_EP_SPEC
	VLOGAN_ARGS += +define+MIXED_EP_SPEC
	VCS_ARGS += +define+MIXED_EP_SPEC
endif

ifeq ($(FSDB), 2)
	VCS_COMPILE_ARGS += -fsdb
	VCS_COMPILE_ARGS_CERTITUDE += -fsdb
	VLOGAN_ARGS += +define+FSDB
endif

ifeq ($(CER_WAVE_DUMP),1)
	VCS_ARGS += +fsdbfile+qualification/RUN/$(CER_SIMULATION_ID)_$(CER_TESTCASE_ID)_$(CER_FAULT_ID).fsdb
	VCS_ARGS += +define+FSDB
endif

ifeq ($(USE_CMPLTIME_XMLPARSER), 1)
	VLOG_ARGS += +define+USE_CMPLTIME_XMLPARSER 
	VLOGAN_ARGS += +define+USE_CMPLTIME_XMLPARSER
endif

ifeq ($(PGCB_EN),1)
	VLOGAN_ARGS += +define+PGCB_EN
	VLOG_ARGS += +define+PGCB_EN
endif
# unique simulation setup for each vcs simulation; avoids conflicts.
export SYNOPSYS_SIM_SETUP = $(BINDIR)/$(NETWORK)_$(SEED)_$(TEST)_sim.setup

# Main Targets
# ============

# compile main components.

prep-questa:
	mkdir -p bin
	if [ ! -e $(VLOG_WORK_MSIM)/_info  ]; then vlib $(VLOG_WORK_MSIM); fi
	$(MAKE) build -C $(VC_DIR)/ovmlib
	if [ $(USE_CMPLTIME_XMLPARSER) == 0 ]; then $(MAKE) build -C $(SV_UTIL_ROOT); else $(MAKE) build_cmpltime_xmlparser -C $(SV_UTIL_ROOT); fi
	$(MAKE) build -C $(RTL_ROOT_DIR)
	$(MAKE) build -C $(PGCB_VC_HOME)
	if [ $(EP_TYPE) == 1 -o $(MIXED_EP_TYPE) == 1 -o $(MIXED_EP_SPEC) == 1 ]; then $(MAKE) build-ep -C $(RTL_ROOT_DIR); fi
	if [ $(MIXED_EP_SPEC) == 1 ]; then $(MAKE) build-ep -C ../lib/ip-iosf-sideband-endpoint-2010ww46/source/rtl ; fi
	$(MAKE) build -C $(VC_DIR)/tb
	$(MAKE) build -C ../tests
	$(MAKE) build -C $(VC_DIR)/compmon
	$(MAKE) build -C $(VC_DIR)/tb/intf
	@echo "Completed compile for common components"

prep:	
	$(MAKE) build -C $(VC_DIR)/ovmlib
	if [ $(USE_CMPLTIME_XMLPARSER) == 0 ]; then $(MAKE) build -C $(SV_UTIL_ROOT); else $(MAKE) build_cmpltime_xmlparser -C $(SV_UTIL_ROOT); fi
	if [ $(GLS) == 1 ]; then $(COMPILER) $(VLOG_ARGS_DUT) +indir$(RTL_GLS_DIR)/rdt/outputs $(RTL_GLS_DIR)/rdt/outputs/*.final.vg -v $(LIB_1271_DIR)/ln/b12_ln_core.v -v $(LIB_1271_DIR)/ln/b12_ln_core_udp.v -v $(LIB_1271_DIR)/un/b12_un_core.v -v $(LIB_1271_DIR)/un/b12_un_core_udp.v -v $(LIB_1271_DIR)/nn/b12_nn_core.v -v $(LIB_1271_DIR)/nn/b12_nn_core_udp.v -v $(LIB_1271_DIR)/primitives/b12_primitive_verilog.v +notimingcheck +delay_mode_zero; else $(MAKE) build -C $(RTL_ROOT_DIR);  fi

	if [ $(EP_TYPE) == 1 -o $(MIXED_EP_TYPE) == 1 -o $(MIXED_EP_SPEC) == 1 ]; then $(MAKE) build-ep -C $(RTL_ROOT_DIR); fi
	if [ $(MIXED_EP_SPEC) == 1 ]; then $(MAKE) build-ep -C ../lib/ip-iosf-sideband-endpoint-2010ww46/source/rtl ; fi
	$(MAKE) build -C $(CCU_VC_HOME)
	$(MAKE) build -C $(PGCB_VC_HOME)
	$(MAKE) build -C $(OOB_VC_HOME)
#	$(MAKE) build -C $(JTAG_VC_HOME)
	$(MAKE) build -C $(VC_DIR)/tb
	$(MAKE) build -C $(VC_DIR)/compmon
	$(MAKE) build -C $(VC_DIR)/tb/intf

	@echo "Completed compile for common components"

libxml: COMPILER = vlogan
libxml: VLOG_WORK = sbc_common_lib
libxml: VLOG_ARGS = $(VLOGAN_ARGS)
libxml: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT)
libxml: setup_env
	$(MAKE) build -C $(VC_DIR)/ovmlib
	$(MAKE) build -C $(SV_UTIL_ROOT)	

# standard testbench
questa: COMPILER = vlog
questa: cmpltimeparser_$(NETWORK) .tb_$(NETWORK).ts 
	vsim $(VSIM_ARGS) $(TB_ARGS) \
	-L $(VLOG_WORK_MSIM) \
	-lib $(MSIM_NETBATCH_LIB) \
	-do misc/startup.do -l $(LOG)
	rm -Rf $(MSIM_NETBATCH_LIB)

questa-batch: COMPILER = vlog
questa-batch: cmpltimeparser_$(NETWORK) .tb_$(NETWORK).ts 
	vsim $(VSIM_ARGS) $(TB_ARGS) \
	-L $(VLOG_WORK_MSIM) \
	-lib $(MSIM_NETBATCH_LIB) \
	-c -do "$(MSIM_COV_SAVE) do misc/startup_batch.do" \
	-assertdebug -l log/${TOP}_$(SEED)_$(TEST).log \
	-wlf log/${TOP}_$(SEED)_$(TEST).wlf
	rm -Rf $(MSIM_NETBATCH_LIB)

.tb_$(NETWORK).ts: prep-questa
	mkdir -p $(MSIM_NETBATCH_LIB)
	mkdir -p $(ROOT)/bin
	if [ ! -e $(MSIM_NETBATCH_LIB)/_info  ]; then vlib $(MSIM_NETBATCH_LIB); fi
	vlog $(VLOG_ARGS_DUT) -work $(MSIM_NETBATCH_LIB) \
	-L $(VLOG_WORK_MSIM) \
	+incdir+$(RTL_ROOT_DIR)/iosfsbc/common \
	+incdir+$(VC_DIR)/tb/ip_vc \
	$(VC_DIR)/tb/intf/iosfsb_ep_mon.sv \
	+incdir+$(VC_DIR)/tb/common \
	+incdir+$(VC_DIR)/tb/intf \
	${ROOT}/../tb/iosf_sb_ti.sv \
	${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/sbr_ti.sv \
        ${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/iosf_$(NETWORK)_ti.sv \
	${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/iosf_$(NETWORK)_ti_ph2.sv \
	${ROOT}/../tb/top_tb/$(NETWORK)/*.sv


#For VCS
# top-level testbench and router RTL
.sbc_top_tb_lib_$(NETWORK): VLOG_WORK = $(NETWORK)_lib
.sbc_top_tb_lib_$(NETWORK): setup_env $(wildcard ../tb/top_tb/{NETWORK}/*.sv)
	vlogan \
	$(VLOGAN_ARGS) \
	+incdir+${ROOT}/$(RTL_ROOT_DIR)/iosfsbc/common \
	+incdir+$(VC_DIR)/tb/ip_vc \
	$(VC_DIR)/tb/intf/iosfsb_ep_mon.sv \
	+incdir+$(VC_DIR)/tb/common \
	+incdir+$(VC_DIR)/tb/clk_rst_vc \
	+incdir+$(VC_DIR)/tb/intf \
	$(VC_DIR)/tb/clk_rst_vc/clk_rst_ti.sv \
	${ROOT}/../tb/iosf_sb_ti.sv \
	${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/sbr_ti.sv \
        ${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/iosf_$(NETWORK)_ti.sv \
	${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/iosf_$(NETWORK)_ti_ph2.sv \
	${ROOT}/../tb/top_tb/${NETWORK}/*.sv	

# simv executable for this network
$(BINDIR)/simv_$(NETWORK): setup_env .sbc_top_tb_lib_$(NETWORK)
	mkdir -p $(BINDIR)
	vcs \
	$(VCS_COMPILE_ARGS) \
	$(TOP) \
	-Mdir=$(BINDIR)/csrc_$(NETWORK) \
	-o $(BINDIR)/simv_$(NETWORK)

# overall vcs target
vcs: COMPILER = vlogan
vcs: VLOG_WORK = sbc_common_lib
vcs: VLOG_ARGS = $(VLOGAN_ARGS)
vcs: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT)
vcs: ../tb/top_tb/$(NETWORK)/tb_$(NETWORK).sv setup_env prep vcs-test-cmpl_$(NETWORK) $(BINDIR)/simv_$(NETWORK)
	$(BINDIR)/simv_$(NETWORK) \
	$(VCS_ARGS) $(TB_ARGS) \
	-l log/$(TOP)_$(SEED)_$(TEST).log 
	rm -Rf $(BINDIR)
	@echo "set NETWORK=$(NETWORK)" > verdi_header
	if [  -e verdi_script  ]; then rm -f verdi_script ;  fi
	@echo "if (  -f  $(PWD)/log/$(TOP)_$(SEED)_$(TEST).fsdb ) then "  > verdi_script
	@echo "verdi -top $(TOP) -ssf $(PWD)/log/$(TOP)_$(SEED)_$(TEST).fsdb"  >> verdi_script
	@echo "else " >> verdi_script
	@echo "echo \"FSDB Error: File  $(PWD)/log/$(TOP)_$(SEED)_$(TEST).fsdb is missing\" " >> verdi_script
	@echo "echo \"FSDB Error: Please re-run the Makefile\" " >> verdi_script
	@echo "echo \"FSDB Error:        make vcs FSDB=1 INT=0 TEST=$(TEST) SEED=$(SEED) \" " >> verdi_script
	@echo "endif " >> verdi_script
	chmod +x verdi_header
	chmod +x verdi_script



# target to compile router tests
vcs-test-cmpl_$(NETWORK): VLOG_WORK = $(NETWORK)_testlib
vcs-test-cmpl_$(NETWORK): setup_env cmpltimeparser_$(NETWORK)
	vlogan \
	$(VLOGAN_ARGS) \
	+incdir+$(VC_DIR)/tb/common \
	+incdir+$(VC_DIR)/tb/clk_rst_vc \
	+incdir+$(VC_DIR)/tb/seq_lib \
	+incdir+../tests/rtr_tests \
	+incdir+../tb/intf \
	+incdir+../tb/env/$(NETWORK) \
	+incdir+../tb/top_tb/$(NETWORK) \
	../tb/intf/sbr_mbp_intf.sv \
	../tb/intf/sbr_par_intf.sv \
	../tests/rtr_tests/iosfsbm_rtr_tests_pkg.sv 

# target to generate static config object
cmpltimeparser_$(NETWORK): 
	mkdir -p ../tb/env/$(NETWORK) 
	if [ $(USE_CMPLTIME_XMLPARSER) == 1 -a ! -e  ../tb/env/$(NETWORK)/staticNetworkConfig.svh ]; then \
	../scripts/source/genSbrConfig/genSbrConfig \
	-template ../scripts/source/genSbrConfig/staticNetworkConfig_tmpl.svh \
	-outdir ../tb/env/$(NETWORK) ../tests/networks/$(NETWORK).xml; \
	fi

# separate prep operation for VCS batch processing.
vcs-prep: COMPILER = vlogan
vcs-prep: VLOG_WORK = sbc_common_lib
vcs-prep: VLOG_ARGS = $(VLOGAN_ARGS)
vcs-prep: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT)
vcs-prep: setup_env prep

# overall vcs target for vcs batch processing
vcs-batch: COMPILER = vlogan
vcs-batch: VLOG_WORK = sbc_common_lib
vcs-batch: VLOG_ARGS = $(VLOGAN_ARGS)
vcs-batch: VLOG_ARGS_DUT = $(VLOGAN_ARGS_DUT)
vcs-batch: setup_env prep vcs-test-cmpl-batch_$(NETWORK) batch_$(BINDIR)/simv_$(NETWORK)
	$(BINDIR)/simv_$(NETWORK) \
	$(VCS_ARGS) $(TB_ARGS) \
	-l log/$(TOP)_$(SEED)_$(TEST).log 
	rm -Rf $(BINDIR)

# simv executable for this network for vcs batch processing
batch_$(BINDIR)/simv_$(NETWORK): VCS_BATCH_TMP_DIR = $(ROOT)/../sim_$(NETWORK)_$(TEST)_$(SEED) 
batch_$(BINDIR)/simv_$(NETWORK): setup_env tb-top-cmpl-$(NETWORK)
	mkdir -p $(BINDIR)
	mkdir -p $(VCS_BATCH_TMP_DIR); 
	cd $(VCS_BATCH_TMP_DIR); 
	vcs \
	$(VCS_COMPILE_ARGS) \
	$(TOP) \
	-Mdir=$(BINDIR)/csrc_$(NETWORK) \
	-o $(BINDIR)/simv_$(NETWORK)
	rm -rf $(VCS_BATCH_TMP_DIR);

# test compile for vcs batch processing
vcs-test-cmpl-batch_$(NETWORK): VLOG_WORK = $(NETWORK)_testlib
vcs-test-cmpl-batch_$(NETWORK): setup_env
	vlogan \
	$(VLOGAN_ARGS) \
	+incdir+$(VC_DIR)/tb/common \
	+incdir+$(VC_DIR)/tb/seq_lib \
	+incdir+$(VERIF_ROOT)/tests/rtr_tests \
	+incdir+$(VERIF_ROOT)/tb/intf \
	+incdir+../tb/env/$(NETWORK) \
	+incdir+../tb/top_tb/$(NETWORK) \
	../tb/intf/sbr_mbp_intf.sv \
	../tb/intf/sbr_par_intf.sv \
	../tests/rtr_tests/iosfsbm_rtr_tests_pkg.sv 

# compile top level tb for VCS batch processing
tb-top-cmpl-$(NETWORK): VLOG_WORK = $(NETWORK)_lib
tb-top-cmpl-$(NETWORK): setup_env 
	vlogan \
	$(VLOGAN_ARGS) \
	+incdir+${ROOT}/$(RTL_ROOT_DIR)/iosfsbc/common \
	+incdir+$(VC_DIR)/tb/ip_vc \
	$(VC_DIR)/tb/intf/iosfsb_ep_mon.sv \
	+incdir+$(VC_DIR)/tb/common \
	+incdir+$(VC_DIR)/tb/intf \
	$(VC_DIR)/tb/clk_rst_vc/clk_rst_ti.sv \
	${ROOT}/../tb/iosf_sb_ti.sv \
	${ROOT}/../tb/top_tb/${NETWORK}/TestIsland/sbr_ti.sv \
        ${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/iosf_$(NETWORK)_ti.sv \
	${ROOT}/../tb/top_tb/$(NETWORK)/TestIsland/iosf_$(NETWORK)_ti_ph2.sv \
	${ROOT}/../tb/top_tb/${NETWORK}/*.sv

# clear any existing sim setup.
# create a sim setup file for each simulation separately to avoid conflicts.
setup_env:
	@mkdir -p $(BINDIR)
	@rm -Rf $(BINDIR)/*
	@rm -f $(SYNOPSYS_SIM_SETUP)
	@echo "sbc_common_lib : $(ROOT)/bin/vsimlib" >> $(SYNOPSYS_SIM_SETUP);
	@echo "WORK > $(NETWORK)_lib" >> $(SYNOPSYS_SIM_SETUP)
	@echo "$(NETWORK)_lib : $(BINDIR)/$(NETWORK)_lib" >> $(SYNOPSYS_SIM_SETUP)
	@echo "$(NETWORK)_testlib : $(BINDIR)/$(NETWORK)_testlib" >> $(SYNOPSYS_SIM_SETUP)
	@echo "XLRM_PACKAGE_IMPORT_COMPAT=TRUE" >> $(SYNOPSYS_SIM_SETUP)

ifeq ($(UPF),1)
	@echo "UPF  : $(VCS_HOME)/suse64/packages/upf" >> $(SYNOPSYS_SIM_SETUP)
	@echo "LPA  : $(VCS_HOME)/suse64/packages/lpa" >> $(SYNOPSYS_SIM_SETUP)
	@echo "set_design_top $(TOP)" >$(BINDIR)/containertr.upf
	@echo "load_upf ${ROOT}/../../tools/upf/router/${NETWORK}_top.upf" >>$(BINDIR)/containertr.upf
endif


clean: 
	$(MAKE) clean -C $(VC_DIR)/tb
	$(MAKE) clean -C ../tests
	$(MAKE) clean -C $(VC_DIR)/compmon
	$(MAKE) clean -C $(VC_DIR)/tb/intf
	$(MAKE) clean -C $(RTL_ROOT_DIR)
#	$(MAKE) clean -C $(JTAG_VC_HOME)
	if [ -d $(CCU_VC_HOME)  ]; then $(MAKE) clean -C $(CCU_VC_HOME); $(MAKE) clean -C $(OOB_VC_HOME);  fi
	rm -f $(CCU_VC_HOME)/.vlogansetup*

	if [ -d $(PGCB_VC_HOME)  ]; then $(MAKE) clean -C $(PGCB_VC_HOME); fi
	rm -f $(PGCB_VC_HOME)/.vlogansetup*

	rm -fR *.rpt *.log router.* *.fsdb
	rm -Rf bin
	rm -Rf transcript* 
	rm -Rf  *wlf* 
	rm -Rf graph.* 
	rm -Rf .tb*.ts
	rm -Rf simv*
	rm -Rf csrc*
	rm -Rf core
	rm -f .vcsmx_rebuild
	rm -f .sbc_*
	rm -f inter.vpd
	rm -f ucli.key
	rm -f vcs.key
	rm -Rf DVEfiles
	rm -Rf 64
	rm -rf AN.DB
	mkdir -p bin
	rm -rf ../tb/env/*
	rm -f verdi_header
	rm -f verdi_script
	rm -f regress_list

cleanall: clean
	$(MAKE) clean -C $(VC_DIR)/ovmlib
	$(MAKE) clean -C $(SV_UTIL_ROOT)
	find log -name '*.log' -exec rm {} \;
	find log -name '*.nblog' -exec rm {} \;
	rm -rf *.gif *.svg
	rm -f *.dot
	rm -rf ../lib/ip-iosf-sideband-endpoint-2010ww46
	rm -rf mvsim_native_reports
	rm -f ../../unsupported/gen/sbccfg
	rm -f ../../tools/upf/router/*.upf
	rm -f .vlogansetup.args
	rm -f .vlogansetup.env
	rm -rf ../sim_lv?_*
ifeq ($(DYNAMO),0)
	rm -f ../../unsupported/gen/sbccfg
	rm -f ../../tools/upf/router/*.upf
endif

# Should be removed somewhere, maybe not here?
# rm -f ../../tools/upf/router/*.upf

visual:
	neato -T${TYPE} $(NETWORK)_graph.dot -o $(NETWORK)_graph.${TYPE}
	firefox $(NETWORK)_graph.${TYPE}

