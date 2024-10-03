#======================#
# START OF CATCH BLOCK #
#======================#
if { [catch {
#======================#

###########################################################################
# IP info settings
###########################################################################

set ::use_vcs_parser 1
set ::collage_ip_info::ip_name "hqm_sip"
set ::collage_ip_info::ip_top_module_name "hqm_sip"
set ::collage_ip_info::ip_version "0.0"
set ::collage_ip_info::ip_intent_sp ""
if {([info exists ::env(HQM_SFI)] && $::env(HQM_SFI))} {
 set ::collage_ip_info::ip_input_files "\
    $::env(WORKAREA)/subIP/sip/AW/src/rtl/hqm_AW_pkg.sv \
    $::env(WORKAREA)/src/rtl/hqm_pkg.sv \
    $::env(WORKAREA)/src/rtl/hqm_sif_pkg.sv \
    $::env(WORKAREA)/src/rtl/system/hqm_sfi_pkg.sv \
    $::env(WORKAREA)/output/hqm/collage/hqm_sip/gen/rtl/hqm_sip.sv \
 "
} else {
 set ::collage_ip_info::ip_input_files "\
    $::env(WORKAREA)/subIP/sip/AW/src/rtl/hqm_AW_pkg.sv \
    $::env(WORKAREA)/src/rtl/hqm_pkg.sv \
    $::env(WORKAREA)/src/rtl/hqm_sif_pkg.sv \
    $::env(WORKAREA)/output/hqm/collage/hqm_sip/gen/rtl/hqm_sip.sv \
 "
}
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(WORKAREA)/src/rtl $::env(WORKAREA)/src/rtl/system $::env(WORKAREA)/subIP/sip/AW/src/rtl"

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_plugin_dirs "" ;
set ::collage_ip_info::ip_ifc_def_hook "ip_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc ip_create_ifc_instances {} {

 ######################################################################
 # Collage       3.327.a MANUAL - Define IP Clock Pins along with their properties in the IP build script (RTL0P8)
 collage_create_ip_clock -port "prim_clk" -clk_type FUNC_CLK -clk_max_freq 1000M -clk_min_freq 1000M

 if {([info exists ::env(HQM_SFI)] && $::env(HQM_SFI))} {

    ############################################
    # SFI::Globals (TX)
    ############################################
    set ifc_inst_name "sfi_tx_globals"

    create_interface_instance $ifc_inst_name \
        -type provider \
        -interface "SFI::Globals" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "sfi_tx_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   Value                   1

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               InterfaceLink           HQM_SFI_TX_BCM_EN
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   InterfaceLink           HQM_SFI_TX_BLOCK_EARLY_VLD_EN
    set_interface_parameter_attribute -instance $ifc_inst_name D                    InterfaceLink           HQM_SFI_TX_D
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   InterfaceLink           HQM_SFI_TX_DATA_AUX_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        InterfaceLink           HQM_SFI_TX_DATA_CRD_GRAN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      InterfaceLink           HQM_SFI_TX_DATA_INTERLEAVE
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        InterfaceLink           HQM_SFI_TX_DATA_LAYER_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       InterfaceLink           HQM_SFI_TX_DATA_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        InterfaceLink           HQM_SFI_TX_DATA_PASS_HDR
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       InterfaceLink           HQM_SFI_TX_DATA_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   InterfaceLink           HQM_SFI_TX_DS
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         InterfaceLink           HQM_SFI_TX_ECRC_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  InterfaceLink           HQM_SFI_TX_FLIT_MODE_PREFIX_EN
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             InterfaceLink           HQM_SFI_TX_FATAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name H                    InterfaceLink           HQM_SFI_TX_H
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         InterfaceLink           HQM_SFI_TX_HDR_DATA_SEP
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        InterfaceLink           HQM_SFI_TX_HDR_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                InterfaceLink           HQM_SFI_TX_HGRAN
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              InterfaceLink           HQM_SFI_TX_HPARITY
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          InterfaceLink           HQM_SFI_TX_IDE_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name M                    InterfaceLink           HQM_SFI_TX_M
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    InterfaceLink           HQM_SFI_TX_MAX_CRD_CNT_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        InterfaceLink           HQM_SFI_TX_MAX_HDR_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                InterfaceLink           HQM_SFI_TX_NDCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                InterfaceLink           HQM_SFI_TX_NHCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     InterfaceLink           HQM_SFI_TX_NUM_SHARED_POOLS
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   InterfaceLink           HQM_SFI_TX_PCIE_MERGED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   InterfaceLink           HQM_SFI_TX_PCIE_SHARED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  InterfaceLink           HQM_SFI_TX_RBN
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   InterfaceLink           HQM_SFI_TX_SH_DATA_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    InterfaceLink           HQM_SFI_TX_SH_HDR_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     InterfaceLink           HQM_SFI_TX_SHARED_CREDIT_EN
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  InterfaceLink           HQM_SFI_TX_TBN
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           InterfaceLink           HQM_SFI_TX_TX_CRD_REG
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             InterfaceLink           HQM_SFI_TX_VIRAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   InterfaceLink           HQM_SFI_TX_VR
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   InterfaceLink           HQM_SFI_TX_VT

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name D                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name H                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name M                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   ParamValueFromDesign    true

    set_parameter_attribute HQM_SFI_TX_BLOCK_EARLY_VLD_EN   Value   1
    set_parameter_attribute HQM_SFI_TX_DATA_PARITY_EN       Value   1
    set_parameter_attribute HQM_SFI_TX_DATA_AUX_PARITY_EN   Value   1

    set port_map    {}
    set open_params {}
    set open_ports  {
        tx_vendor_field
        rx_vendor_field
        tx_viral
        tx_fatal
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

    ############################################
    # SFI::Header (TX)
    ############################################
    set ifc_inst_name "sfi_tx_header"

    create_interface_instance $ifc_inst_name \
        -type provider \
        -interface "SFI::Header" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "sfi_tx_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   Value                   1

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               InterfaceLink           HQM_SFI_TX_BCM_EN
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   InterfaceLink           HQM_SFI_TX_BLOCK_EARLY_VLD_EN
    set_interface_parameter_attribute -instance $ifc_inst_name D                    InterfaceLink           HQM_SFI_TX_D
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   InterfaceLink           HQM_SFI_TX_DATA_AUX_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        InterfaceLink           HQM_SFI_TX_DATA_CRD_GRAN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      InterfaceLink           HQM_SFI_TX_DATA_INTERLEAVE
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        InterfaceLink           HQM_SFI_TX_DATA_LAYER_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       InterfaceLink           HQM_SFI_TX_DATA_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        InterfaceLink           HQM_SFI_TX_DATA_PASS_HDR
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       InterfaceLink           HQM_SFI_TX_DATA_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   InterfaceLink           HQM_SFI_TX_DS
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         InterfaceLink           HQM_SFI_TX_ECRC_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  InterfaceLink           HQM_SFI_TX_FLIT_MODE_PREFIX_EN
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             InterfaceLink           HQM_SFI_TX_FATAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name H                    InterfaceLink           HQM_SFI_TX_H
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         InterfaceLink           HQM_SFI_TX_HDR_DATA_SEP
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        InterfaceLink           HQM_SFI_TX_HDR_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                InterfaceLink           HQM_SFI_TX_HGRAN
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              InterfaceLink           HQM_SFI_TX_HPARITY
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          InterfaceLink           HQM_SFI_TX_IDE_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name M                    InterfaceLink           HQM_SFI_TX_M
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    InterfaceLink           HQM_SFI_TX_MAX_CRD_CNT_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        InterfaceLink           HQM_SFI_TX_MAX_HDR_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                InterfaceLink           HQM_SFI_TX_NDCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                InterfaceLink           HQM_SFI_TX_NHCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     InterfaceLink           HQM_SFI_TX_NUM_SHARED_POOLS
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   InterfaceLink           HQM_SFI_TX_PCIE_MERGED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   InterfaceLink           HQM_SFI_TX_PCIE_SHARED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  InterfaceLink           HQM_SFI_TX_RBN
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   InterfaceLink           HQM_SFI_TX_SH_DATA_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    InterfaceLink           HQM_SFI_TX_SH_HDR_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     InterfaceLink           HQM_SFI_TX_SHARED_CREDIT_EN
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  InterfaceLink           HQM_SFI_TX_TBN
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           InterfaceLink           HQM_SFI_TX_TX_CRD_REG
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             InterfaceLink           HQM_SFI_TX_VIRAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   InterfaceLink           HQM_SFI_TX_VR
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   InterfaceLink           HQM_SFI_TX_VT

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name D                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name H                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name M                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   ParamValueFromDesign    true

    set_parameter_attribute HQM_SFI_TX_BLOCK_EARLY_VLD_EN   Value   1
    set_parameter_attribute HQM_SFI_TX_DATA_PARITY_EN       Value   1
    set_parameter_attribute HQM_SFI_TX_DATA_AUX_PARITY_EN   Value   1

    set port_map    {}
    set open_params {}
    set open_ports  {
        hdr_crd_rtn_ded
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

    ############################################
    # SFI::Data (TX)
    ############################################
    set ifc_inst_name "sfi_tx_data"

    create_interface_instance $ifc_inst_name \
        -type provider \
        -interface "SFI::Data" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "sfi_tx_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   Value                   1

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               InterfaceLink           HQM_SFI_TX_BCM_EN
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   InterfaceLink           HQM_SFI_TX_BLOCK_EARLY_VLD_EN
    set_interface_parameter_attribute -instance $ifc_inst_name D                    InterfaceLink           HQM_SFI_TX_D
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   InterfaceLink           HQM_SFI_TX_DATA_AUX_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        InterfaceLink           HQM_SFI_TX_DATA_CRD_GRAN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      InterfaceLink           HQM_SFI_TX_DATA_INTERLEAVE
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        InterfaceLink           HQM_SFI_TX_DATA_LAYER_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       InterfaceLink           HQM_SFI_TX_DATA_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        InterfaceLink           HQM_SFI_TX_DATA_PASS_HDR
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       InterfaceLink           HQM_SFI_TX_DATA_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   InterfaceLink           HQM_SFI_TX_DS
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         InterfaceLink           HQM_SFI_TX_ECRC_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  InterfaceLink           HQM_SFI_TX_FLIT_MODE_PREFIX_EN
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             InterfaceLink           HQM_SFI_TX_FATAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name H                    InterfaceLink           HQM_SFI_TX_H
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         InterfaceLink           HQM_SFI_TX_HDR_DATA_SEP
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        InterfaceLink           HQM_SFI_TX_HDR_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                InterfaceLink           HQM_SFI_TX_HGRAN
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              InterfaceLink           HQM_SFI_TX_HPARITY
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          InterfaceLink           HQM_SFI_TX_IDE_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name M                    InterfaceLink           HQM_SFI_TX_M
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    InterfaceLink           HQM_SFI_TX_MAX_CRD_CNT_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        InterfaceLink           HQM_SFI_TX_MAX_HDR_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                InterfaceLink           HQM_SFI_TX_NDCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                InterfaceLink           HQM_SFI_TX_NHCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     InterfaceLink           HQM_SFI_TX_NUM_SHARED_POOLS
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   InterfaceLink           HQM_SFI_TX_PCIE_MERGED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   InterfaceLink           HQM_SFI_TX_PCIE_SHARED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  InterfaceLink           HQM_SFI_TX_RBN
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   InterfaceLink           HQM_SFI_TX_SH_DATA_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    InterfaceLink           HQM_SFI_TX_SH_HDR_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     InterfaceLink           HQM_SFI_TX_SHARED_CREDIT_EN
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  InterfaceLink           HQM_SFI_TX_TBN
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           InterfaceLink           HQM_SFI_TX_TX_CRD_REG
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             InterfaceLink           HQM_SFI_TX_VIRAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   InterfaceLink           HQM_SFI_TX_VR
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   InterfaceLink           HQM_SFI_TX_VT

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name D                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name H                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name M                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   ParamValueFromDesign    true

    set_parameter_attribute HQM_SFI_TX_BLOCK_EARLY_VLD_EN   Value   1
    set_parameter_attribute HQM_SFI_TX_DATA_PARITY_EN       Value   1
    set_parameter_attribute HQM_SFI_TX_DATA_AUX_PARITY_EN   Value   1

    set port_map    {}
    set open_params {}
    set open_ports  {
        data_trailer
        data_suffix
        data_crd_rtn_ded
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

    ############################################
    # SFI::Globals (RX)
    ############################################
    set ifc_inst_name "sfi_rx_globals"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "SFI::Globals" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "sfi_rx_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   Value                   1

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               InterfaceLink           HQM_SFI_RX_BCM_EN
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   InterfaceLink           HQM_SFI_RX_BLOCK_EARLY_VLD_EN
    set_interface_parameter_attribute -instance $ifc_inst_name D                    InterfaceLink           HQM_SFI_RX_D
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   InterfaceLink           HQM_SFI_RX_DATA_AUX_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        InterfaceLink           HQM_SFI_RX_DATA_CRD_GRAN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      InterfaceLink           HQM_SFI_RX_DATA_INTERLEAVE
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        InterfaceLink           HQM_SFI_RX_DATA_LAYER_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       InterfaceLink           HQM_SFI_RX_DATA_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        InterfaceLink           HQM_SFI_RX_DATA_PASS_HDR
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       InterfaceLink           HQM_SFI_RX_DATA_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   InterfaceLink           HQM_SFI_RX_DS
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         InterfaceLink           HQM_SFI_RX_ECRC_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  InterfaceLink           HQM_SFI_RX_FLIT_MODE_PREFIX_EN
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             InterfaceLink           HQM_SFI_RX_FATAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name H                    InterfaceLink           HQM_SFI_RX_H
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         InterfaceLink           HQM_SFI_RX_HDR_DATA_SEP
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        InterfaceLink           HQM_SFI_RX_HDR_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                InterfaceLink           HQM_SFI_RX_HGRAN
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              InterfaceLink           HQM_SFI_RX_HPARITY
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          InterfaceLink           HQM_SFI_RX_IDE_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name M                    InterfaceLink           HQM_SFI_RX_M
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    InterfaceLink           HQM_SFI_RX_MAX_CRD_CNT_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        InterfaceLink           HQM_SFI_RX_MAX_HDR_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                InterfaceLink           HQM_SFI_RX_NDCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                InterfaceLink           HQM_SFI_RX_NHCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     InterfaceLink           HQM_SFI_RX_NUM_SHARED_POOLS
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   InterfaceLink           HQM_SFI_RX_PCIE_MERGED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   InterfaceLink           HQM_SFI_RX_PCIE_SHARED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  InterfaceLink           HQM_SFI_RX_RBN
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   InterfaceLink           HQM_SFI_RX_SH_DATA_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    InterfaceLink           HQM_SFI_RX_SH_HDR_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     InterfaceLink           HQM_SFI_RX_SHARED_CREDIT_EN
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  InterfaceLink           HQM_SFI_RX_TBN
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           InterfaceLink           HQM_SFI_RX_TX_CRD_REG
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             InterfaceLink           HQM_SFI_RX_VIRAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   InterfaceLink           HQM_SFI_RX_VR
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   InterfaceLink           HQM_SFI_RX_VT

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name D                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name H                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name M                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   ParamValueFromDesign    true

    set_parameter_attribute HQM_SFI_RX_BLOCK_EARLY_VLD_EN   Value   1
    set_parameter_attribute HQM_SFI_RX_DATA_PARITY_EN       Value   1
    set_parameter_attribute HQM_SFI_RX_DATA_AUX_PARITY_EN   Value   1

    set port_map    {}
    set open_params {}
    set open_ports  {
        tx_vendor_field
        rx_vendor_field
        tx_viral
        tx_fatal
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

    ############################################
    # SFI::Header (RX)
    ############################################
    set ifc_inst_name "sfi_rx_header"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "SFI::Header" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "sfi_rx_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   Value                   1

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               InterfaceLink           HQM_SFI_RX_BCM_EN
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   InterfaceLink           HQM_SFI_RX_BLOCK_EARLY_VLD_EN
    set_interface_parameter_attribute -instance $ifc_inst_name D                    InterfaceLink           HQM_SFI_RX_D
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   InterfaceLink           HQM_SFI_RX_DATA_AUX_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        InterfaceLink           HQM_SFI_RX_DATA_CRD_GRAN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      InterfaceLink           HQM_SFI_RX_DATA_INTERLEAVE
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        InterfaceLink           HQM_SFI_RX_DATA_LAYER_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       InterfaceLink           HQM_SFI_RX_DATA_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        InterfaceLink           HQM_SFI_RX_DATA_PASS_HDR
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       InterfaceLink           HQM_SFI_RX_DATA_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   InterfaceLink           HQM_SFI_RX_DS
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         InterfaceLink           HQM_SFI_RX_ECRC_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  InterfaceLink           HQM_SFI_RX_FLIT_MODE_PREFIX_EN
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             InterfaceLink           HQM_SFI_RX_FATAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name H                    InterfaceLink           HQM_SFI_RX_H
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         InterfaceLink           HQM_SFI_RX_HDR_DATA_SEP
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        InterfaceLink           HQM_SFI_RX_HDR_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                InterfaceLink           HQM_SFI_RX_HGRAN
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              InterfaceLink           HQM_SFI_RX_HPARITY
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          InterfaceLink           HQM_SFI_RX_IDE_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name M                    InterfaceLink           HQM_SFI_RX_M
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    InterfaceLink           HQM_SFI_RX_MAX_CRD_CNT_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        InterfaceLink           HQM_SFI_RX_MAX_HDR_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                InterfaceLink           HQM_SFI_RX_NDCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                InterfaceLink           HQM_SFI_RX_NHCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     InterfaceLink           HQM_SFI_RX_NUM_SHARED_POOLS
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   InterfaceLink           HQM_SFI_RX_PCIE_MERGED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   InterfaceLink           HQM_SFI_RX_PCIE_SHARED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  InterfaceLink           HQM_SFI_RX_RBN
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   InterfaceLink           HQM_SFI_RX_SH_DATA_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    InterfaceLink           HQM_SFI_RX_SH_HDR_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     InterfaceLink           HQM_SFI_RX_SHARED_CREDIT_EN
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  InterfaceLink           HQM_SFI_RX_TBN
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           InterfaceLink           HQM_SFI_RX_TX_CRD_REG
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             InterfaceLink           HQM_SFI_RX_VIRAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   InterfaceLink           HQM_SFI_RX_VR
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   InterfaceLink           HQM_SFI_RX_VT

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name D                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name H                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name M                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   ParamValueFromDesign    true

    set_parameter_attribute HQM_SFI_RX_BLOCK_EARLY_VLD_EN   Value   1
    set_parameter_attribute HQM_SFI_RX_DATA_PARITY_EN       Value   1
    set_parameter_attribute HQM_SFI_RX_DATA_AUX_PARITY_EN   Value   1

    set port_map    {}
    set open_params {}
    set open_ports  {
        hdr_crd_rtn_ded
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

    ############################################
    # SFI::Data (RX)
    ############################################
    set ifc_inst_name "sfi_rx_data"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "SFI::Data" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "sfi_rx_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       Value                   1
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   Value                   1

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               InterfaceLink           HQM_SFI_RX_BCM_EN
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   InterfaceLink           HQM_SFI_RX_BLOCK_EARLY_VLD_EN
    set_interface_parameter_attribute -instance $ifc_inst_name D                    InterfaceLink           HQM_SFI_RX_D
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   InterfaceLink           HQM_SFI_RX_DATA_AUX_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        InterfaceLink           HQM_SFI_RX_DATA_CRD_GRAN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      InterfaceLink           HQM_SFI_RX_DATA_INTERLEAVE
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        InterfaceLink           HQM_SFI_RX_DATA_LAYER_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       InterfaceLink           HQM_SFI_RX_DATA_PARITY_EN
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        InterfaceLink           HQM_SFI_RX_DATA_PASS_HDR
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       InterfaceLink           HQM_SFI_RX_DATA_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   InterfaceLink           HQM_SFI_RX_DS
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         InterfaceLink           HQM_SFI_RX_ECRC_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  InterfaceLink           HQM_SFI_RX_FLIT_MODE_PREFIX_EN
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             InterfaceLink           HQM_SFI_RX_FATAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name H                    InterfaceLink           HQM_SFI_RX_H
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         InterfaceLink           HQM_SFI_RX_HDR_DATA_SEP
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        InterfaceLink           HQM_SFI_RX_HDR_MAX_FC_VC
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                InterfaceLink           HQM_SFI_RX_HGRAN
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              InterfaceLink           HQM_SFI_RX_HPARITY
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          InterfaceLink           HQM_SFI_RX_IDE_SUPPORT
    set_interface_parameter_attribute -instance $ifc_inst_name M                    InterfaceLink           HQM_SFI_RX_M
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    InterfaceLink           HQM_SFI_RX_MAX_CRD_CNT_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        InterfaceLink           HQM_SFI_RX_MAX_HDR_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                InterfaceLink           HQM_SFI_RX_NDCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                InterfaceLink           HQM_SFI_RX_NHCRD
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     InterfaceLink           HQM_SFI_RX_NUM_SHARED_POOLS
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   InterfaceLink           HQM_SFI_RX_PCIE_MERGED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   InterfaceLink           HQM_SFI_RX_PCIE_SHARED_SELECT
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  InterfaceLink           HQM_SFI_RX_RBN
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   InterfaceLink           HQM_SFI_RX_SH_DATA_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    InterfaceLink           HQM_SFI_RX_SH_HDR_CRD_BLK_SZ
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     InterfaceLink           HQM_SFI_RX_SHARED_CREDIT_EN
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  InterfaceLink           HQM_SFI_RX_TBN
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           InterfaceLink           HQM_SFI_RX_TX_CRD_REG
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             InterfaceLink           HQM_SFI_RX_VIRAL_EN
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   InterfaceLink           HQM_SFI_RX_VR
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   InterfaceLink           HQM_SFI_RX_VT

    set_interface_parameter_attribute -instance $ifc_inst_name BCM_EN               ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name BLOCK_EARLY_VLD_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name D                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_AUX_PARITY_EN   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_CRD_GRAN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_INTERLEAVE      ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_LAYER_EN        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PARITY_EN       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_PASS_HDR        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DATA_MAX_FC_VC       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DS                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name ECRC_SUPPORT         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FLIT_MODE_PREFIX_EN  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name FATAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name H                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_DATA_SEP         ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HDR_MAX_FC_VC        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HGRAN                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name HPARITY              ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name IDE_SUPPORT          ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name M                    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_CRD_CNT_WIDTH    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_HDR_WIDTH        ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NDCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NHCRD                ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name NUM_SHARED_POOLS     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_MERGED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name PCIE_SHARED_SELECT   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name RBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_DATA_CRD_BLK_SZ   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SH_HDR_CRD_BLK_SZ    ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name SHARED_CREDIT_EN     ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TBN                  ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name TX_CRD_REG           ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VIRAL_EN             ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VR                   ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name VT                   ParamValueFromDesign    true

    set_parameter_attribute HQM_SFI_RX_BLOCK_EARLY_VLD_EN   Value   1
    set_parameter_attribute HQM_SFI_RX_DATA_PARITY_EN       Value   1
    set_parameter_attribute HQM_SFI_RX_DATA_AUX_PARITY_EN   Value   1

    set port_map    {}
    set open_params {}
    set open_ports  {
        data_trailer
        data_suffix
        data_crd_rtn_ded
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

    ##################################################
    # Reset
    ##################################################
    set ifc_inst_name "prim_reset"

    create_interface_instance $ifc_inst_name \
        -interface "Reset" \
        -type consumer \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat ""

    set port_map {
        VCC_PWRGOOD_RST_B       powergood_rst_b
        VCC_LOGIC_RST_B         prim_rst_b
        CG_WAKE                 pma_safemode
        PG_WAKE                 prim_pwrgate_pmc_wake
    }
    set open_params {}
    set open_ports  {
        VCC_PWRGOOD
        VCC_ISO_B
        FORCEPGPOK_NOPG
        FORCEPGPOK_PG
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ##################################################
    # CLOCK_REQ_ACK
    ##################################################
    set ifc_inst_name "prim_clock_req_ack"

    create_interface_instance $ifc_inst_name \
        -interface "CLOCK_REQ_ACK" \
        -type consumer \
        -version "2.0_r1.0__v2.0_r1.0" \
        -associationformat "prim_%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

 } else {

    ############################################
    #IOSF::Primary::Clock
    ############################################
    set ifc_inst_name "iosf_primary_clock"

    create_interface_instance $ifc_inst_name \
       -type consumer \
       -interface "IOSF::Primary::Clock" \
       -version "1.2.3" \
       -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::Primary::Reset
    ############################################
    set ifc_inst_name "iosf_primary_reset"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::Primary::Reset" \
        -version "1.2.3" \
        -associationformat "%s"

    set_interface_parameter_attribute -instance $ifc_inst_name ImplementsStickyResetRegister Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name Bogus                         Value 0

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::Primary::Pok
    ############################################
    set ifc_inst_name "iosf_primary_pok"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::Primary::Pok" \
        -version "1.2.3" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ######################################################################
    #Collage        3.328.a MANUAL - Define Interface to clock association in the IP build script on IOSF Primary/Sideband Power and Clock REQ/ACK Interfaces (RTL0P8)
    collage_set_interface_clocks -ifc_inst_name $ifc_inst_name -clocks "PRIM_CLK prim_clk"

    ############################################
    #IOSF::Primary::Power
    ############################################
    set ifc_inst_name "iosf_primary_power"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::Primary::Power" \
        -version "1.2.3" \
        -associationformat "%s"

    set_interface_parameter_attribute -instance $ifc_inst_name CanDeassertPrimClkReq Value 1

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::Primary
    ############################################
    set ifc_inst_name "iosf_primary"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::Primary" \
        -version "1.2.3" \
        -associationformat "%s"

    set_interface_parameter_attribute -instance $ifc_inst_name HasAgentSpecificReqAttr       Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name HasTransactionHintSupport     Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name HasTransactionErrorSupport    Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name IosfAgentId                   Value "hqm_sip"
    set_interface_parameter_attribute -instance $ifc_inst_name IsPciePort                    Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name IsPcieSwitch                  Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name MlengthSize                   Value 9
    set_interface_parameter_attribute -instance $ifc_inst_name ReqTcSize                     Value 4
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsAddressTranslation    Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsDeadline              Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsIdBasedOrdering       Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsMasterDestId          Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsMasterSAI             Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsMasterSrcId           Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsMultipleChannels      Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsParityLogic           Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsPASID                 Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsRequestChaining       Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsRootSpace             Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsTargetCmdChaining     Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsTargetDestId          Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsTargetEcrcError       Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsTargetEcrcGenerate    Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsTargetSAI             Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name SupportsTargetSrcId           Value 1
    set_interface_parameter_attribute -instance $ifc_inst_name WaiveFabric                   Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name WaiveAgent                    Value 1

    set_interface_parameter_attribute -instance $ifc_inst_name MNUMCHAN                      Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name TNUMCHAN                      Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name MNUMCHANL2                    Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name TNUMCHANL2                    Value 0
    set_interface_parameter_attribute -instance $ifc_inst_name DEADLINE_WIDTH                Value 0

    set_interface_parameter_attribute -instance $ifc_inst_name MAX_DATA_LEN             InterfaceLink        MAX_DATA_LEN
    set_interface_parameter_attribute -instance $ifc_inst_name MAX_DATA_LEN             ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name DST_ID_WIDTH             InterfaceLink        DST_ID_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name DST_ID_WIDTH             ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name SRC_ID_WIDTH             InterfaceLink        SRC_ID_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name SRC_ID_WIDTH             ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name SAI_WIDTH                InterfaceLink        SAI_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name SAI_WIDTH                ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name AGENT_WIDTH              InterfaceLink        AGENT_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name AGENT_WIDTH              ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name MMAX_ADDR                InterfaceLink        MMAX_ADDR
    set_interface_parameter_attribute -instance $ifc_inst_name MMAX_ADDR                ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name TMAX_ADDR                InterfaceLink        TMAX_ADDR
    set_interface_parameter_attribute -instance $ifc_inst_name TMAX_ADDR                ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name MD_WIDTH                 InterfaceLink        MD_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MD_WIDTH                 ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name TD_WIDTH                 InterfaceLink        TD_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name TD_WIDTH                 ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name RS_WIDTH                 InterfaceLink        RS_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name RS_WIDTH                 ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name PARITY_REQUIRED          InterfaceLink        PARITY_REQUIRED
    set_interface_parameter_attribute -instance $ifc_inst_name PARITY_REQUIRED          ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name INACTIVE_ZERO_MODE_EN    InterfaceLink        INACTIVE_ZERO_MODE_EN
    set_interface_parameter_attribute -instance $ifc_inst_name INACTIVE_ZERO_MODE_EN    ParamValueFromDesign true

    set port_map    {}
    set open_params {}
    set open_ports  {
        MBEWD
        MDBE
        MECRC_GENERATE
        MECRC_ERROR
        MRSVD1_1
        MRSVD0_7
        MCREDIT_PUT
        MCREDIT_CHID
        MCREDIT_RTYPE
        MCREDIT_DATA
        MCREDIT_CMD
        MCMD_PUT
        MCMD_CHID
        MCMD_RTYPE
        MCMD_NFS_ERR
        MPRIORITY
        MCHAIN	
        OBFF
        TBEWD
        TDBE
        TRSVD1_1
        TRSVD0_7
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports

    ##################################################
    # Reset
    ##################################################
    set ifc_inst_name "prim_reset"

    create_interface_instance $ifc_inst_name \
        -interface "Reset" \
        -type consumer \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat ""

    # powergood_rst_b and prim_rst_b are part of the IOSF reset std interface

    set port_map    {
        CG_WAKE                 pma_safemode
        PG_WAKE                 prim_pwrgate_pmc_wake
    }
    set open_params {}
    set open_ports  {
        VCC_PWRGOOD
        VCC_ISO_B
        VCC_PWRGOOD_RST_B
        VCC_LOGIC_RST_B
        FORCEPGPOK_NOPG
        FORCEPGPOK_PG
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

 }

    ##################################################
    # Sideband Wake
    ##################################################
    set ifc_inst_name "iosf_sideband_wake"

    create_interface_instance $ifc_inst_name \
        -interface "wake_intf" \
        -type consumer \
        -version "1.0__1.0" \
        -associationformat ""

    # powergood_rst_b and prim_rst_b are part of the IOSF reset std interface

    set port_map    {
        PG_WAKE                 side_pwrgate_pmc_wake
    }
    set open_params {}
    set open_ports  {
        CG_WAKE
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #IOSF::SB::Clock
    ############################################
    set ifc_inst_name "iosf_sideband_clock"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::SB::Clock" \
        -version "1.4_r1.3__v1.4_r1.3" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::SB::Reset
    ############################################
    set ifc_inst_name "iosf_sideband_reset"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::SB::Reset" \
        -version "1.4_r1.3__v1.4_r1.3" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::SB::Pok
    ############################################
    set ifc_inst_name "iosf_sideband_pok"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::SB::Pok" \
        -version "1.4_r1.3__v1.4_r1.3" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::SB::Power
    ############################################
    set ifc_inst_name "iosf_sideband_power"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::SB::Power" \
        -version "1.4_r1.3__v1.4_r1.3" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::SB::IdStraps
    ############################################
    set ifc_inst_name "iosf_sideband_idstraps"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::SB::IdStraps" \
        -version "1.4_r1.3__v1.4_r1.3" \
        -associationformat "%s"

    set port_map    {
        my_sb_id            strap_hqm_gpsb_srcid
        aer_destid          strap_hqm_err_sb_dstid
        pcie_err_destid     strap_hqm_do_serr_dstid
    }
    set open_params {}
    set open_ports  {
        fuse_contoller_destid
        fuse_controller_srcid
        soft_strap_controller_destid
        soft_strap_controller_srcid
        pmu_destid
        pmu_srcid
        spi_destid
        spi_srcid
        lpc_destid
        lpc_srcid
        smi_destid
        smi_srcid
        aer_srcid
        time_sync_destid
        time_sync_srcid
        mca_destid
        mca_srcid
        pmon_destid
        pmon_srcid
        pcie_err_srcid
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #IOSF::SB
    ############################################
    set ifc_inst_name "iosf_sideband"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::SB" \
        -version "1.4_r1.3__v1.4_r1.3" \
        -associationformat "gpsb_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name SB_PARITY_REQUIRED  Value                1

    set_interface_parameter_attribute -instance $ifc_inst_name MESSAGEPAYLOADWIDTH InterfaceLink        HQM_SBE_DATAWIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name MESSAGEPAYLOADWIDTH ParamValueFromDesign true
    set_interface_parameter_attribute -instance $ifc_inst_name SB_PARITY_REQUIRED  InterfaceLink        HQM_SBE_PARITY_REQUIRED
    set_interface_parameter_attribute -instance $ifc_inst_name SB_PARITY_REQUIRED  ParamValueFromDesign true

    set_parameter_attribute HQM_SBE_PARITY_REQUIRED     Value   1

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ##################################################
    # Remote TDR Clock Interfaces
    ##################################################
    set ifc_inst_name "rtdr_tapconfig_clock"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR::Clock" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_TCK                rtdr_tapconfig_tck
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    set ifc_inst_name "rtdr_taptrigger_clock"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR::Clock" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_TCK                rtdr_taptrigger_tck
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    set ifc_inst_name "rtdr_iosfsb_ism_clock"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR::Clock" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_TCK                rtdr_iosfsb_ism_tck
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ##################################################
    # Remote TDR Reset Interfaces
    ##################################################
    set ifc_inst_name "rtdr_tapconfig_reset"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR::Reset" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_PWRGOOD_RST_B      rtdr_tapconfig_trst_b
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    set ifc_inst_name "rtdr_taptrigger_reset"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR::Reset" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_PWRGOOD_RST_B      rtdr_taptrigger_trst_b
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    set ifc_inst_name "rtdr_iosfsb_ism_reset"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR::Reset" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_PWRGOOD_RST_B      rtdr_iosfsb_ism_trst_b
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ##################################################
    # Remote TDR interfaces
    ##################################################
    set ifc_inst_name "rtdr_tapconfig"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_CAPTURE            rtdr_tapconfig_capturedr
        RTDR_IRDEC              rtdr_tapconfig_irdec
        RTDR_SHIFT              rtdr_tapconfig_shiftdr
        RTDR_TDI                rtdr_tapconfig_tdi
        RTDR_TDO                rtdr_tapconfig_tdo
        RTDR_UPDATE             rtdr_tapconfig_updatedr
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    set ifc_inst_name "rtdr_taptrigger"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_CAPTURE            rtdr_taptrigger_capturedr
        RTDR_IRDEC              rtdr_taptrigger_irdec
        RTDR_SHIFT              rtdr_taptrigger_shiftdr
        RTDR_TDI                rtdr_taptrigger_tdi
        RTDR_TDO                rtdr_taptrigger_tdo
        RTDR_UPDATE             rtdr_taptrigger_updatedr
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    set ifc_inst_name "rtdr_iosfsb_ism"

    create_interface_instance $ifc_inst_name \
        -interface "IOSF::DFX::RTDR" \
        -type consumer \
        -version "1.5_r1.1__v1.5_r1.1" \
        -associationformat ""

    set port_map {
        RTDR_CAPTURE            rtdr_iosfsb_ism_capturedr
        RTDR_IRDEC              rtdr_iosfsb_ism_irdec
        RTDR_SHIFT              rtdr_iosfsb_ism_shiftdr
        RTDR_TDI                rtdr_iosfsb_ism_tdi
        RTDR_TDO                rtdr_iosfsb_ism_tdo
        RTDR_UPDATE             rtdr_iosfsb_ism_updatedr
    }
    set open_params {}
    set open_ports  {}

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ##################################################
    # digital viewpins
    ##################################################
    set ifc_inst_name "viewpins_dig"

    create_interface_instance $ifc_inst_name \
        -interface "ViewPin" \
        -type consumer \
        -version "1.0_r1.2__v1.0_r1.2" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {
        ana_view_out_0
        ana_view_out_1
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

    ############################################
    #IOSF::DFX::SCAN
    ############################################
    set ifc_inst_name "scan"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::DFX::SCAN" \
        -version "2.4_r1.4__v2.4_r1.4" \
        -associationformat "%s"

    set_interface_parameter_attribute -instance $ifc_inst_name SCAN_INDEX       Value "0"
    set_interface_parameter_attribute -instance $ifc_inst_name SCAN_PREFIX      Value "hqm_"

    set port_map    {}
    set open_params {}
    set open_ports  {
        FSCAN_SDI
        ASCAN_SDO
        FSCAN_MODE_ATSPEED
        FSCAN_BYPLATRST_B
        FSCAN_CLKGENCTRL
        FSCAN_CLKGENCTRLEN
        FSCAN_MODE_POSTSCC
        FSCAN_INTEST
        FSCAN_EXTEST
        FSCAN_SLOS_EN
        FSCAN_TPI_CONTROL_EN
        FSCAN_TPI_OBSERVE_EN
        FSCAN_RAM_BYPSEL
        FSCAN_RAM_INIT_EN
        FSCAN_RAM_INIT_VAL
        FSCAN_RAM_RDDIS_B
        FSCAN_RAM_WRDIS_B
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports

    ############################################
    #IOSF::DFX::SCAN::Reset
    ############################################
    set ifc_inst_name "scan_reset"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::DFX::SCAN::Reset" \
        -version "2.4_r1.4__v2.4_r1.4" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #DTF::Clock (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf_clock"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "DTF::Clock" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #DTF::Reset (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf_reset"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "DTF::Reset" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #DTF::Signals (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf"

    create_interface_instance $ifc_inst_name \
        -type provider \
        -interface "DTF::Signals" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat ""

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       Value                   64
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     Value                   25
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_PG_INTERFACE     Value                   0
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_ISO_INTERFACE    Value                   0

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       InterfaceLink           HQM_DTF_DATA_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     InterfaceLink           HQM_DTF_HEADER_WIDTH

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     ParamValueFromDesign    true

    set_parameter_attribute                                    HQM_DTF_DATA_WIDTH   Value                   64
    set_parameter_attribute                                    HQM_DTF_HEADER_WIDTH Value                   25

    set port_map    {
        fdtf_upstream_active_in     fdtf_upstream_active
        fdtf_upstream_credit_in     fdtf_upstream_credit
        fdtf_upstream_sync_in       fdtf_upstream_sync
        adtf_dnstream_data_out      adtf_dnstream_data
        adtf_dnstream_header_out    adtf_dnstream_header
        adtf_dnstream_valid_out     adtf_dnstream_valid
    }
    set open_params {}
    set open_ports  {}

    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #DTF::Misc (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf_misc"

    create_interface_instance $ifc_inst_name \
        -type provider \
        -interface "DTF::Misc" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat "%s"

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       Value                   64
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     Value                   25
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_PG_INTERFACE     Value                   0
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_ISO_INTERFACE    Value                   0

    set port_map    {
        fdtf_packetizer_cid_N       fdtf_packetizer_cid
        fdtf_packetizer_mid_N       fdtf_packetizer_mid
    }
    set open_params {}
    set open_ports  {
        adtf_rst_out_b
        fdtf_iso_b
        fdtf_pg_empty_in
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #APB4 (for DVP)
    ############################################
    set ifc_inst_name "dvp_apb4"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "APB4" \
        -version "2.0_r1.0__vC_r1.0" \
        -associationformat "dvp_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name PADDR_WIDTH   Value  32
    set_interface_parameter_attribute -instance $ifc_inst_name PDATA_WIDTH   Value  32
    set_interface_parameter_attribute -instance $ifc_inst_name PSEL_WIDTH    Value  1

    set port_map    {
        PSELx           dvp_psel
    }
    set open_params {}
    set open_ports  {}

    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #CTF::Signals (for DVP)
    ############################################
    set ifc_inst_name "dvp_ctf"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "CTF::Signals" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "*%s"

    set_interface_parameter_attribute -instance $ifc_inst_name TRIGFABWIDTH         Value                   4
    set_interface_parameter_attribute -instance $ifc_inst_name TRIGFABWIDTH         InterfaceLink           HQM_TRIGFABWIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name TRIGFABWIDTH         ParamValueFromDesign    true
    set_parameter_attribute                                    HQM_TRIGFABWIDTH     Value                   4

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::DFX::DSP_INSIDE (for DVP dfx_secureplugin)
    ############################################
    set ifc_inst_name "dvp_dsp_inside"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::DFX::DSP_INSIDE" \
        -version "2.0_r1.2__v2.0_r1.2" \
        -associationformat ""

    set_interface_parameter_attribute -instance $ifc_inst_name DFX_SECURE_WIDTH     Value                   8

    set port_map    {
        DEBUG_CAPABILITIES_ENABLING         fdfx_debug_cap
        DEBUG_CAPABILITIES_ENABLING_VALID   fdfx_debug_cap_valid
        DFX_SECURE_POLICY                   fdfx_security_policy
        EARLYBOOT_EXIT                      fdfx_earlyboot_debug_exit
        POLICY_UPDATE                       fdfx_policy_update
    }
    set open_params {}
    set open_ports  {}

    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    return
}

######################################################################
#/p/hdk/rtl/cad/x86-64_linux30/intel/bus_interface_defs/0.07/IOSF__DFX__RTDR/v1.5/coretools/iosf_dfx_rtdr_interface.v1.5_r1.1.tcl
collage_add_ifc_def_files -files "\
    iosf_primary_interface.1.2.3.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__SB/v1.4/coretools/iosf_sb_clock_interface.v1.4_r1.3.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__SB/v1.4/coretools/iosf_sb_idstraps_interface.v1.4_r1.3.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__SB/v1.4/coretools/iosf_sb_interface.v1.4_r1.3.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__SB/v1.4/coretools/iosf_sb_pok_interface.v1.4_r1.3.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__SB/v1.4/coretools/iosf_sb_power_interface.v1.4_r1.3.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__SB/v1.4/coretools/iosf_sb_reset_interface.v1.4_r1.3.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__RTDR/v1.5/coretools/iosf_dfx_rtdr_clock_interface.v1.5_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__RTDR/v1.5/coretools/iosf_dfx_rtdr_reset_interface.v1.5_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__RTDR/v1.5/coretools/iosf_dfx_rtdr_interface.v1.5_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/Reset/v1.0/coretools/reset_interface.v1.0_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/CLOCK_REQ_ACK/v2.0/coretools/clock_req_ack_interface.v2.0_r1.0.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/wake_intf/1.0/coretools/wake_intf_interface.1.0.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/ViewPin/v1.0/coretools/viewpin_interface.v1.0_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__SCAN/v2.4/coretools/iosf_dfx_scan_interface.v2.4_r1.4.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__SCAN/v2.4/coretools/iosf_dfx_scan_reset_interface.v2.4_r1.4.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/SFI/v1.0/coretools/sfi_globals_interface.v1.0_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/SFI/v1.0/coretools/sfi_header_interface.v1.0_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/SFI/v1.0/coretools/sfi_data_interface.v1.0_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_signals_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_clock_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_reset_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_misc_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/CTF/v1.0/coretools/ctf_signals_interface.v1.0_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/APB4/vC/coretools/apb4_interface.vC_r1.0.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__DSP/v2.0/coretools/iosf_dfx_dsp_inside_interface.v2.0_r1.2.tcl \
"

######################################################################
# Create workspace (see help for options)
######################################################################
collage_create_workspace -replace

######################################################################
# Run the build flow (see help for options)
######################################################################
collage_simple_build_flow -exit -copy_corekit -dont_create_ws

#====================#
# END OF CATCH BLOCK #
#====================#
} ] } {
   puts stderr "\n\nERROR (Code = ${::errorCode}):\n${::errorInfo}\n"
   exit 1
}
#====================#
