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

#RK lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww37.3_e05_c.0.p1_cnlgt/v/ln
#RK lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww37.3_e05_c.0.p1_cnlgt/v/nn
#RK lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww37.3_e05_c.0.p1_cnlgt/v/primitives
#RK 
#RK set G_STD_CELL_VERILOG ""
#RK lappend G_STD_CELL_VERILOG e05_ln_core.v
#RK lappend G_STD_CELL_VERILOG e05_nn_core.v
#RK lappend G_STD_CELL_VERILOG e05_primitive_verilog.v
#RK 
#RK # TAR libraries
#RK lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww37.3_e05_c.0.p1_cnlgt/lib/ln/
#RK lappend G_LIB_SEARCH_PATH /p/hdk/cad/stdcells/e05/14ww37.3_e05_c.0.p1_cnlgt/lib/nn/
#RK 
#RK set G_STD_CELL_LIBS ""
#RK #lappend G_STD_CELL_LIBS e05_ln_p1274_0x1r0v2_tttt_v065_t100_max.lib 
#RK #lappend G_STD_CELL_LIBS e05_ln_p1274_0x1r0v2_tmin_v065_t100_min.lib
#RK #lappend G_STD_CELL_LIBS e05_ln_p1274_0x1r0v2_tttt_v065_to_v065_t100_max.lib
#RK #lappend G_STD_CELL_LIBS e05_ln_p1274_0x1r0v2_tmin_v065_to_v065_t100_min.lib
#RK #lappend G_STD_CELL_LIBS e05_nn_p1274_0x1r0v2_tttt_v065_t100_max.lib
#RK #lappend G_STD_CELL_LIBS e05_nn_p1274_0x1r0v2_tmin_v065_t100_min.lib
#RK #lappend G_STD_CELL_LIBS e05_nn_p1274_0x1r0v2_tttt_v065_to_v065_t100_max.lib
#RK #lappend G_STD_CELL_LIBS e05_nn_p1274_0x1r0v2_tmin_v065_to_v065_t100_min.lib
#RK lappend G_STD_CELL_LIBS e05_ln_p1274d0_tttt_v065_t100_max.lib
#RK lappend G_STD_CELL_LIBS e05_ln_p1274d0_tmin_v065_t100_min.lib
#RK lappend G_STD_CELL_LIBS e05_ln_p1274d0_tttt_v065_to_v065_t100_max.lib
#RK lappend G_STD_CELL_LIBS e05_ln_p1274d0_tmin_v065_to_v065_t100_min.lib
#RK lappend G_STD_CELL_LIBS e05_nn_p1274d0_tttt_v065_t100_max.lib
#RK lappend G_STD_CELL_LIBS e05_nn_p1274d0_tmin_v065_t100_min.lib
#RK lappend G_STD_CELL_LIBS e05_nn_p1274d0_tttt_v065_to_v065_t100_max.lib
#RK lappend G_STD_CELL_LIBS e05_nn_p1274d0_tmin_v065_to_v065_t100_min.lib
#RK #this echo line will fail DUET
#RK #echo "add_search_path '$G_LIB_SEARCH_PATH' -library -both" >> FEV_dofile.tcl
#RK add_search_path $G_LIB_SEARCH_PATH -library -both
