add_notranslate_modules *c73* -both
add_notranslate_modules *irf* -both
add_notranslate_modules *ip73* -both
add_notranslate_modules *isr73* -both
add_notranslate_modules *rf_tp* -both
add_notranslate_modules *zprrnga* -both
delete_notranslate_modules *dfx_wrapper* -both
delete_notranslate_modules *family* -both
delete_notranslate_modules *family_map* -both
delete_notranslate_modules *MSWT_WRP* -both

lappend G_LIB_SEARCH_PATH /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/v/ln
#lappend G_LIB_SEARCH_PATH /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/v/wn
lappend G_LIB_SEARCH_PATH /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/v/nn
#lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/f05/14ww35.1_f05_a.0.p1_dmdsoc/v/primitives

#set G_STD_CELL_VERILOG ""
#lappend G_STD_CELL_VERILOG e05_ln_core.v
#lappend G_STD_CELL_VERILOG e05_nn_core.v
#lappend G_STD_CELL_VERILOG e05_nn_primitive_verilog.v

# TAR libraries
lappend G_LIB_SEARCH_PATH /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln
lappend G_LIB_SEARCH_PATH /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn
lappend G_LIB_SEARCH_PATH /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn

set G_STD_CELL_LIBS ""
lappend G_STD_CELL_LIBS d04_wn_1273_1x1r3_tttt_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_wn_1273_1x1r3_tttt_v115_t70_min.lib
lappend G_STD_CELL_LIBS d04_ls_wn_1273_1x1r3_tttt_v075_to_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_ls_wn_1273_1x1r3_tttt_v115_to_v115_t70_min.lib
lappend G_STD_CELL_LIBS d04_ln_1273_1x1r3_tttt_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_ln_1273_1x1r3_tttt_v115_t70_min.lib
lappend G_STD_CELL_LIBS d04_ls_ln_1273_1x1r3_tttt_v075_to_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_ls_ln_1273_1x1r3_tttt_v115_to_v115_t70_min.lib
lappend G_STD_CELL_LIBS d04_nn_1273_1x1r3_tttt_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_nn_1273_1x1r3_tttt_v115_t70_min.lib
lappend G_STD_CELL_LIBS d04_ls_nn_1273_1x1r3_tttt_v075_to_v075_t70_max.lib
lappend G_STD_CELL_LIBS d04_ls_nn_1273_1x1r3_tttt_v115_to_v115_t70_min.lib

#this echo line will fail DUET
#echo "add_search_path '$G_LIB_SEARCH_PATH' -library -both" >> FEV_dofile.tcl
add_search_path $G_LIB_SEARCH_PATH -library -both
