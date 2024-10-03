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
#set G_TAR_GATE_LIST $env(WARD)/syn/outputs/$env(DBB).syn_final.vg
set G_CONF_COMPARE_EFFORT "Auto"
set G_CONF_MAP_UNREACH 1
#set FEVLITE_GEN_OPT_RPT 1 

#set FEVLITE_GEN_TIEOFF_RPT 1 

## Turn this on if you are using UPF in syn runs
set G_FV_LP 0

#set SCRIPTS_DIR  $env(WARD)/fev/scripts/

#HSD 1404389480 
#vpx set rule handling RTL7.16 -warn

#if {[file exists "${SCRIPTS_DIR}/bbox.tcl"]} {
#  source ${SCRIPTS_DIR}/bbox.tcl
#}


##lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/ec0glbclk/15ww49.3_ec0glbclk_f.0.cnl.sdg.mig/lib/nldm/p1274d0/nn/ec0glbclk_nn_p1274d0_tttt_v065_t100_max.ldb
#lappend G_TAR_GATE_LIST /p/hdk/cad/stdcells/ip74xglbdrvby9or12/17ww01.2_ip74xglbdrvby9or12_g.1_sdg/v/nn/ip74xglbdrvby9or12.v
####setvar G_DONT_RUN_POLARIS 1
lappend G_LEGAL_RTL_OWNERS "toolshdk"

setvar G_REF_RTL_2STAGE 1
setvar G_REF_RTL_LIST $env(WARD)/collateral/rtl/rtl_list_2stage.tcl
