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
###################################################################################

#===== To setup design and library variable =====# 
setvar G_DESIGN_NAME stap 

# set G_LIBRARY_TYPE to the library you are using. This must be set here or flow will error!!
setvar G_LIBRARY_TYPE e05
setvar G_VT_TYPE(default) nn
setvar G_LIB_VOLTAGE 0.65
setvar G_PRESERVE_ADDITIONAL_LINK_LIBRARIES 1
setvar G_SCAN_QUALITY_WAIVER(2) "Waived"
lappend_var G_UNIQUIFIED_DONT_RENAME_DESIGN_LIST "ctech_lib_clk_buf"
lappend_var G_UNIQUIFIED_DONT_RENAME_DESIGN_LIST "ctech_lib_dq"
lappend_var G_UNIQUIFIED_DONT_RENAME_DESIGN_LIST "ctech_lib_mux_2to1"

# turn on UPF by default

# To continue with the run even with error
#setvar G_LOGSCAN_RULES ""


setvar G_SCAN_REPLACE_FLOPS 0
setvar G_INSERT_SCAN 0
setvar G_INSERT_CLOCK_GATING 0
setvar G_CLOCK_GATE_PATTERN e05cilb05an1d03x5


set RTL_DEFINES "SYNTH_04 INTEL_SVA_OFF"
#setvar G_STDCELL_DIRS "/p/hdk/cad/stdcells/e05/16ww07.3_e05_g.0.p1_cnlgt/"
#setvar G_STDCELL_DIRS "/p/hdk/cad/stdcells/e05/16ww19.1_e05_h.0_cnlgt/"
setvar G_UPF 0

setvar G_PROCESS_NAME p1274
#setvar G_DOT_PROCESS 4
setvar G_TRACK_TAG "default"

setvar G_CRITICAL_RANGE 300

setvar G_REMOVE_BUFFERS_DEFAULT_PD 0
#setvar G_CORNER_NAME_TYPE "lowvcc+MAX,lowvcctmin+MIN"

# Workaround for rdt_constrain_visa_logic
proc rdt_get_current_scenario { args } {
    parse_proc_arguments -args $args arg
    set ret ""
    if {[info commands current_scenario] == "current_scenario"} {
        redirect -variable xyz {current_scenario}
        regexp {Current scenario is:\s+(\S+)} $xyz _ ret
    }
    return $ret
}

