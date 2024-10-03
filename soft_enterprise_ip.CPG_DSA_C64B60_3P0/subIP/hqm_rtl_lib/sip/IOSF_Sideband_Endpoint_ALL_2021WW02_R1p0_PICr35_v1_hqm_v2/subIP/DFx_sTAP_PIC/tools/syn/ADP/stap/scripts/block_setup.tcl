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
setvar G_LIBRARY_TYPE d04
setvar G_VT_TYPE(default) ln
setvar G_LIB_VOLTAGE 0.75
setvar G_PRESERVE_ADDITIONAL_LINK_LIBRARIES 1
setvar G_SCAN_QUALITY_WAIVER(2) "Waived"
#setvar G_INPUTS_DIR "./tools/upf/upf_2.0"


# turn on UPF by default
setvar G_UPF 1
# Use the G_UPF_FILE file to specify the upf file to use
setvar G_UPF_FILE $env(REPO_ROOT)/tools/upf/upf_2.0/stap.upf

# To continue with the run even with error
setvar G_LOGSCAN_RULES ""


setvar G_LVT_PERCENT 30

#set G_STDCELL_DIRS "$env(KIT_PATH)/stdcells/d04/default/latest/"

setvar G_SYN_REPORTS(syn_final) [lminus $G_SYN_REPORTS(syn_final) area ]


## added per Wee Meng's instruction
setvar G_INSERT_CLOCK_GATING 1
setvar G_CLOCK_GATING_CELL d04cgc01wd0i0
setvar G_SCAN_REPLACE_FLOPS 0
setvar G_INSERT_SCAN 0
setvar G_INSERT_CLOCK_GATING 0
set RTL_DEFINES "SYNTH_04 INTEL_SVA_OFF"

setvar G_PROCESS_NAME p1273
setvar G_DOT_PROCESS 4
setvar G_TRACK_TAG "default"

setvar G_CRITICAL_RANGE 300

setvar G_REMOVE_BUFFERS_DEFAULT_PD 0
setvar G_LIBRARY_TYPE d04
setvar G_VT_TYPE(default) ln
setvar G_LIB_VOLTAGE 0.75
#setvar G_STDCELL_DIRS "/p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest"
#source /p/hdk/cad/rdt/rdt_14.4.1/scripts/library_setup.tcl
#source /p/hdk/cad/kits_p1273/p1273_14.4.1/flows/rdt/common/scripts/library_d04.tcl

#setvar G_CTECH_PROCESS p1273
