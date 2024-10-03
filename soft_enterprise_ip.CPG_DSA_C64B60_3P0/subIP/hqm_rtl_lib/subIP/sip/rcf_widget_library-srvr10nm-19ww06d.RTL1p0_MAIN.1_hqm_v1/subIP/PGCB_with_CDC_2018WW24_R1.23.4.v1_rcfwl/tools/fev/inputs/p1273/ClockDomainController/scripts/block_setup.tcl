#set G_CONF_RTL_UNDRIVEN_SIGNAL_0 1 <-- commented out on 03/02/2016
set G_CONF_ANALYZE_ABORT 0
#set G_CONF_DYNAMIC_HIER 0

set __VCS_ENV 0
set G_FV_LP 0 
#set G_REF_UPF_1801 1
#set G_TAR_UPF_1801 1
#set G_REF_LP_TYPE "logical" 
#set G_TAR_LP_TYPE "logical"

set G_REF_UPF_LIST ""
set G_TAR_UPF_LIST ""

set G_COMPARE_POWER_INTENT 0
set G_COMPARE_POWER_GRID 0
set G_COMPARE_PST 0
set G_COMPARE_POWER_CONSISTENCY 0

set G_LIBRARY_TYPE d04
set G_PRESERVE_ADDITIONAL_LINK_LIBRARIES 1

vpx set naming rule -field_delimiter \".\" \"\" -both
set G_REF_DEFINES_LIST "MEM_CTECH"

set G_CONF_NOTRANSLATE "c73p1rfshdxrom2048x16hb4img100 c73p1rfshdxrom2048x32hb4img110 c73p1rfshdxrom2048x32hb4img108"

set G_ADDITIONAL_LINK_LIBRARIES "$env(IP_ROOT)/subIP/hip/ICPLPA0_ROM_1273/ICPLPA0_ROM_1273/c73p1rfshdxrom2048x16hb4img100/timing/c73p1rfshdxrom2048x16hb4img100_tttt_1.05v_30c.lib $env(IP_ROOT)/subIP/hip/ICPLPA0_ROM_1273/ICPLPA0_ROM_1273/c73p1rfshdxrom2048x32hb4img110/timing/c73p1rfshdxrom2048x32hb4img110_tttt_1.05v_30c.lib $env(IP_ROOT)/subIP/hip/ICPLPA0_ROM_1273/ICPLPA0_ROM_1273/c73p1rfshdxrom2048x32hb4img108/timing/c73p1rfshdxrom2048x32hb4img108_tttt_1.05v_30c.lib"

#set G_LOAD_LIBRARY_LIST "d04 d04wn"
#set G_LOAD_LIBRARY_LIST "d04"

set G_STDCELL_DIRS "/p/hdk/cad/stdcells/d04/15ww09.1_d04_prj_hdk73_SD1.7.10 /p/hdk/cad/stdcells/d04alphaCOE/15ww18.5_d04alphaCOE_prj_hdk73_SD1.9.0_alphaCOE /p/hdk/cad/stdcells/d04alphaFC/15ww01.5_d04alphaFC_prj_hdk73_SD1.9.8_alphaFC /p/hdk/cad/stdcells/d04alphaFIDUCIAL/15ww04.4_d04alphaFIDUCIAL_prj_hdk73_SD1.3.3_alphaFIDUCIAL /p/hdk/cad/stdcells/d04alphaTG/15ww07.5_d04alphaTG_prj_hdk73_SD1.2.5_alphaTG /p/hdk/cad/stdcells/e05/15ww07.3_e05_d.0.p3_cnlgt /p/hdk/cad/stdcells/e3modules/15ww10.3_e3modules_prj.v1 /p/hdk/cad/stdcells/ec0/15ww07.5_ec0_e.0.p3.cnl.sdg.mig /p/hdk/cad/stdcells/ec7/15ww06.4_ec7_d.0.cnl.sdg /p/hdk/cad/stdcells/ex0b/15ww10.3_ex0b_2.2.x74 /p/hdk/cad/stdcells/ex5/15ww10.3_ex5_prj_ihdk_2.1.0.x74 /p/hdk/cad/stdcells/f05/14ww47.5_f05_b.0_dmdsoc /p/hdk/cad/stdcells/fa0/14ww38.5_fa0_b.0.plm /p/hdk/cad/stdcells/fc0/14ww22.4_fc0_m.1.p1 /p/hdk/cad/stdcells/e6rfmodules/14ww47.5_e6rfmodules_prj.v2 /p/hdk/cad/stdcells/ip10xadtshr/15ww11.1_ip10xadtshr_r.7 /p/hdk/cad/stdcells/df0/15ww11.5_df0_i.0.sdg"

set G_VT_TYPE(default) wn
