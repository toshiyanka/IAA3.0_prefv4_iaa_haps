## There are additional analyze commands in this TCL file commented out by default.
## You may find your module includes files from an additional library and that you need
## to uncomment one of the target libraries in this file.  At first, try leaving everything
## commented out for performance reasons.


########################################################
## The following section includes the analyze CMDs
## for libraries the script was explicitly told to
## include via the -liblist or -l switch.  Order matters
## here, and they will appear below in the same order
## they were specified on the command-line
########################################################

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_pccdu_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_v_rtl_lib_gclk_cda_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_v_rtl_lib_gclk_clkreqaggr_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_v_rtl_lib_gclk_glitchfree_clkmux_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_v_rtl_lib_gclk_pccdu_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_v_rtl_lib_gclk_rcb_lcb_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_v_rtl_lib_gclk_refclkdist_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_cda_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_clkdist_clkmux_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_clkdist_mux_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_glitchfree_clkmux_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_pccdu_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_psyncdist_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_rcb_lcb_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/CTECH_EXP_v_rtl_lib_gclk_refclkdist_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end



########################################################
## Analyze CMD for target/globalclk/vcs_4value/gclk_pccdu_rtl_lib
## This one is most likely to be necessary to be 
## uncommented
########################################################
## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_pccdu_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_cda_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_clkdist_clkmux_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_clkdist_mux_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_clkdist_repeater_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_clkreqaggr_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_clkreqaggr_tb_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_divsync_gen_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_glitchfree_clkmux_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_glitchfree_clkmux_tb_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_mesh_clkdist_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_pccdu_tb_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_pclkdist_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_psocclkdist_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_psocsyncdist_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_psyncdist_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_psyncdist_tb_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_rcb_lcb_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_refclkdist_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_refclkdist_tb_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


## set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/ip74xdiv9or12_rtl_lib
## ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2005 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end +incdir+src +libext+.vs+.v+.vr+.sv+.vh  -f $RTL_TARGET/vlog_rtlargs.f -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f -extended_string_directive_end


