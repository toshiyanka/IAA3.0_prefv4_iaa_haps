set ivar(design_name) "devtlb"

set ivar(rtl_list) "$env(ward)/fe_collateral/devtlb/rtl_list_2stage.tcl"
#$ivar(collateral_dir)/fe_collateral/rtl_list_2stage.tcl

set ivar(pwr,upf_enable)  1
set ivar(pwr,upf_for_rtl) "$env(ward)/fe_collateral/devtlb/devtlb.upf"
set ivar(design_cfg)  ""

set ivar(fe_collateral_dir)      "$env(ward)/fe_collateral/devtlb"
set ivar(collateral_dir)         "$env(ward)/fe_collateral/devtlb"
set ivar(fev_rtl2syn,golden)     "$env(ward)/fe_collateral/devtlb/rtl_list_2stage.tcl"
set ivar(fev_rtl2syn,revised)    "$env(ward)/runs/devtlb/1276.31/apr_fc/outputs/compile_final_opto/devtlb.pt.v"
set ivar(fev_rtl2syn,golden_upf)  "$env(ward)/fe_collateral/devtlb/devtlb.upf"
set ivar(fev_rtl2syn,revised_upf) "$env(ward)/fe_collateral/devtlb/devtlb.upf"
set ivar(fev_rtl2syn,resource_file_path) "$env(ward)/runs/devtlb/1276.31/apr_fc/outputs/compile_final_opto/devtlb.resource"
set ivar(td_collateral_dir)      "$env(ward)/fe_collateral/devtlb"
set ivar(timing_collateral_dir)  "$env(ward)/fe_collateral/devtlb"
set ivar(fev_rtl2syn,guidence_file_path) "$env(ward)/runs/devtlb/1276.31/apr_fc/outputs/compile_final_opto/devtlb.vsdc"
