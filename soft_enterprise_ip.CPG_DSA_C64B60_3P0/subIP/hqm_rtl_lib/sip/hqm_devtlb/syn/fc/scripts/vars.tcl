##flow

set ivar(design_name) "devtlb"

set ivar(rtl_list) "$env(ward)/fe_collateral/devtlb/rtl_list_2stage.tcl"
#$ivar(collateral_dir)/fe_collateral/rtl_list_2stage.tcl

set ivar(pwr,upf_enable)  1
set ivar(pwr,upf_for_rtl) "$env(ward)/fe_collateral/devtlb/devtlb.upf"
#"$ivar(collateral_dir)/fe_collateral/$ivar(design_name).upf"
set ivar(design_cfg)  ""

set ivar(timing_constraint)      "$env(ward)/fe_collateral/devtlb/devtlb_aprfc_constraints.tcl"

set ivar(td_collateral_dir)      "$env(ward)/fe_collateral/devtlb"
set ivar(timing_collateral_dir)  "$env(ward)/fe_collateral/devtlb"

#INTEL_INFO   : Initializing ::ivar(td_collateral_dir) = '/nfs/pdx/proj/acd/fe.243/work/skuriako/cct/devtlb/cheetah/devtlb_0p3/WW08.1_DevTLB_jason/output/devtlb/h2b/devtlb/runs/devtlb/1276.31/release/latest/td_collateral' [Fri Feb 19 15:27:24 2021]
#INTEL_INFO   : Initializing ::ivar(fe_collateral_dir) = '/nfs/pdx/proj/acd/fe.243/work/skuriako/cct/devtlb/cheetah/devtlb_0p3/WW08.1_DevTLB_jason/output/devtlb/h2b/devtlb/runs/devtlb/1276.31/release/latest/fe_collateral' [Fri Feb 19 15:27:24 2021]
#INTEL_INFO   : Initializing ::ivar(timing_collateral_dir) = '/nfs/pdx/proj/acd/fe.243/work/skuriako/cct/devtlb/cheetah/devtlb_0p3/WW08.1_DevTLB_jason/output/devtlb/h2b/devtlb/runs/devtlb/1276.31/release/latest/timing_collateral' [Fri Feb 19 15:27:24 2021]

set ivar(voltage_file) "$env(ward)/fe_collateral/devtlb/devtlb_set_voltage.tcl"
set ivar(dft,insert_scan) 0
set ivar(hpml,devtlb) ""
