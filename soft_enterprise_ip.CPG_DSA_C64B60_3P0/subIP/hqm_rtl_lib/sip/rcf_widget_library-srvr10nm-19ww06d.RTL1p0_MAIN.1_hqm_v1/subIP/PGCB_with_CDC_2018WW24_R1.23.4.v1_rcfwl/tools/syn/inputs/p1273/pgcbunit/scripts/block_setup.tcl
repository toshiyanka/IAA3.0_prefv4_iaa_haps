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
set G_DESIGN_NAME pgcbunit 

# set G_LIBRARY_TYPE to the library you are using. This must be set here or flow will error!!
set G_LIBRARY_TYPE d04
set G_VT_TYPE(default) wn
set G_LIB_VOLTAGE 0.75

# To continue with the run even with error
set G_LOGSCAN_RULES ""


set RTL_DEFINES "INTEL_SVA_OFF MEM_CTECH"

# Variable to tell if regular flops should be replaced with scan flops or not (if 1, compile -scan otherwise -scan is not used)
# setvar G_SCAN_REPLACE_FLOPS 1

# Variable to tell if scan chains are to be connected or not (if 0 insert_dft.tcl will not be sourced)
# setvar G_INSERT_SCAN 1

# Variable to disable scan-swapping and scan insertion on specified designs
#set G_DFX_NONSCAN_DESIGNS ""
#set G_AUTO_SCAN_EXCLUSION_PATTERNS {}
#set G_SCAN_EXCL_CLK_NET_PTTRN " "
#set G_SCAN_EXCL_LIB_PATTERN {}

# Variable to specify whether to perform uniquification of submodule names.
# Default is set to 1 in default_setup.tcl - ie. uniquify design
## set G_ENABLE_UNIQUIFIED 1

### Add project required ROMS 

set rom_lib_dir   [glob -type d $env(IP_ROOT)/subIP/hip/ICPLPA0_ROM_1273/RTL0P5/lib]
# lappend search_path $rom_lib_dir
# set available_rom [glob -type f $rom_lib_dir/c73p1rfshdxrom2048x??hb4img1??_tttt_1.05v_30c.ldb]
# foreach lib_rom $available_rom {
   # lappend G_ADDITIONAL_LINK_LIBRARIES [file tail $lib_rom ]
# }
# 

### Add project required UPF and enable
## setvar G_UPF 1
## setvar G_UPF_FILE $env(IP_ROOT)/tools/upf/ICPLP/${G_DESIGN_NAME}.upf
set RTL_DEFINES "INTEL_SVA_OFF MEM_CTECH"

##########################
# SAIF related G_variables
###########################
# specify SAIF file from RTL
# setvar G_SAIF_FILE ""
## lappend G_ADDITIONAL_LINK_LIBRARIES d04_xn_p1273_1x1r3_tttt_0.75v_70.00c_max.ldb
 

# FIXME -- workaround for kit 14.2.2

## NOMAN - ONLY NEEDED FOR FEBE
#setvar G_SYN_REPORTS(import_design) "rtllist instantiatedcells "
#setvar G_SYN_REPORTS(constraints) "check_design check_timing high_fanout_net timing_requirements missing_clock_sources check_port_timing flop_latch_info non_clock_logic_on_clock_path "
#setvar G_SYN_REPORTS(constraints) "high_fanout_net timing_requirements missing_clock_sources check_port_timing flop_latch_info non_clock_logic_on_clock_path "
#setvar G_SYN_REPORTS(clock_gating) ""
#setvar G_SYN_REPORTS(pre_dft) "dft_drc preview_dft scan_configuration dft_insertion_configuration"
#setvar G_SYN_REPORTS(compile_incr) "qor design_qor area worst_25_max worst_25_min reg2reg_timing check_mv_design isolation_cell_details threshold_voltage_group check_timing"
#setvar G_SYN_REPORTS(compile) "qor design_qor area resources worst_25_max worst_25_min reg2reg_timing check_mv_design isolation_cell_details power_domain_summary threshold_voltage_group check_timing cells_in_default_pd nested_pd  "
#setvar G_SYN_REPORTS(insert_dft) "dft_signal dft_scan_path dft_coverage dft_netlist_checker test_protocol test_assume scan_false qor design_qor check_mv_design isolation_cell_details isaf_audit_package "
#setvar G_SYN_REPORTS(syn_final) "clock_gating vio vio_max_delay check_timing clock design power scan_false resources reference unloaded_reg dont_touch_cells size_only_cells clock_gating_status G_variables_list high_fanout_net missing_clock_sources check_port_timing flop_latch_info non_clock_logic_on_clock_path qor design_qor area worst_25_max worst_25_min reg2reg_timing check_mv_design power_domain_summary isolation_cell_details threshold_voltage_group Design_report visa_hier variables seq_map cells_in_default_pd nested_pd clock_gating_filtered test_protocol isaf_audit_package "

