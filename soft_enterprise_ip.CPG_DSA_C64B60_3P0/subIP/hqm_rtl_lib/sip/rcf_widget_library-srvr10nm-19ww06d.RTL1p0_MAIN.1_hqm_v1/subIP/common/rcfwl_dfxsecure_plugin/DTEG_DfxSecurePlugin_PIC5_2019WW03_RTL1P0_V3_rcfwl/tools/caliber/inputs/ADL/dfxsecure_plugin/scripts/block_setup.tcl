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

# turn on UPF by default

setvar G_ENABLE_AOCVM 0
setvar G_PRESERVE_ADDITIONAL_LINK_LIBRARIES 1
lappend G_ADDITIONAL_LINK_LIBRARIES "/p/hdk/cad/stdcells/e05/17ww51.5_e05_j.0.p3_tglgt/lib/nldm/p1274d6/ln/e05_ln_p1274d6_rfff_v065_t110_min.ldb"
lappend G_ADDITIONAL_LINK_LIBRARIES "/p/hdk/cad/stdcells/e05/17ww20.5_e05_g.0.p6_cnlgt/lib/nldm/p1274d0/ln/e05_ln_p1274d0_tttt_v065_to_v065_t100_max.ldb"
lappend G_ADDITIONAL_LINK_LIBRARIES "/p/hdk/cad/stdcells/e05/17ww20.5_e05_g.0.p6_cnlgt/lib/nldm/p1274d0/ln/e05_ln_p1274d0_tttt_v065_t100_max.ldb"

lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/e05/17ww20.5_e05_g.0.p6_cnlgt/lib/nldm/p1274d0/nn/e05_nn_p1274d0_tttt_v065_t100_max.ldb
lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/e05/17ww20.5_e05_g.0.p6_cnlgt/lib/nldm/p1274d0/nn/e05_nn_p1274d0_tttt_v065_to_v065_t100_max.ldb
lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/e05/17ww20.5_e05_g.0.p6_cnlgt/lib/nldm/p1274d0/ln/e05_ln_p1274d0_tttt_v065_to_v065_t100_max.ldb
lappend G_ADDITIONAL_LINK_LIBRARIES /p/hdk/cad/stdcells/e05/17ww20.5_e05_g.0.p6_cnlgt/lib/nldm/p1274d0/ln/e05_ln_p1274d0_tttt_v065_t100_max.ldb


