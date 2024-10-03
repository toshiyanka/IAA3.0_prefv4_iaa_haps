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
# This file is used for setup block-level syn_caliber. User can modify and  customize
# flow G_* variable to controllRDT flow behavior.
#
#set G_DESIGN_NAME $::env(DBB)
set G_INPUTS_DIR $env(WARD)/syn_caliber/inputs
set G_UPF_FILE $env(WARD)/collateral/upf/${G_DESIGN_NAME}.upf
set G_SAIF_FILE ""
#For noble_runRDT analyze design stage - MUST BE SET for libraries to load from mentioned corner below else flow errors out
setvar G_CORNER_NAME_TYPE "nominal+MAX"
setvar G_ENABLE_AOCVM 0

#lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/ec0glbclk/15ww49.3_ec0glbclk_f.0.cnl.sdg.mig/lib/nldm/p1274d0/nn/ec0glbclk_nn_p1274d0_tttt_v065_t100_max.ldb
#lappend G_ADDITIONAL_MW_REFERENCE_LIBS /p/hdk/cad/stdcells/ec0glbclk/15ww49.3_ec0glbclk_f.0.cnl.sdg.mig/fram/nn/ec0glbclk_nn_core

#lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/ip74xglbdrvby9or12/16ww25.2_ip74xglbdrvby9or12_g.0_sdg/lib/ip74xglbdrvby9or12_p1274d2_tttt_0.65v_100c.max.ldb
#lappend G_ADDITIONAL_MW_REFERENCE_LIBS /p/hdk/cad/stdcells/ip74xglbdrvby9or12/16ww25.2_ip74xglbdrvby9or12_g.0_sdg/fram/ip74xglbdrvby9or12_ebb
#setvar G_LOGSCAN_RULES "" 

setvar G_MULTI_VOLTAGE 0
setvar G_UPF 0
setvar G_INSERT_SCAN 0
