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
#set G_DESIGN_NAME $env(DBB)
set G_INPUTS_DIR $env(WARD)/syn_caliber/inputs
set G_UPF_FILE $env(WARD)/collateral/upf/${G_DESIGN_NAME}.upf
set G_SAIF_FILE ""
set G_MULTI_VOLTAGE 0
set G_UPF 0
#For noble_runRDT analyze design stage - MUST BE SET for libraries to load from mentioned corner below else flow errors out
#setvar G_CORNER_NAME_TYPE "vccnom+MAX"
setvar G_CORNER_NAME_TYPE "nominal+MAX"
setvar G_ENABLE_AOCVM 0
set this_scenario [getvar G_SCENARIO]
set G_INSERT_SCAN 0