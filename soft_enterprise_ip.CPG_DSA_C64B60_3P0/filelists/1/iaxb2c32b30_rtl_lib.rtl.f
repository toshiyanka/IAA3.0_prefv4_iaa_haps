-f $ip/filelists/dsa_subip_rtl_lib.rtl.f 
-f $ip/filelists/dsa_common_rtl_lib.rtl.f
-f $ip/filelists/iaxb_common_rtl_lib.rtl.f
-f $ip/filelists/iaxb2c32b30_mem_rtl_lib.rtl.f

#Generated by Collage
$ip/verif/wrappers/eip/iax/iax2c32b30/iaxb2c32b30.sv
$ip/src/rtl/eip/iax2c32b30/iaxb2c32b30_ip.sv
$ip/src/rtl/eip/iax2c32b30/iaxb2c32b30_aon.sv
$ip/src/rtl/eip/iax2c32b30/iaxb2c32b30_csr.sv
#Generated by Collage
$ip/src/rtl/eip/iax2c32b30/iaxb2c32b30_mem.sv
$ip/src/gen/iax2c32b30_csr_cfg.sv
$ip/src/gen/iax2c32b30_csr_mem.sv

##LNL
$ip/src/rtl/ipi/dsa_ipi_mcredit.sv
$ip/src/rtl/ipi/dsa_ipi_c_trk.sv
$ip/src/rtl/ipi/dsa_ipi_h2d_data.sv
$ip/src/rtl/ipi/dsa_ipi_h2d_rsp.sv
$ip/src/rtl/common/dsa_icxl_c_d.sv

## Visa Replay Status Register
$ip/src/rtl/top/dsa_vrs.sv

######################################################################
# PG FSM 
######################################################################

$ip/subIP/pg_fsm/dsa_mcr_generic_hw_macros__mcr_pd__.vh
$ip/subIP/pg_fsm/dsa_spy_clocks__mcr_pd__.sv
$ip/subIP/pg_fsm/dsa_mcr_ctech_map__mcr_pd__.sv
$ip/subIP/pg_fsm/dsa_random_delay__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_mcr_async_random_delay__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_mcr_parameterized_encoder__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_drv_2__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_drv_3__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_rst_metaflop_2__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_rst_metaflop_2__oc_det__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_rst_metaflop_3__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_rst_metaflop_3__oc_det__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_set_metaflop_2__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_set_metaflop_2__oc_det__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_set_metaflop_3__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_async_set_metaflop_3__oc_det__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_metaflop_2_oc_det__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_metaflop_3__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_metaflop_3_oc_det__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_metaflop_generic__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_metaflop_2__mcr_pd__.vs
$ip/subIP/pg_fsm/dsa_INST_ON.sv
$ip/subIP/pg_fsm/dsa_INTEL_GLOBAL_MACROS.vh
$ip/subIP/pg_fsm/dsa_pd_async_random_delay.vs
$ip/subIP/pg_fsm/dsa_pd_generic_hw_macros.vh
$ip/subIP/pg_fsm/dsa_sva_control_assertion_delay.sv
$ip/subIP/pg_fsm/dsa_pd_sva_lib_sva_library_pkg.vs
$ip/subIP/pg_fsm/dsa_pd_sva_library_pkg.vs
$ip/subIP/pg_fsm/dsa_power_delivery_common.vh
$ip/subIP/pg_fsm/dsa_power_delivery_params.vh
$ip/subIP/pg_fsm/dsa_pg_fsm_sva_control.sv
$ip/subIP/pg_fsm/dsa_assert_xcheck_pg_fsm.vs
$ip/subIP/pg_fsm/dsa_pg_fsm.vs

+incdir+$ip/subIP/pg_fsm

######################################################################

+incdir+$ip/src/gen
+incdir+$ip/src/rtl/dsa
+incdir+$ip/src/rtl/iax
+incdir+$ip/src/rtl/sbw
+incdir+$ip/src/rtl/eip
+incdir+$ip/src/rtl/common
