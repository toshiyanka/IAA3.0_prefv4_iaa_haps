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

lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt/v/ln
#lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt/v/wn
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt/v/nn
#lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/f05/14ww35.1_f05_a.0.p1_dmdsoc/v/primitives

#set G_STD_CELL_VERILOG ""
#lappend G_STD_CELL_VERILOG e05_ln_core.v
#lappend G_STD_CELL_VERILOG e05_nn_core.v
#lappend G_STD_CELL_VERILOG e05_nn_primitive_verilog.v

# TAR libraries
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt/lib/ln/
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt/lib/nn
lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt/lib/wn

set G_STD_CELL_LIBS ""
lappend G_STD_CELL_LIBS e05_ln_p1274d0_tttt_v065_t100_max.lib 
lappend G_STD_CELL_LIBS e05_ln_p1274d0_tmin_v065_t100_min.lib 
lappend G_STD_CELL_LIBS e05_ln_p1274d1_tttt_v065_t100_max.lib 
lappend G_STD_CELL_LIBS e05_ln_p1274d0_tmin_v065_t100_min.lib 
lappend G_STD_CELL_LIBS e05_ln_p1274d0_tttt_v065_to_v065_t100_max.lib 
lappend G_STD_CELL_LIBS e05_ln_p1274d0_tmin_v065_to_v065_t100_min.lib 
lappend G_STD_CELL_LIBS e05_nn_p1274d0_tttt_v065_t100_max.lib 
lappend G_STD_CELL_LIBS e05_nn_p1274d0_tmin_v065_t100_min.lib 
lappend G_STD_CELL_LIBS e05_nn_p1274d1_tttt_v065_t100_max.lib 
lappend G_STD_CELL_LIBS e05_nn_p1274d0_tmin_v065_t100_min.lib 
lappend G_STD_CELL_LIBS e05_nn_p1274d0_tttt_v065_to_v065_t100_max.lib 
lappend G_STD_CELL_LIBS e05_nn_p1274d0_tmin_v065_to_v065_t100_min.lib 

#this echo line will fail DUET
#echo "add_search_path '$G_LIB_SEARCH_PATH' -library -both" >> FEV_dofile.tcl
add_search_path $G_LIB_SEARCH_PATH -library -both
