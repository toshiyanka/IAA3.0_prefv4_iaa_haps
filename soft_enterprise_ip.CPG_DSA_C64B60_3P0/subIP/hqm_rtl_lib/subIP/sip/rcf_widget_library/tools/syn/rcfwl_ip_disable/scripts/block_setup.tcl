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
    setvar G_DESIGN_NAME rcfwl_ip_disable
}

# set G_LIBRARY_TYPE to the library you are using. This must be set here or flow will error!!
if {![info exists G_LIBRARY_TYPE]} {
    setvar G_LIBRARY_TYPE "ec0"
}
setvar G_VT_TYPE(default) "ln"

setvar G_OPTIMIZE_FLOPS 0
setvar G_ANALYZE_RTL_TOGETHER 1

# Variable to tell if regular flops should be replaced with scan flops or not (if 1, compile -scan otherwise -scan is not used)
setvar G_SCAN_REPLACE_FLOPS 0
# Variable to tell if scan chains are to be connected or not (if 0 insert_dft.tcl will not be sourced)
setvar G_INSERT_SCAN 0

# Use the G_UPF_FILE file to specify the upf file to use
if [file exists "${G_INPUTS_DIR}/[getvar G_DESIGN_NAME].upf" ] {
setvar G_UPF 1
} else {
setvar G_UPF 0
}

# To enable MCO lint in FEBE
setvar G_IS_FEBE_FLOW "true"

# SAIF related G_variables
setvar G_SAIF_FILE ""

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

#for using 2 stage FL in DC
setvar G_DONT_ANALYZE_TO_WORK_LIB 1
setvar G_RTL_LIST "rtl_list_2stage.tcl"

#per Gautham response HSD 1406977414
#lremove_var G_SYN_CHECKS(syn_final) "port_names"
setvar G_SYN_OUTPUTS(import_design) "verilog"

#hsd 1407261516
setvar G_GEN_SUMMARY_REPORT 0

#response to hsd 1407689133
#lremove_var G_SYN_REPORTS(compile) "design_qor"
#lremove_var G_SYN_REPORTS(insert_dft) "design_qor"
#lremove_var G_SYN_REPORTS(compile_incr) "design_qor"
#lremove_var G_SYN_REPORTS(syn_final) "design_qor"
