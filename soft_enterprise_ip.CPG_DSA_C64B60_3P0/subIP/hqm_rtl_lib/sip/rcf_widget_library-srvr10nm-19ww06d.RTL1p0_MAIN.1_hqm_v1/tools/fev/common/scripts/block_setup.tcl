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
# This file is used for setup block-level fev. User can modify and customize 
# flow G_* variable to control RDT flow behavior.
# 
##set G_TAR_GATE_LIST $env(WARD)/syn/outputs/$env(DBB).syn_final.vg
#set G_CONF_COMPARE_EFFORT "Auto"
#set G_CONF_MAP_UNREACH 1
#set FEVLITE_GEN_OPT_RPT 1
#set FEVLITE_GEN_TIEOFF_RPT 1

## Turn this on if you are using UPF in syn runs
#set G_FV_LP 0

#set SCRIPTS_DIR  $env(WARD)/fev/scripts/


#HSD 1404389480 
#vpx set rule handling RTL7.16 -warn

#if {[file exists "${SCRIPTS_DIR}/bbox.tcl"]} {
#  source ${SCRIPTS_DIR}/bbox.tcl
#}

