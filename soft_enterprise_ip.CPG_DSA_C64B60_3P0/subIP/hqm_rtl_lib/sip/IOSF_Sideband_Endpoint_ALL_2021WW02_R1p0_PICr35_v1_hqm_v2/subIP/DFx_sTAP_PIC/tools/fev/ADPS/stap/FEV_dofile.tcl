
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
add_search_path '/p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn ./scripts ./inputs/pla /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/include/assertions /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/include /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/scan_clock_controller /p/com/eda/intel/ctech/v14ww19e/source/p1273/d04/wn' -library -both
vpx add search path /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn ./scripts ./inputs/pla /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/include/assertions /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/include /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/scan_clock_controller /p/com/eda/intel/ctech/v14ww19e/source/p1273/d04/wn -library -both

//........Reading libray files..........


//.........Souring the PRE.read_lib.tcl Override.........
add_notranslate_modules *c73* -both
add_notranslate_modules *irf* -both
add_notranslate_modules *ip73* -both
add_notranslate_modules *isr73* -both
delete_notranslate_modules *dfx_wrapper* -both
delete_notranslate_modules *family* -both
delete_notranslate_modules *family_map* -both
delete_notranslate_modules *MSWT_WRP* -both

if [info exists SIPFEV_READ_V] && $SIPFEV_READ_V == 1 } 
lappend G_LIB_SEARCH_PATH /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/v/wn
lappend G_LIB_SEARCH_PATH /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/v/ln
lappend G_LIB_SEARCH_PATH /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/v/nn
lappend G_LIB_SEARCH_PATH /p/com/eda/intel/ctech/v14ww19e/source/p1273/d04/wn

set G_STD_CELL_VERILOG ""
lappend G_STD_CELL_VERILOG d04_wn_core.v
lappend G_STD_CELL_VERILOG d04_wn_core_udp.v
lappend G_STD_CELL_VERILOG d04_ln_core.v
lappend G_STD_CELL_VERILOG d04_ln_core_udp.v
lappend G_STD_CELL_VERILOG d04_nn_core.v
lappend G_STD_CELL_VERILOG d04_nn_core_udp.v
} else 
lappend G_LIB_SEARCH_PATH /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn
lappend G_LIB_SEARCH_PATH /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln
lappend G_LIB_SEARCH_PATH /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn
lappend G_LIB_SEARCH_PATH ./scripts
lappend G_LIB_SEARCH_PATH ./inputs/pla
lappend G_LIB_SEARCH_PATH /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/include/assertions
lappend G_LIB_SEARCH_PATH /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/include
lappend G_LIB_SEARCH_PATH /nfs/iind/disks/mg_disk0866/skmoolax/SCC/ip-scan_clock_controller/source/rtl/scan_clock_controller
lappend G_LIB_SEARCH_PATH /p/com/eda/intel/ctech/v14ww19e/source/p1273/d04/wn

set G_STD_CELL_LIBS ""
lappend G_STD_CELL_LIBS d04_wn_1273_1x1r3_tttt_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_ln_1273_1x1r3_tttt_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_nn_1273_1x1r3_tttt_v075_t70_max.lib
}

echo "add_search_path '$G_LIB_SEARCH_PATH' -library -both" >> FEV_dofile.tcl
add_search_path $G_LIB_SEARCH_PATH -library -both

vpx read library d04_wn_1273_1x1r3_tttt_v075_t70_max.lib d04_ln_1273_1x1r3_tttt_v075_t70_max.lib d04_nn_1273_1x1r3_tttt_v075_t70_max.lib -liberty -nosensitive -both -pg_pin
vpx read library /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/v/wn/d04_wn_core.v /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/v/ln/d04_ln_core.v /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/v/nn/d04_nn_core.v /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/v/primitives/d04_primitive_verilog.v -verilog -define functional  -nosensitive -lastmod -both -append

//........Reading Golden design..........

vpx set undefined cell black_box -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/target/stap/CDF/aceroot/results/DC/stap/collateral/rtl -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/subIP/SIP_DFx_DFxSecurePlugin_PIC1_2015WW26_R1p0_v0/source/rtl/include -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/include -golden
vpx add search path /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/target/stap/CDF/aceroot/results/DC/stap/collateral/rtl -golden
vpx read design  /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/subIP/SIP_DFx_DFxSecurePlugin_PIC1_2015WW26_R1p0_v0/source/rtl/dfxsecure_plugin/stap_dfxsecure_plugin.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_fsm.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_irreg.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_irdecoder.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_drreg.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_tdomux.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_decoder.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/stap/stap_glue.sv /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/source/rtl/ctech_lib/stap_ctech_map.sv /nfs/site/disks/hdk_cad_3/cad/ctech/v15ww20e/source/v/ctech_lib_clk_buf.sv /nfs/site/disks/hdk_cad_3/cad/ctech/v15ww20e/source/v/ctech_lib_dq.sv /nfs/site/disks/hdk_cad_3/cad/ctech/v15ww20e/source/v/ctech_lib_mux_2to1.sv -systemverilog -noelaborate -golden -define NO_PWR_PINS -define SVA_OFF -define SYNTHESIS 
vpx elaborate design -golden
vpx set root module stap -golden
vpx delete search path . -revised
vpx delete search path .. -revised
vpx set hdl options -include_src_dir off

//........Reading Revised design..........

vpx read design /nfs/iind/disks/mg_disk1655/sharmavi/ww27/ip-stap/target/stap/CDF/aceroot/results/DC/stap/syn/outputs/stap.syn_final.vg -verilog -revised -noelaborate
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
