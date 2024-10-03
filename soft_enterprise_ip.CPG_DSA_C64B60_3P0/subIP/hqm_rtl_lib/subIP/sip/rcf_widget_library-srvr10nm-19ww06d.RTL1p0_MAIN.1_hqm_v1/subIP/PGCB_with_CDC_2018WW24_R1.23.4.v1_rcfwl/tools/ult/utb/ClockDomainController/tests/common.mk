MAKEFLAGS += -rR --no-print-directory

TESTNAME := $(shell basename $$PWD)
#$(info Testname: $(TESTNAME))

TESTDIR := $(shell pwd)
#$(info Testdir: $(TESTDIR))

OUTDIR := ../../sim_res/$(TESTNAME)
OUTPUTS := $(OUTDIR)/simv
INPUTS := $(TESTNAME).svh $(TESTNAME).jvh

DUTNAME := ClockDomainController
DUT_TOP_FILE := ../../../../../../src/rtl/ClockDomainController/ClockDomainController.sv 

.PHONY: all
all: run

# Common set.  Per-test specified in test Makefile.
SIM_CMD  := vcs
SWITCHES := -lca
SWITCHES += -sverilog
SWITCHES += -timescale=1ps/1ps
SWITCHES += -debug_all
SWITCHES += +define+VCSSIM
SWITCHES += $(VCS_SWITCH)


VB = @
ifneq ($(QUIET), 1)
    VB =
endif

ifeq ($(INTEL_SVA_OFF), 1)
    SWITCHES += +define+INTEL_SVA_OFF
endif

ifneq ($(XPROP_OFF), 1)
    SWITCHES += -xprop=../../sim_tb/tb/xprop.ClockDomainController.cfg
endif

CLN_LIST := vc_hdrs.h cm.log csrc simv.daidir ucli.key
ifeq ($(NOCLEAN), 1)
    CLN_LIST := vc_hdrs.h
endif

SWITCHES += -ntb_opts ext+sv_fmt
SWITCHES += -cm line+cond+fsm+path+branch+tgl+assert -cm_tgl mda -assert svaext -assert enable_diag -assert dve
SWITCHES += +define+TESTNAME=$(TESTNAME)
SWITCHES += -o $(OUTPUTS)

TB_INCDIRS += +incdir+../../tests/$(TESTNAME)
TB_INCDIRS += +incdir+../../sim_tb/tb
TB_INCDIRS += +incdir+../../sim_tb/inc

DUT_DEFS := +define+SVA_LIB_SVA2005
DUT_DEFS += +define+INSTANTIATE_HIERDUMP

DUT_INCDIRS := ../../../../../../src/rtl/ClockDomainController

DUT_INCFILES := ../../../../../../src/rtl/ClockDomainController/ClockDomainController.sva
DUT_INCFILES += ../../../../../../src/rtl/ClockDomainController/CdcPgClock.sva
DUT_INCFILES += ../../../../../../src/rtl/ClockDomainController/CdcMainClock.sva

LIB_DIRS := ../../../../../../../../../../../../site/disks/hdk.cad.2/linux_2.6.16_x86-64/ctech/c2v16ww27e_hdk136/source/v
LIB_DIRS += ../../../../../../src/rtl/ClockDomainController
LIB_DIRS += ../../sim_tb/inc
LIB_EXTS := +libext+.sv
DUT_FILES := ../../../../../../src/rtl/common/pgcb_ctech_map.sv


TB_FILE := ../../sim_tb/tb/tb.sv

RUNSWITCH := -ucli -do $(TESTNAME).do -cm line+cond+fsm+path+branch+tgl+assert $(SIMV_ARGS)

# Rules used across all tests.
$(TESTNAME).jvh:
    #JGTASK_TCL=$(TESTDIR)/$(DUTNAME).tcl; export JGTASK_TCL; cd ../../jg_tb/bin && jg -allow_unsupported_OS -batch $(DUTNAME).tcl
	$(VB)test -f $@ || touch $@

