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
set G_DESIGN_NAME dfxsecure_plugin 

setvar CTECH_TYPE e05
setvar CTECH_VARIANT ln


# set G_LIBRARY_TYPE to the library you are using. This must be set here or flow will error!!
set G_LIBRARY_TYPE e05
set G_VT_TYPE(default) ln
set G_LIB_VOLTAGE 0.65

# turn on UPF by default

# To continue with the run even with error
set G_LOGSCAN_RULES ""


set G_SCAN_REPLACE_FLOPS 0
set G_INSERT_SCAN 0
set G_INSERT_CLOCK_GATING 0

set G_UPF 0

set G_PROCESS_NAME 10nm
set G_DOT_PROCESS 4
set G_TRACK_TAG "default"

set G_CRITICAL_RANGE 300
set G_REMOVE_BUFFERS_DEFAULT_PD 0

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

setvar G_PRESERVE_ADDITIONAL_LINK_LIBRARIES 1

