
# ..........FEV_SETUP..............

vpxmode
reset
set system mode setup
set flatten model -nodff_to_dlat_zero
set flatten model -nodff_to_dlat_feedback
set flatten model -latch_fold
set flatten model -seq_constant
set flatten model -GATED_Clock
set flatten model -seq_constant_feedback
set flatten model -balanced_modeling
set flatten model -seq_constant_x_to 0
set flatten model -LATCH_Transparent
set flatten model -nodff_to_dlat_zero
set flatten model -nodff_to_dlat_feedback
set flatten model -map
vpx set flatten model -gated_clock
vpx set analyze option -AUTO
add_search_path '/p/kits/intel/p1273/p1273_1.7.0/stdcells/d04/default/latest/lib/wn /p/kits/intel/p1273/p1273_1.7.0/stdcells/d04/default/latest/lib/ln /p/kits/intel/p1273/p1273_1.7.0/stdcells/d04/default/latest/lib/nn ./scripts ./inputs/pla' -library -both

#........Reading libray files..........


#.........Souring the PRE.read_lib.tcl Override.........
dofile ./scripts/PRE.read_lib.tcl
vpx read library d04_ln_1273_1x1r3_tttt_v075_t70_max.lib d04_wn_1273_1x1r3_tttt_v075_t70_max.lib d04_nn_1273_1x1r3_tttt_v075_t70_max.lib -liberty -nosensitive -both -pg_pin

#........Reading Golden design..........

vpx set undefined cell black_box -golden
vpx add search path /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/include/assertions -golden
vpx add search path /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/include -golden
vpx add search path /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/subIP/DfxSecurePlugin/source/rtl/include/assertions -golden
vpx add search path /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/subIP/DfxSecurePlugin/source/rtl/include -golden
vpx read design /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/cltapc.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_exi.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_fsm.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_irreg.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_irdecoder.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_decoder.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_drreg.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_data_reg.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_tdomux.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_glue.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_bscan.sv /p/com/eda/intel/ctech/v14ww36e/source/p1273/d04/nn/ctech_lib_clk_buf.v /p/com/eda/intel/ctech/v14ww36e/source/p1273/d04/nn/ctech_lib_dq.v /p/com/eda/intel/ctech/v14ww36e/source/p1273/d04/nn/ctech_lib_clk_gate_te.v /p/com/eda/intel/ctech/v14ww36e/source/p1273/d04/nn/ctech_lib_clk_mux_2to1.v /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/subIP/DfxSecurePlugin/source/rtl/dfxsecure_plugin/cltapc_dfxsecure_plugin.sv /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/source/rtl/cltapc/mtap_tapnw.sv -systemverilog -noelaborate -golden -define SYNTH_D04 
vpx elaborate design -golden
vpx set root module cltapc -golden

#........Reading Revised design..........

vpx set undefined cell black_box -revised
vpx read design /nfs/iind/disks/mg_disk0866/vsavitrx/ip-master-tap_cnplp/tools/syn/CNPLP/cltapc/outputs/cltapc.syn_final.vg -systemverilog -noelaborate -revised -define SYNTH_D04 
vpx elaborate design -revised
vpx set root module cltapc -revised

#........Setting up mapping ..........

vpx uniquify -nolib -all
vpx add renaming rule -PIN_MULTIDIM_TO_1DIM

#.........Souring the pin_constraints.tcl Override.........
dofile ./scripts/pin_constraints.tcl
vpx report black box -detail
vpx set mapping method -nophase -BBOX_NAME_MATCH -name only -nounreach

#........verify..........


#.........Souring the PRE.verify.tcl Override.........
dofile ./scripts/PRE.verify.tcl
vpx set system mode lec
vpx map key points
vpx analyze setup -verbose
vpx add compared points -all
vpx compare -threads 4
vpx analyze abort -compare -threads 4