.PHONY : build
build : $(OUTPUTS)
$(OUTPUTS): $(INPUTS) $(DUT_FILES) $(TB_FILE) $(DUT_INCFILES)
	$(VB)mkdir -p $(OUTDIR) && cd $(OUTDIR) && $(SIM_CMD) $(SWITCHES) $(DUT_DEFS) $(addprefix +incdir+, $(DUT_INCDIRS)) \
            $(TB_INCDIRS) $(addprefix -y , $(LIB_DIRS)) $(LIB_EXTS) $(DUT_FILES) $(DUT_TOP_FILE) $(TB_FILE) \
            -top tb > $(TESTNAME).log 2>&1 

.PHONY : run
run : $(OUTPUTS)
	$(VB)cd $(OUTDIR) && rm -f $(TESTNAME).pass $(TESTNAME).fail
	$(VB)cd $(OUTDIR) && cp ../../tests/$(TESTNAME)/$(TESTNAME).do $(TESTNAME).do
	$(VB)cd $(OUTDIR) && echo "run; exit" >> $(TESTNAME).do
	$(VB)cd $(OUTDIR) && $(OUTPUTS) $(RUNSWITCH) >> $(TESTNAME).log 2>&1 && grep -q "ERROR:" $(TESTNAME).log && \
                                  { echo "Test Status $(TESTNAME): FAIL"; ln -sf $(TESTNAME).log $(TESTNAME).fail; exit 1; } || \
                                  { echo "Test Status $(TESTNAME): PASS" ; ln -sf $(TESTNAME).log $(TESTNAME).pass ; }
	$(VB)cd $(OUTDIR) && ln -sf ../../sim_tb/tb && ln -sf ../../tests/$(TESTNAME)
	$(VB)cd ../../tests/$(TESTNAME) && ln -sf $(OUTDIR) result
	$(VB)cd $(OUTDIR) && test -f $(TESTNAME).pass && rm -rf $(CLN_LIST)
	$(VB)cd $(OUTDIR) && test -f $(TESTNAME).fail && rm -rf simv.vdb || true

.PHONY : run_gui
run_gui: $(OUTPUTS)
	$(VB)cd $(OUTDIR) && rm -f $(TESTNAME).pass $(TESTNAME).fail
	$(VB)cd $(OUTDIR) && cp ../../tests/$(TESTNAME)/$(TESTNAME).do $(TESTNAME).do
	$(VB)cd $(OUTDIR) && echo 'dump -add { tb } -depth 0 -aggregates -scope ".";#add_wave tb.* -new -group tbSignals' >> $(TESTNAME).do
	$(VB)cd $(OUTDIR) && $(OUTPUTS) $(RUNSWITCH) -gui >> $(TESTNAME).log 2>&1 && grep -q "ERROR:" DVEfiles/dve_gui.log && \
                                  { echo "Test Status $(TESTNAME): FAIL"; ln -sf $(TESTNAME).log $(TESTNAME).fail; exit 1; } || \
                                  { echo "Test Status $(TESTNAME): PASS" ; ln -sf $(TESTNAME).log $(TESTNAME).pass ; }
	$(VB)cd $(OUTDIR) && ln -sf ../../sim_tb/tb && ln -sf ../../tests/$(TESTNAME)
	$(VB)cd ../../tests/$(TESTNAME) && ln -sf $(OUTDIR) result
	$(VB)cd $(OUTDIR) && test -f $(TESTNAME).pass && rm -rf $(CLN_LIST)
	$(VB)cd $(OUTDIR) && test -f $(TESTNAME).fail && rm -rf simv.vdb || true

.PHONY : clean
clean:
	$(VB)rm -rf $(OUTDIR)
	$(VB)touch $(TESTNAME).jvh

.PHONY : run_jg
run_jg:
	$(VB)cd ../../jg_tb/bin; jg -allow_unsupported_OS $(DUTNAME).tcl &

.PHONY : elab_dut
elab_dut:
	$(VB)cd ../../sim_tb/tb; vcs -sverilog -f ../../dut_inf/list/2222 10664 10245 3978 3768 3766 3308 2845 2423 2222 2053 1941 1880 1704 1692 1680 1258DUTNAME).f $(SWITCHES) &

