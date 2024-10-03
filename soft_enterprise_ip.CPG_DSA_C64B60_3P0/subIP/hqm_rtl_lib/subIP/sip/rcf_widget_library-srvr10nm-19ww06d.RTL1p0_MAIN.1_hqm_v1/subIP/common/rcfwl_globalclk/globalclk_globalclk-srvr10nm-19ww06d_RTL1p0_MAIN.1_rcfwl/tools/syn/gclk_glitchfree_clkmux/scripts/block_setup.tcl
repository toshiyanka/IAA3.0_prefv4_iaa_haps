################################################################################
# Intel Top Secret
################################################################################
# Copyright (C) 2010, Intel Corporation.  All rights reserved.
#
# This is the property of Intel Corporation and may only be utilized
# pursuant to a written Restricted Use Nondisclosure Agreement
# with Intel Corporation.  It may not be used, reproduced, or
# disclosed to others except in accordance with the terms and
# conditions of such agreement.
###################################################################################
# Description:
# This file is used for setup block-level synthesis. User can modify and customize 
# flow G_* variable to control RDT flow behavior.
# 
if {![info exists G_DESIGN_NAME]} {
    set G_DESIGN_NAME gclk_glitchfree_clkmux
}

# set G_LIBRARY_TYPE to the library you are using. This must be set here or flow will error!!
if {![info exists G_LIBRARY_TYPE]} {
    set G_LIBRARY_TYPE "ec0"
}
set G_VT_TYPE(default) "bn_cn"

setvar G_OPTIMIZE_FLOPS 0
set G_ANALYZE_RTL_TOGETHER 1

# Variable to tell if regular flops should be replaced with scan flops or not (if 1, compile -scan otherwise -scan is not used)
set G_SCAN_REPLACE_FLOPS 0
# Variable to tell if scan chains are to be connected or not (if 0 insert_dft.tcl will not be sourced)
set G_INSERT_SCAN 0

# Use the G_UPF_FILE file to specify the upf file to use
if [file exists "${G_INPUTS_DIR}/[getvar G_DESIGN_NAME].upf" ] {
set G_UPF 1
} else {
set G_UPF 0
}

# To enable MCO lint in FEBE
setvar G_IS_FEBE_FLOW "true"

# SAIF related G_variables
set G_SAIF_FILE ""

setvar G_EMAIL_ON_DONE 0
setvar G_EMAIL_ON_ERROR 0
setvar G_EMAIL_ON_STAGES(syn) 0
setvar G_EMAIL_ON_STAGES(syn_de) 0
setvar G_EMAIL_ON_STAGES(syn_rt) 0

if {[file exists "${G_SCRIPTS_DIR}/[getvar G_DESIGN_NAME].DC.tcl"]} {
  source ${G_SCRIPTS_DIR}/[getvar G_DESIGN_NAME].DC.tcl
}

setvar G_ENABLE_FAST_TIMING  0
lappend_var G_SYN_REPORTS(syn_final) worst_max
lappend_var G_SYN_REPORTS(syn_final) worst_min
lappend_var G_SYN_REPORTS(syn_final) ipds_checker

#lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/ec0glbclk/15ww49.3_ec0glbclk_f.0.cnl.sdg.mig/lib/nldm/p1274d0/nn/ec0glbclk_nn_p1274d0_tttt_v065_t100_max.ldb
#lappend G_ADDITIONAL_MW_REFERENCE_LIBS /p/hdk/cad/stdcells/ec0glbclk/15ww49.3_ec0glbclk_f.0.cnl.sdg.mig/fram/nn/ec0glbclk_nn_core
#for using 2 stage FL in DC
setvar G_DONT_ANALYZE_TO_WORK_LIB 1
setvar G_RTL_LIST "rtl_list_2stage.tcl"

#for using 2 stage FL in DC
setvar G_DONT_ANALYZE_TO_WORK_LIB 1
setvar G_RTL_LIST "rtl_list_2stage.tcl"
