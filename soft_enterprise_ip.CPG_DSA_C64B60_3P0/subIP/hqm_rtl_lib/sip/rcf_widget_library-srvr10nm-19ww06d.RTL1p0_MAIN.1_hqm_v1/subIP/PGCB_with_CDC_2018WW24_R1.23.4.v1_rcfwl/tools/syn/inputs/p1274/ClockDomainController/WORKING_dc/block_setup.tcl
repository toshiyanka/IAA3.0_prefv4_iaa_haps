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
set G_DESIGN_NAME ClockDomainController 

# set G_LIBRARY_TYPE to the library you are using. This must be set here or flow will error!!
set G_LIBRARY_TYPE e05
set G_VT_TYPE(default) ln
set G_LIB_VOLTAGE 0.75

# turn on UPF by default
# set G_UPF 1
# Use the G_UPF_FILE file to specify the upf file to use
# set G_UPF_FILE ${G_INPUTS_DIR}/${G_DESIGN_NAME}.upf

# To continue with the run even with error
set G_LOGSCAN_RULES ""

set my_lib_release_ver "14ww37.3_e05_c.0.p1_cnlgt"
setvar G_STDCELL_LIBS($G_LIBRARY_TYPE) $my_lib_release_ver 
lappend_var G_STDCELL_DIRS "/p/hdk/cad/stdcells/$G_LIBRARY_TYPE/$my_lib_release_ver"
#lappend_var G_STDCELL_DIR "/p/hdk/cad/stdcells/$G_LIBRARY_TYPE/14ww39.1_e05_c.0.p2_cnlgt"
lappend_var G_STDCELL_DIR "/p/hdk/cad/stdcells/$G_LIBRARY_TYPE/$my_lib_release_ver"



exec /usr/bin/rsync --ignore-existing /p/sip/syn/reggie/latest/scripts/syn/dc_vars.tcl scripts/.
setvar G_INSERT_SCAN 0
setvar G_UPF 0
setvar G_ABUTTED_VOLTAGE 0
setvar G_REMOVE_BUFFERS_DEFAULT_PD 1


# NOMAN - ONLY NEEDED FOR FEBE
set CTECH_TYPE "e05"
set CTECH_VARIANT "ln"

# setvar G_LOAD_LIBRARY_LIST "e05"
