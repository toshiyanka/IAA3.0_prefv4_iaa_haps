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

# set G_LIBRARY_TYPE to the library you are using. This must be set here or flow will error!!

# turn on UPF by default

# To continue with the run even with error
set G_LOGSCAN_RULES ""


setvar G_VT_TYPE(default) "wn_ln"


set G_SYN_REPORTS(syn_final) [lminus $G_SYN_REPORTS(syn_final) area ]


## added per Wee Meng's instruction
setvar G_INSERT_CLOCK_GATING 1
setvar G_CLOCK_GATING_CELL d04cgc01wd0i0
set G_SCAN_REPLACE_FLOPS 1
set G_INSERT_SCAN 0
set G_INSERT_CLOCK_GATING 0
set G_UPF 0

set G_PROCESS_NAME p1273
set G_DOT_PROCESS 4
set G_TRACK_TAG "default"

set G_CRITICAL_RANGE 300

set G_REMOVE_BUFFERS_DEFAULT_PD 0
set G_LIBRARY_TYPE d04
set G_VT_TYPE(default) wn
set G_LIB_VOLTAGE 0.75
setvar G_PRESERVE_ADDITIONAL_LINK_LIBRARIES 1
setvar G_SCAN_QUALITY_WAIVER(2) "waived"
