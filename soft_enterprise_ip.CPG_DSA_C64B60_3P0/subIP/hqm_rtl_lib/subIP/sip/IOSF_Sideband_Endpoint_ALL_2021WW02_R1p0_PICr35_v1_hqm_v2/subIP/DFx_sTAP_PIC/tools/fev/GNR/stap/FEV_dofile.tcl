
//..........FEV_SETUP..............

tclmode
reset
vpx set system mode setup
vpx set flatten model -nodff_to_dlat_zero
vpx set flatten model -nodff_to_dlat_feedback
vpx set flatten model -latch_fold
vpx set flatten model -seq_constant
vpx set flatten model -GATED_Clock
vpx set flatten model -seq_constant_feedback
vpx set flatten model -balanced_modeling
vpx set flatten model -seq_constant_x_to 0
vpx set flatten model -LATCH_Transparent
vpx set flatten model -nodff_to_dlat_zero
vpx set flatten model -nodff_to_dlat_feedback
vpx set flatten model -map
vpx set flatten model -gated_clock
vpx set analyze option -AUTO
add_search_path '/p/hdk/cad/stdcells/e05/14ww33.5_e05_c.0_cnlgt/lib/ln /p/hdk/cad/stdcells/e05/14ww33.5_e05_c.0_cnlgt/lib/nn /p/hdk/cad/stdcells/ec0/14ww36.4_ec0_c.0.p2.cnl.sdg.hip/lib/ln /p/hdk/cad/stdcells/ec0/14ww36.4_ec0_c.0.p2.cnl.sdg.hip/lib/nn /p/hdk/cad/stdcells/f05/14ww35.1_f05_a.0.p1_dmdsoc/lib/ln /p/hdk/cad/stdcells/f05/14ww35.1_f05_a.0.p1_dmdsoc/lib/nn /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/lib/ln /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/lib/nn' -library -both
vpx add search path /p/hdk/cad/stdcells/e05/14ww33.5_e05_c.0_cnlgt/lib/ln /p/hdk/cad/stdcells/e05/14ww33.5_e05_c.0_cnlgt/lib/nn /p/hdk/cad/stdcells/ec0/14ww36.4_ec0_c.0.p2.cnl.sdg.hip/lib/ln /p/hdk/cad/stdcells/ec0/14ww36.4_ec0_c.0.p2.cnl.sdg.hip/lib/nn /p/hdk/cad/stdcells/f05/14ww35.1_f05_a.0.p1_dmdsoc/lib/ln /p/hdk/cad/stdcells/f05/14ww35.1_f05_a.0.p1_dmdsoc/lib/nn /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/lib/ln /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/lib/nn -library -both

//........Reading libray files..........


//.........Souring the PRE.read_lib.tcl Override.........
if [info exists SIPFEV_READ_V] && $SIPFEV_READ_V == 1 } 
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/v/ln 
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/v/nn 
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/v/primitives 

set G_STD_CELL_VERILOG ""
lappend G_STD_CELL_VERILOG e05_ln_core.v
lappend G_STD_CELL_VERILOG e05_nn_core.v
lappend G_STD_CELL_VERILOG e05_primitive_verilog.v
} else 
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/lib/ln 
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww39.1_e05_c.0.p2_cnlgt/lib/nn 

set G_STD_CELL_LIBS ""
lappend G_STD_CELL_LIBS e05_ln_p1274d0_tttt_v065_t100_max.lib
lappend G_STD_CELL_LIBS e05_nn_p1274d1_tttt_v065_t100_max.lib
}

echo "add_search_path '$G_LIB_SEARCH_PATH' -library -both" >> FEV_dofile.tcl
add_search_path $G_LIB_SEARCH_PATH -library -both

vpx read library e05_ln_p1274d0_tttt_v065_t100_max.lib e05_nn_p1274d1_tttt_v065_t100_max.lib -liberty -nosensitive -both -pg_pin
vpx read library /p/hdk/cad/stdcells/e05/14ww33.5_e05_c.0_cnlgt/v/ln/e05_ln_core.v /p/hdk/cad/stdcells/e05/14ww33.5_e05_c.0_cnlgt/v/nn/e05_nn_core.v /p/hdk/cad/stdcells/e05/14ww33.5_e05_c.0_cnlgt/v/primitives/e05_primitive_verilog.v -verilog -define functional  -nosensitive -lastmod -both -append

//........Reading Golden design..........

vpx set undefined cell black_box -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/target/stap/CNL/aceroot/results/DC/stap/collateral/rtl -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/subIP/SIP_DFx_DFxSecurePlugin_PIC1_2015WW26_R1p0_v0/source/rtl/include -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/include -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/target/stap/CNL/aceroot/results/DC/stap/collateral/rtl -golden
vpx read design  /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/subIP/SIP_DFx_DFxSecurePlugin_PIC1_2015WW26_R1p0_v0/source/rtl/dfxsecure_plugin/stap_dfxsecure_plugin.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_fsm.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_irreg.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_irdecoder.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_drreg.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_tdomux.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_decoder.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_glue.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/ctech_lib/stap_ctech_map.sv /nfs/site/eda/data/mg_disk0993/intel/ctech/v14ww36e/common/source/v/ctech_lib_clk_buf.v /nfs/site/eda/data/mg_disk0993/intel/ctech/v14ww36e/common/source/v/ctech_lib_dq.v /nfs/site/eda/data/mg_disk0993/intel/ctech/v14ww36e/common/source/v/ctech_lib_mux_2to1.v -systemverilog -noelaborate -golden -define NO_PWR_PINS -define SVA_OFF -define SYNTHESIS 
vpx elaborate design -golden
vpx set root module stap -golden
vpx delete search path . -revised
vpx delete search path .. -revised
vpx set hdl options -include_src_dir off

//........Reading Revised design..........

vpx read design /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/target/stap/CNL/aceroot/results/DC/stap/syn/outputs/stap.syn_final.vg -verilog -revised -noelaborate
vpx elaborate design -revised
vpx set root module stap -revised

//........Setting up mapping ..........

vpx uniquify -nolib -all
vpx add renaming rule -PIN_MULTIDIM_TO_1DIM

//.........Souring the pin_constraints.tcl Override.........
vpx add pin constraints 0 test_si*  -module *  -rev
vpx add pin constraints 1 test_sei*  -module *  -rev
vpx add ignored outputs test_so*  -module *  -rev
 
vpx add pin constraints 0 *fscan_shiften              -both
vpx add pin constraints 0 *fscan_mode                 -both
vpx add pin constraints 0 *fscan_clkungate            -both
vpx add pin constraints 0 *fscan_clkungate_syn        -both
vpx add pin constraints 0 *fscan_latchopen            -both
vpx add pin constraints 0 *fscan_rstbypen*            -both
vpx add pin constraints 1 *fscan_latchclosed_b        -both
vpx add pin constraints 1 *fscan_byprst_b*            -both
 
vpx add pin constraints 0 *fscan_ram_bypsel                -both

vpx report black box -detail
vpx set mapping method -nophase -BBOX_NAME_MATCH -name only -nounreach
vpx set system mode lec
vpx map key points
vpx analyze setup -verbose
vpx usage -auto -min_command_seconds 30
vpx set verification information uvi

//........verify..........


//.........Souring the PRE.verify.tcl Override.........

vpx add compared points -all
vpx compare -threads 4
vpx analyze abort -compare -threads 4
vpx write verification information uvi
checkpoint checkpt.lec -replace
