
## Start from scratch whenever reloading file
clear -all

## Include Intel libs & set up standard env
## Redirects IJL into a variable to avoid junk in log
redirect -variable xtmp "include $env(IJL_ROOT)/intel_jg_lib.tcl"
ijl_set_standard_intel_env

## Set top level module for verification
set dut hqm_AW_fifo_control
set top hqm_AW_fifo_control_tb

## Compile commands.  'analyze' options are very project specific.
ijl_analyze             \
        +incdir+../../../../../src/rtl/sva_lib \
        -y ../../../../../src/rtl/sva_lib \
	+define+FPV          \
	+define+SVA_LIB_COVER_ENABLE \
	+define+ASSERT_ON \
         \
  +incdir+. -y . +libext+.sv \
  -y /p/hdk/rtl/cad/x86-64_linux26/synopsys/designcompiler/J-2014.09-SP5/dw/sim_ver \
  +incdir+/p/hdk/rtl/cad/x86-64_linux26/synopsys/designcompiler/J-2014.09-SP5/dw/sim_ver \
  -y /p/com/eda/synopsys/vcsmx/J-2014.12-SP3-B-1/packages/sva \
  +incdir+/p/com/eda/synopsys/vcsmx/J-2014.12-SP3-B-1/packages/sva \
  ../../src/rtl/hqm_AW_pkg.sv ../../src/rtl/${dut}.sv hqm_AW_fifo_control_assert.jg.sv

ijl_elaborate -top $top 

## bothEdges and inputChangeBothEdges needed iff latch-based design
clock clk 

reset -expression ~rst_n

# Simplify analysis by keeping data quiet until 3 cycles after reset
#assume -name {::fifo_push_constraint} -env {~(fifo_full&push)} -type {temporary} -update_db;
#assume -name {::fifo_pop_constraint} -env {~(fifo_empty&pop)} -type {temporary} -update_db;

## Choose netbatch or local mode
## ijl_set_netbatch_mode {pdx_dts /asvs/asvs SLES_EM64T_16G 4}
ijl_set_local_mode {1}

# Check that clocks, resets, etc. are reasonable
sanity_check -analyze all -verbose

## BMC.  If we set the length to 0, we are going for full proof.
set_max_trace_length 100

# setup engines to run
set_engine_mode {Hp Ht J L B K AB AD N AM G C AG G2 C2}







