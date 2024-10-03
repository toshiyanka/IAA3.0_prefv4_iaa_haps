ifeq ($(CRB),) # use shell value, if set; otw use := so we only call cth_query once
   export CRB := $(shell cth_query -tool crb params crb_path -resolve)
endif

ifeq ($(DUT),)   #If we don't do this CRB will assume repo directory name
   export DUT=icxl_vc
endif
export TOP_MODULE=top

include $(CRB)/Makefile.crb

.DEFAULT_GOAL := all
.PHONY: all slang

all: slang

slang:
	@cd ${WORKAREA} && /p/acd/proj/vte/bin/ext_tools/slang/latest/slang \
	--error-limit=1000 \
	-Wextra -Wno-width-trunc \
	-DDO_NOT_USE_VPI \
	-DDO_NOT_USE_SM \
	-DOVM_NO_STACKTRACE \
	-DINTEL_SIMONLY \
	-DINTEL_INST_ON \
	-DDEVTLB_COVER_EN \
	-DDEVTLB_EXT_RF_EN \
	-DDEVTLB_INFO_MSG_OFF \
	-DXPROP \
	-DUVM \
	-I${WORKAREA}/subip/vip/saola/verilog \
	-I${WORKAREA}/subip/vip/saola/verilog_uvm \
	-I${WORKAREA}/subip/vip/uvm/src \
	-I${WORKAREA}/src/rtl/params \
	-I${WORKAREA}/src/rtl/devtlb \
	-I${WORKAREA}/src/val/scoreboard \
	-I${WORKAREA}/src/val/tb/ti \
	-I${WORKAREA}/src/val/tb/bfm \
	-I${WORKAREA}/src/val/tb/env \
	-I${WORKAREA}/src/val/tb/sequences \
	-I${WORKAREA}/src/val/tb/wrappers \
	-I${WORKAREA}/src/val/fpv/src \
	-I${WORKAREA}/src/val/tb/wrappers \
	-I${WORKAREA}/src/val/tb/wrappers/eip \
	-I${WORKAREA}/src/val/tb/wrappers/gnr-d/tip \
	-I${WORKAREA}/src/val/tb/wrappers/lnl/ipu \
	-I${WORKAREA}/src/val/tb/wrappers/lnl/vpu \
	-I${WORKAREA}/src/val/tb/tests/base \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_cbfifo_stall \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_err_injection \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_flr \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_flr_long \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_flr_errs \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_fulltrk \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_invreq_basic \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_invreq_conflict \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_invreq_deadlock \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_invreq_errs \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_invreq_full \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_invreq_stress \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_perf_basic \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_perf_hit \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_rand \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_rand_errs \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_smoke \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_way_eviction \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_xreq_basic \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_xreq_errs \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_xreq_rr \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_xreq_rw \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_xreq_stress \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_xreq_wr \
	-I${WORKAREA}/src/val/tb/tests/functional/devtlb_xreq_ww \
	${WORKAREA}/subip/vip/uvm/src/uvm_pkg.sv \
	${WORKAREA}/subip/vip/saola/verilog/sla_pkg.sv \
	${WORKAREA}/src/val/fpv/src/devtlb_compmon.sv \
	${WORKAREA}/src/val/scoreboard/devtlb_sig_if.sv \
	${WORKAREA}/src/val/scoreboard/DevTlbScoreboardPkg.sv \
	${WORKAREA}/src/val/tb/ti/DEVTLB.sv \
	${WORKAREA}/src/val/tb/ti/devtlb_clkgen_if.sv \
	${WORKAREA}/src/val/tb/ti/devtlb_tb_if.sv \
	${WORKAREA}/src/val/tb/ti/devtlb_ti.sv \
	${WORKAREA}/src/val/tb/bfm/DevTlbAgentPkg.sv \
	${WORKAREA}/src/val/tb/env/DevTlbEnvPkg.sv \
	${WORKAREA}/src/val/tb/sequences/DevTlbSeqPkg.sv \
	${WORKAREA}/src/val/tb/tests/base/DevTlbTestPkg.sv \
	${WORKAREA}/src/val/tb/wrappers/devtlb_vram2dq.sv \
	${WORKAREA}/src/val/tb/wrappers/top_devtlb.sv \
	${WORKAREA}/src/rtl/devtlb/devtlb.sv \
	/p/hdk/cad/ctech/c4v20ww51e_hdk162/source/v/ctech_lib_clk_and_en.sv \
	/p/hdk/cad/ctech/c4v20ww51e_hdk162/source/v/ctech_lib_clk_gate_te.sv \
	/p/hdk/cad/ctech/c4v20ww51e_hdk162/source/v/ctech_lib_clk_gate_te_rstb.sv \
	/p/hdk/cad/ctech/c4v20ww51e_hdk162/source/v/ctech_lib_mux_2to1.sv