## setvar G_SYN_OUTPUTS(import_design) "ddc verilog"
## setvar G_SYN_OUTPUTS(constraints) "ddc verilog"
## #setvar G_SYN_OUTPUTS(upf) "ddc upf verilog"
## #setvar G_SYN_OUTPUTS(insert_dft) "ddc verilog scandef"
## setvar G_SYN_OUTPUTS(compile_incr) "ddc verilog"
## setvar G_SYN_OUTPUTS(uniquify) "ddc verilog"
## setvar G_SYN_OUTPUTS(floorplan) "ddc verilog"
## setvar G_SYN_OUTPUTS(compile) "upf ddc verilog sdc"
## setvar G_SYN_OUTPUTS(pre_dft) "ddc verilog"
## setvar G_SYN_OUTPUTS(syn_final) "ddc verilog sdc spef scandef upf stdcell_def net_layer write_env "

# NOMAN - ONLY NEEDED FOR FEBE
set CTECH_TYPE "d04"
set CTECH_VARIANT "wn"

# Added so that hiy cells dont get swapped to regular cells
setvar G_CTECH_DONTTOUCH_REF_NAME_PATTERN "d04hiy*"

set compile_ultra_ungroup_dw false

#setvar G_INSERT_CLOCK_GATING 1
#setvar G_SCAN_REPLACE_FLOPS 1
#setvar G_COMPILE_OPTIONS " -no_seq_output_inversion -no_autoungroup -no_boundary_optimization -gate_clock -scan"
#setvar G_COMPILE_INCR_OPTIONS " -no_seq_output_inversion -no_autoungroup -no_boundary_optimization -scan"
#setvar G_OPTIMIZE_FLOPS 0
#setvar G_SIMPLIFY_CONSTANTS 0
#setvar G_OPTIMIZE_AREA 0


#setvar G_LOAD_LIBRARY_LIST "d04xn"

#set G_STDCELL_DIR "/p/hdk/cad/stdcells/d04/15ww09.1_d04_prj_hdk73_SD1.7.10"

#set G_STDCELL_DIRS "/p/hdk/cad/stdcells/d04/15ww09.1_d04_prj_hdk73_SD1.7.10 /p/hdk/cad/stdcells/d04alphaCOE/15ww18.5_d04alphaCOE_prj_hdk73_SD1.9.0_alphaCOE /p/hdk/cad/stdcells/d04alphaFC/15ww01.5_d04alphaFC_prj_hdk73_SD1.9.8_alphaFC /p/hdk/cad/stdcells/d04alphaFIDUCIAL/15ww04.4_d04alphaFIDUCIAL_prj_hdk73_SD1.3.3_alphaFIDUCIAL /p/hdk/cad/stdcells/d04alphaTG/15ww07.5_d04alphaTG_prj_hdk73_SD1.2.5_alphaTG /p/hdk/cad/stdcells/e05/15ww07.3_e05_d.0.p3_cnlgt /p/hdk/cad/stdcells/e3modules/15ww10.3_e3modules_prj.v1 /p/hdk/cad/stdcells/ec0/15ww07.5_ec0_e.0.p3.cnl.sdg.mig /p/hdk/cad/stdcells/ec7/15ww06.4_ec7_d.0.cnl.sdg /p/hdk/cad/stdcells/ex0b/15ww10.3_ex0b_2.2.x74 /p/hdk/cad/stdcells/ex5/15ww10.3_ex5_prj_ihdk_2.1.0.x74 /p/hdk/cad/stdcells/f05/14ww47.5_f05_b.0_dmdsoc /p/hdk/cad/stdcells/fa0/14ww38.5_fa0_b.0.plm /p/hdk/cad/stdcells/fc0/14ww22.4_fc0_m.1.p1 /p/hdk/cad/stdcells/e6rfmodules/14ww47.5_e6rfmodules_prj.v2 /p/hdk/cad/stdcells/ip10xadtshr/15ww11.1_ip10xadtshr_r.7 /p/hdk/cad/stdcells/df0/15ww11.5_df0_i.0.sdg"


exec /usr/bin/rsync --ignore-existing /p/sip/syn/reggie/latest/scripts/syn/dc_vars.tcl scripts/.
setvar G_INSERT_SCAN 0
setvar G_UPF 0
setvar G_ABUTTED_VOLTAGE 0
setvar G_REMOVE_BUFFERS_DEFAULT_PD 1
