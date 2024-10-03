// RTL Generated using Collage

module iaa3p0s64b60 (
    input           cg_wake,
    input           fscan_byprst_b,
    input           fscan_clkungate,
    input           fscan_clkungate_syn,
    input           fscan_latchclosed_b,
    input           fscan_latchopen,
    input           fscan_mode,
    input           fscan_ram_bypsel,
    input           fscan_ram_init_en,
    input           fscan_ram_init_val,
    input           fscan_ram_rddis_b,
    input           fscan_ram_wrdis_b,
    input           fscan_ret_ctrl,
    input           fscan_rstbypen,
    input           fscan_shiften,
    input           fvisa_frame,
    input           fvisa_serdata,
    input           fvisa_serstb,
    input           pg_wake,
    input           prim_clk,
    input   [7:0]   strap_cpl_sai,
    input   [4:0]   strap_device_num,
    input   [7:0]   strap_err_sai,
    input   [15:0]  strap_err_sb_id,
    input   [7:0]   strap_ltr_sai,
    input   [15:0]  strap_ltr_sb_id,
    input   [7:0]   strap_mem_sai,
    input   [7:0]   strap_pm_sai,
    input   [7:0]   strap_resetprepack_sai,
    input   [63:0]  strap_sai_pol_boot_w_cp,
    input   [63:0]  strap_sai_pol_boot_w_rac,
    input   [63:0]  strap_sai_pol_boot_w_wac,
    input   [63:0]  strap_sai_pol_os_w_cp,
    input   [63:0]  strap_sai_pol_os_w_rac,
    input   [63:0]  strap_sai_pol_os_w_wac,
    input   [63:0]  strap_sai_pol_p_u_code_cp,
    input   [63:0]  strap_sai_pol_p_u_code_rac,
    input   [63:0]  strap_sai_pol_p_u_code_wac,
    input   [7:0]   strap_setid_opcode,
    input   [7:0]   strap_setid_sai,
    input           strap_untranslated_hpa_allowed,
    input           vcc_logic_rst_b,
    input           vcc_pwrgood_rst_b,
    // Ports for Interface boot_config
    input           configdone,
    // Ports for Interface iosf_dfx_secure
    input   [3:0]   fdfx_secure_policy,
    input           fdfx_earlyboot_exit,
    input           fdfx_policy_update,
    // Ports for Interface iosf_dfx_visa_primclk_0
    output          avisa_primclk_0,
    output  [7:0]   avisa_dbgbus_primclk_0,
    // Ports for Interface iosf_dfx_visa_primclk_1
    output          avisa_primclk_1,
    output  [7:0]   avisa_dbgbus_primclk_1,
    // Ports for Interface iosf_dfx_visa_primclk_2
    output          avisa_primclk_2,
    output  [7:0]   avisa_dbgbus_primclk_2,
    // Ports for Interface iosf_dfx_visa_primclk_3
    output          avisa_primclk_3,
    output  [7:0]   avisa_dbgbus_primclk_3,
    // Ports for Interface iosf_dfx_visa_primclk_4
    output          avisa_primclk_4,
    output  [7:0]   avisa_dbgbus_primclk_4,
    // Ports for Interface iosf_dfx_visa_primclk_5
    output          avisa_primclk_5,
    output  [7:0]   avisa_dbgbus_primclk_5,
    // Ports for Interface iosf_dfx_visa_primclk_6
    output          avisa_primclk_6,
    output  [7:0]   avisa_dbgbus_primclk_6,
    // Ports for Interface iosf_dfx_visa_primclk_7
    output          avisa_primclk_7,
    output  [7:0]   avisa_dbgbus_primclk_7,
    // Ports for Interface iosf_dfx_visa_sideclk_8
    output          avisa_sideclk_8,
    output  [7:0]   avisa_dbgbus_sideclk_8,
    // Ports for Interface iosf_dfx_visastrap
    input   [8:0]   fvisa_startid,
    // Ports for Interface iosf_fdfx_reset
    input           fdfx_powergood,
    // Ports for Interface iosf_primpok
    output          prim_pok,
    // Ports for Interface iosf_sb
    input           mnpcup,
    input           mpccup,
    input   [2:0]   side_ism_fabric,
    input           teom,
    input           tnpput,
    input   [7:0]   tpayload,
    input           tpcput,
    output          meom,
    output          mnpput,
    output  [7:0]   mpayload,
    output          mpcput,
    output  [2:0]   side_ism_agent,
    output          tnpcup,
    output          tpccup,
    // Ports for Interface iosf_sb_clk
    input           side_clk,
    // Ports for Interface iosf_sb_dfx_ism
    input           fismsdfx_clkgate_ovrd,
    input           fismsdfx_force_clkreq,
    input           fismsdfx_force_creditreq,
    input           fismsdfx_force_idle,
    input           fismsdfx_force_notidle,
    // Ports for Interface iosf_sb_pok
    output          side_pok,
    // Ports for Interface iosf_sb_pwr
    input           side_clkack,
    output          side_clkreq,
    // Ports for Interface iosf_sb_strap
    input   [15:0]  strap_sb_id,
    // Ports for Interface sfi_a2f_data
    input           a2f_data_block,
    input           a2f_data_crd_rtn_ded,
    input   [1:0]   a2f_data_crd_rtn_fc_id,
    input           a2f_data_crd_rtn_valid,
    input   [3:0]   a2f_data_crd_rtn_value,
    input   [4:0]   a2f_data_crd_rtn_vc_id,
    output  [511:0] a2f_data,
    output          a2f_data_aux_parity,
    output          a2f_data_crd_rtn_block,
    output          a2f_data_early_valid,
    output  [15:0]  a2f_data_edb,
    output  [15:0]  a2f_data_end,
    output  [7:0]   a2f_data_info_byte,
    output  [7:0]   a2f_data_parity,
    output  [15:0]  a2f_data_poison,
    output          a2f_data_start,
    output          a2f_data_valid,
    // Ports for Interface sfi_a2f_global
    input           a2f_rx_empty,
    input           a2f_rxcon_ack,
    input           a2f_rxdiscon_nack,
    output          a2f_txcon_req,
    // Ports for Interface sfi_a2f_hdr
    input           a2f_hdr_block,
    input           a2f_hdr_crd_rtn_ded,
    input   [1:0]   a2f_hdr_crd_rtn_fc_id,
    input           a2f_hdr_crd_rtn_valid,
    input   [3:0]   a2f_hdr_crd_rtn_value,
    input   [4:0]   a2f_hdr_crd_rtn_vc_id,
    output          a2f_hdr_crd_rtn_block,
    output          a2f_hdr_early_valid,
    output  [15:0]  a2f_hdr_info_bytes,
    output          a2f_hdr_valid,
    output  [255:0] a2f_header,
    // Ports for Interface sfi_f2a_data
    input   [511:0] f2a_data,
    input           f2a_data_aux_parity,
    input           f2a_data_crd_rtn_block,
    input           f2a_data_early_valid,
    input   [15:0]  f2a_data_edb,
    input   [15:0]  f2a_data_end,
    input   [7:0]   f2a_data_info_byte,
    input   [7:0]   f2a_data_parity,
    input   [15:0]  f2a_data_poison,
    input           f2a_data_start,
    input           f2a_data_valid,
    output          f2a_data_block,
    output          f2a_data_crd_rtn_ded,
    output  [1:0]   f2a_data_crd_rtn_fc_id,
    output          f2a_data_crd_rtn_valid,
    output  [3:0]   f2a_data_crd_rtn_value,
    output  [4:0]   f2a_data_crd_rtn_vc_id,
    // Ports for Interface sfi_f2a_global
    input           f2a_txcon_req,
    output          f2a_rx_empty,
    output          f2a_rxcon_ack,
    output          f2a_rxdiscon_nack,
    // Ports for Interface sfi_f2a_hdr
    input           f2a_hdr_crd_rtn_block,
    input           f2a_hdr_early_valid,
    input   [15:0]  f2a_hdr_info_bytes,
    input           f2a_hdr_valid,
    input   [255:0] f2a_header,
    output          f2a_hdr_block,
    output          f2a_hdr_crd_rtn_ded,
    output  [1:0]   f2a_hdr_crd_rtn_fc_id,
    output          f2a_hdr_crd_rtn_valid,
    output  [3:0]   f2a_hdr_crd_rtn_value,
    output  [4:0]   f2a_hdr_crd_rtn_vc_id,
    // Ports for Interface sfi_primclk_reqack
    input           prim_clkack,
    output          prim_clkreq,
    // Ports for Manually exported pins
    input           fdfx_parity_defeature
);

   wire [15:0]  iaxb_b2mrsvd_ports;
   wire [15:0]  iaxb_defeature_ctl;
   wire [3:0]   iaxb_dstmp_credit_idx;
   wire         iaxb_dstmp_credit_inc;
   wire         iaxb_error;
   wire [3:0]   iaxb_error_idx;
   wire [15:0]  iaxb_iaxcap_ctl;
   wire [8:0]   iaxb_perr_cdparctl;
   wire [3:0]   iaxb_perr_coreidx;
   wire [7:0]   iaxb_perr_eips;
   wire         iaxb_perr_errinjctl;
   wire [1:0]   iaxb_perr_errinjmode;
   wire         iaxb_prim_rst_b;
   wire [511:0] iaxb_rdata;
   wire         iaxb_rdata_desc;
   wire [3:0]   iaxb_rdata_idx;
   wire [1:0]   iaxb_rdata_par;
   wire         iaxb_rdata_src2;
   wire         iaxb_rdata_vld;
   wire [8:0]   iaxb_visa_sid;
   wire         iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_prim_clk_en;
   wire         iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_visa_all_dis;
   wire         iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_visa_customer_dis;
   wire         iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_prim_clk_en;
   wire         iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_visa_all_dis;
   wire         iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_visa_customer_dis;
   wire [7:0]   avisa_dbgbus_0_m;
   wire [7:0]   avisa_dbgbus_1_m;
   wire [7:0]   avisa_dbgbus_2_m;
   wire [7:0]   avisa_dbgbus_3_m;
   wire [15:0]  iaxm_m2brsvd_ports;
   wire         iaxm_perr_errinjsts;
   wire [8:0]   iaxm_perr_perrstslog;
   wire [3:0]   iaxm_src1hc_credit_idx;
   wire         iaxm_src1hc_credit_inc;
   wire [3:0]   iaxm_src2hc_credit_idx;
   wire         iaxm_src2hc_credit_inc;
   wire         iaxm_wdata_cmpl;
   wire [3:0]   iaxm_wdata_idx;
   wire [535:0] iaxm_wdata_pkt;
   wire         iaxm_wdata_vld;
   wire [15:0]  iaxm_defeature_ctl;
   wire [3:0]   iaxm_dstmp_credit_idx;
   wire         iaxm_dstmp_credit_inc;
   wire         iaxm_error;
   wire [3:0]   iaxm_error_idx;
   wire [15:0]  iaxm_iaxcap_ctl;
   wire [15:0]  iaxm_m2srsvd_ports;
   wire [8:0]   iaxm_perr_cdparctl;
   wire [3:0]   iaxm_perr_coreidx;
   wire [7:0]   iaxm_perr_eips;
   wire         iaxm_perr_errinjctl;
   wire [1:0]   iaxm_perr_errinjmode;
   wire         iaxm_prim_rst_b;
   wire [511:0] iaxm_rdata;
   wire         iaxm_rdata_desc;
   wire [3:0]   iaxm_rdata_idx;
   wire [1:0]   iaxm_rdata_par;
   wire         iaxm_rdata_src2;
   wire         iaxm_rdata_vld;
   wire [8:0]   iaxm_visa_sid;
   wire         iaxm_wdata_credit_inc;
   wire [7:0]   avisa_dbgbus_0_s;
   wire [7:0]   avisa_dbgbus_1_s;
   wire [7:0]   avisa_dbgbus_2_s;
   wire [7:0]   avisa_dbgbus_3_s;
   wire         iaxs_perr_errinjsts;
   wire [8:0]   iaxs_perr_perrstslog;
   wire [15:0]  iaxs_s2mrsvd_ports;
   wire [3:0]   iaxs_src1hc_credit_idx;
   wire         iaxs_src1hc_credit_inc;
   wire [3:0]   iaxs_src2hc_credit_idx;
   wire         iaxs_src2hc_credit_inc;
   wire         iaxs_wdata_cmpl;
   wire [3:0]   iaxs_wdata_idx;
   wire [535:0] iaxs_wdata_pkt;
   wire         iaxs_wdata_vld;
   
   (* first_gist_inserted_in_block = 1'b1,
      inserted_by="VISA IT" *) logic visa_enable_version_match_test_pfx_dummy;
                               `ifdef VISA_ENABLE_VERSION_MATCH_TEST
   (* inserted_by="VISA IT" *) struct { 
                                   string version;
                                   string verid;
                                   string config_file;
                               } visa_insertion_info_record = '{
                                   "4.3.17",
                                   "30ad078",
                                   "/nfs/site/disks/zsc11_cct_00014/skuriako/DSA_RELEASE/DMR_RELEASE/REL_AREA/EIP_DSA_IAA_3P0_S64B60_2023WW51_v0009/output/iaa3p0s64b60/visa/iaa3p0s64b60/visa_run/iaa3p0s64b60.sig.ins.visa"
                               };
                               `endif // VISA_ENABLE_VERSION_MATCH_TEST
   (* inserted_by="VISA IT" *) logic visa_enable_version_match_test_sfx_dummy;
   

   iaab3p0s64b60 iaab3p0s64b60
      (.configdone,
       .avisa_dbgbus_0_m       (avisa_dbgbus_0_m),
       .avisa_dbgbus_1_m       (avisa_dbgbus_1_m),
       .avisa_dbgbus_2_m       (avisa_dbgbus_2_m),
       .avisa_dbgbus_3_m       (avisa_dbgbus_3_m),
       .iaxb_b2mrsvd_ports     (iaxb_b2mrsvd_ports),
       .iaxb_defeature_ctl     (iaxb_defeature_ctl),
       .iaxb_dstmp_credit_idx  (iaxb_dstmp_credit_idx),
       .iaxb_dstmp_credit_inc  (iaxb_dstmp_credit_inc),
       .iaxb_error             (iaxb_error),
       .iaxb_error_idx         (iaxb_error_idx),
       .iaxb_iaxcap_ctl        (iaxb_iaxcap_ctl),
       .iaxb_perr_cdparctl     (iaxb_perr_cdparctl),
       .iaxb_perr_coreidx      (iaxb_perr_coreidx),
       .iaxb_perr_eips         (iaxb_perr_eips),
       .iaxb_perr_errinjctl    (iaxb_perr_errinjctl),
       .iaxb_perr_errinjmode   (iaxb_perr_errinjmode),
       .iaxb_prim_rst_b        (iaxb_prim_rst_b),
       .iaxb_rdata             (iaxb_rdata),
       .iaxb_rdata_desc        (iaxb_rdata_desc),
       .iaxb_rdata_idx         (iaxb_rdata_idx),
       .iaxb_rdata_par         (iaxb_rdata_par),
       .iaxb_rdata_src2        (iaxb_rdata_src2),
       .iaxb_rdata_vld         (iaxb_rdata_vld),
       .iaxb_visa_sid          (iaxb_visa_sid),
       .iaxm_m2brsvd_ports     (iaxm_m2brsvd_ports),
       .iaxm_perr_errinjsts    (iaxm_perr_errinjsts),
       .iaxm_perr_perrstslog   (iaxm_perr_perrstslog),
       .iaxm_src1hc_credit_idx (iaxm_src1hc_credit_idx),
       .iaxm_src1hc_credit_inc (iaxm_src1hc_credit_inc),
       .iaxm_src2hc_credit_idx (iaxm_src2hc_credit_idx),
       .iaxm_src2hc_credit_inc (iaxm_src2hc_credit_inc),
       .iaxm_wdata_cmpl        (iaxm_wdata_cmpl),
       .iaxm_wdata_idx         (iaxm_wdata_idx),
       .iaxm_wdata_pkt         (iaxm_wdata_pkt),
       .iaxm_wdata_vld         (iaxm_wdata_vld),
       .iaab3p0s64b60_ip_iax_base_main_prim_clk_en            (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_prim_clk_en),
       .iaab3p0s64b60_ip_iax_base_main_visa_all_dis           (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_visa_all_dis),
       .iaab3p0s64b60_ip_iax_base_main_visa_customer_dis      (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_visa_customer_dis),
       .iaab3p0s64b60_ip_iax_base_secondary_prim_clk_en       (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_prim_clk_en),
       .iaab3p0s64b60_ip_iax_base_secondary_visa_all_dis      (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_visa_all_dis),
       .iaab3p0s64b60_ip_iax_base_secondary_visa_customer_dis (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_visa_customer_dis),
       .fdfx_secure_policy,
       .fdfx_earlyboot_exit,
       .fdfx_policy_update,
       .avisa_primclk_0,
       .avisa_dbgbus_primclk_0,
       .avisa_primclk_1,
       .avisa_dbgbus_primclk_1,
       .avisa_primclk_2,
       .avisa_dbgbus_primclk_2,
       .avisa_primclk_3,
       .avisa_dbgbus_primclk_3,
       .avisa_primclk_4,
       .avisa_dbgbus_primclk_4,
       .avisa_primclk_5,
       .avisa_dbgbus_primclk_5,
       .avisa_primclk_6,
       .avisa_dbgbus_primclk_6,
       .avisa_primclk_7,
       .avisa_dbgbus_primclk_7,
       .avisa_sideclk_8,
       .avisa_dbgbus_sideclk_8,
       .fvisa_startid,
       .fdfx_powergood,
       .prim_pok,
       .side_clk,
       .fismsdfx_clkgate_ovrd,
       .fismsdfx_force_clkreq,
       .fismsdfx_force_creditreq,
       .fismsdfx_force_idle,
       .fismsdfx_force_notidle,
       .meom,
       .mnpcup,
       .mnpput,
       .mpayload,
       .mpccup,
       .mpcput,
       .side_pok,
       .side_clkack,
       .side_clkreq,
       .side_ism_agent,
       .side_ism_fabric,
       .strap_sb_id,
       .teom,
       .tnpcup,
       .tnpput,
       .tpayload,
       .tpccup,
       .tpcput,
       .a2f_data,
       .a2f_data_aux_parity,
       .a2f_data_block,
       .a2f_data_crd_rtn_block,
       .a2f_data_crd_rtn_ded,
       .a2f_data_crd_rtn_fc_id,
       .a2f_data_crd_rtn_valid,
       .a2f_data_crd_rtn_value,
       .a2f_data_crd_rtn_vc_id,
       .a2f_data_early_valid,
       .a2f_data_edb,
       .a2f_data_end,
       .a2f_data_info_byte,
       .a2f_data_parity,
       .a2f_data_poison,
       .a2f_data_start,
       .a2f_data_valid,
       .a2f_rx_empty,
       .a2f_rxcon_ack,
       .a2f_rxdiscon_nack,
       .a2f_txcon_req,
       .a2f_hdr_block,
       .a2f_hdr_crd_rtn_block,
       .a2f_hdr_crd_rtn_ded,
       .a2f_hdr_crd_rtn_fc_id,
       .a2f_hdr_crd_rtn_valid,
       .a2f_hdr_crd_rtn_value,
       .a2f_hdr_crd_rtn_vc_id,
       .a2f_hdr_early_valid,
       .a2f_hdr_info_bytes,
       .a2f_hdr_valid,
       .a2f_header,
       .f2a_data,
       .f2a_data_aux_parity,
       .f2a_data_block,
       .f2a_data_crd_rtn_block,
       .f2a_data_crd_rtn_ded,
       .f2a_data_crd_rtn_fc_id,
       .f2a_data_crd_rtn_valid,
       .f2a_data_crd_rtn_value,
       .f2a_data_crd_rtn_vc_id,
       .f2a_data_early_valid,
       .f2a_data_edb,
       .f2a_data_end,
       .f2a_data_info_byte,
       .f2a_data_parity,
       .f2a_data_poison,
       .f2a_data_start,
       .f2a_data_valid,
       .f2a_rx_empty,
       .f2a_rxcon_ack,
       .f2a_rxdiscon_nack,
       .f2a_txcon_req,
       .f2a_hdr_block,
       .f2a_hdr_crd_rtn_block,
       .f2a_hdr_crd_rtn_ded,
       .f2a_hdr_crd_rtn_fc_id,
       .f2a_hdr_crd_rtn_valid,
       .f2a_hdr_crd_rtn_value,
       .f2a_hdr_crd_rtn_vc_id,
       .f2a_hdr_early_valid,
       .f2a_hdr_info_bytes,
       .f2a_hdr_valid,
       .f2a_header,
       .prim_clkack,
       .prim_clkreq,
       .prim_clk,
`ifndef NO_PWR_PINS
       .vcc_pwrgood_rst_b,
       .vcc_logic_rst_b,
`endif
       .cg_wake,
       .pg_wake,
       .fscan_shiften,
       .fscan_mode,
       .fscan_latchopen,
       .fscan_latchclosed_b,
       .fscan_clkungate,
       .fscan_clkungate_syn,
       .fscan_rstbypen,
       .fscan_byprst_b,
       .fscan_ret_ctrl,
       .fscan_ram_bypsel,
       .fscan_ram_init_en,
       .fscan_ram_init_val,
       .fscan_ram_rddis_b,
       .fscan_ram_wrdis_b,
       .strap_sai_pol_boot_w_cp              (strap_sai_pol_boot_w_cp),
       .strap_sai_pol_boot_w_rac             (strap_sai_pol_boot_w_rac),
       .strap_sai_pol_boot_w_wac             (strap_sai_pol_boot_w_wac),
       .strap_cpl_sai                        (strap_cpl_sai),
       .strap_device_num                     (strap_device_num),
       .strap_err_sai                        (strap_err_sai),
       .strap_err_sb_id                      (strap_err_sb_id),
       .strap_ltr_sai                        (strap_ltr_sai),
       .strap_ltr_sb_id                      (strap_ltr_sb_id),
       .strap_mem_sai                        (strap_mem_sai),
       .strap_sai_pol_os_w_cp                (strap_sai_pol_os_w_cp),
       .strap_sai_pol_os_w_rac               (strap_sai_pol_os_w_rac),
       .strap_sai_pol_os_w_wac               (strap_sai_pol_os_w_wac),
       .strap_pm_sai                         (strap_pm_sai),
       .strap_sai_pol_p_u_code_cp            (strap_sai_pol_p_u_code_cp),
       .strap_sai_pol_p_u_code_rac           (strap_sai_pol_p_u_code_rac),
       .strap_sai_pol_p_u_code_wac           (strap_sai_pol_p_u_code_wac),
       .strap_resetprepack_sai               (strap_resetprepack_sai),
       .strap_setid_opcode                   (strap_setid_opcode),
       .strap_setid_sai                      (strap_setid_sai),
       .strap_untranslated_hpa_allowed       (strap_untranslated_hpa_allowed),
       .fvisa_frame,
       .fvisa_serdata,
       .fvisa_serstb,
       .iaab3p0s64b60_ip_fdfx_parity_defeature                (fdfx_parity_defeature));

   iaam3p0s64b60 iaam3p0s64b60
      (.avisa_dbgbus_0_m            (avisa_dbgbus_0_m),
       .avisa_dbgbus_1_m            (avisa_dbgbus_1_m),
       .avisa_dbgbus_2_m            (avisa_dbgbus_2_m),
       .avisa_dbgbus_3_m            (avisa_dbgbus_3_m),
       .iaxb_b2mrsvd_ports          (iaxb_b2mrsvd_ports),
       .iaxb_defeature_ctl          (iaxb_defeature_ctl),
       .iaxb_dstmp_credit_idx       (iaxb_dstmp_credit_idx),
       .iaxb_dstmp_credit_inc       (iaxb_dstmp_credit_inc),
       .iaxb_error                  (iaxb_error),
       .iaxb_error_idx              (iaxb_error_idx),
       .iaxb_iaxcap_ctl             (iaxb_iaxcap_ctl),
       .iaxb_perr_cdparctl          (iaxb_perr_cdparctl),
       .iaxb_perr_coreidx           (iaxb_perr_coreidx),
       .iaxb_perr_eips              (iaxb_perr_eips),
       .iaxb_perr_errinjctl         (iaxb_perr_errinjctl),
       .iaxb_perr_errinjmode        (iaxb_perr_errinjmode),
       .iaxb_prim_rst_b             (iaxb_prim_rst_b),
       .iaxb_rdata                  (iaxb_rdata),
       .iaxb_rdata_desc             (iaxb_rdata_desc),
       .iaxb_rdata_idx              (iaxb_rdata_idx),
       .iaxb_rdata_par              (iaxb_rdata_par),
       .iaxb_rdata_src2             (iaxb_rdata_src2),
       .iaxb_rdata_vld              (iaxb_rdata_vld),
       .iaxb_visa_sid               (iaxb_visa_sid),
       .iaxm_m2brsvd_ports          (iaxm_m2brsvd_ports),
       .iaxm_perr_errinjsts         (iaxm_perr_errinjsts),
       .iaxm_perr_perrstslog        (iaxm_perr_perrstslog),
       .iaxm_src1hc_credit_idx      (iaxm_src1hc_credit_idx),
       .iaxm_src1hc_credit_inc      (iaxm_src1hc_credit_inc),
       .iaxm_src2hc_credit_idx      (iaxm_src2hc_credit_idx),
       .iaxm_src2hc_credit_inc      (iaxm_src2hc_credit_inc),
       .iaxm_wdata_cmpl             (iaxm_wdata_cmpl),
       .iaxm_wdata_idx              (iaxm_wdata_idx),
       .iaxm_wdata_pkt              (iaxm_wdata_pkt),
       .iaxm_wdata_vld              (iaxm_wdata_vld),
       .iaam3p0s64b60_ip_iax_base_main_prim_clk_en                 (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_prim_clk_en),
       .iaam3p0s64b60_ip_iax_base_main_visa_all_dis                (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_visa_all_dis),
       .iaam3p0s64b60_ip_iax_base_main_visa_customer_dis           (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_main_visa_customer_dis),
       .avisa_dbgbus_0_s       (avisa_dbgbus_0_s),
       .avisa_dbgbus_1_s       (avisa_dbgbus_1_s),
       .avisa_dbgbus_2_s       (avisa_dbgbus_2_s),
       .avisa_dbgbus_3_s       (avisa_dbgbus_3_s),
       .iaxm_defeature_ctl     (iaxm_defeature_ctl),
       .iaxm_dstmp_credit_idx  (iaxm_dstmp_credit_idx),
       .iaxm_dstmp_credit_inc  (iaxm_dstmp_credit_inc),
       .iaxm_error             (iaxm_error),
       .iaxm_error_idx         (iaxm_error_idx),
       .iaxm_iaxcap_ctl        (iaxm_iaxcap_ctl),
       .iaxm_m2srsvd_ports     (iaxm_m2srsvd_ports),
       .iaxm_perr_cdparctl     (iaxm_perr_cdparctl),
       .iaxm_perr_coreidx      (iaxm_perr_coreidx),
       .iaxm_perr_eips         (iaxm_perr_eips),
       .iaxm_perr_errinjctl    (iaxm_perr_errinjctl),
       .iaxm_perr_errinjmode   (iaxm_perr_errinjmode),
       .iaxm_prim_rst_b        (iaxm_prim_rst_b),
       .iaxm_rdata             (iaxm_rdata),
       .iaxm_rdata_desc        (iaxm_rdata_desc),
       .iaxm_rdata_idx         (iaxm_rdata_idx),
       .iaxm_rdata_par         (iaxm_rdata_par),
       .iaxm_rdata_src2        (iaxm_rdata_src2),
       .iaxm_rdata_vld         (iaxm_rdata_vld),
       .iaxm_visa_sid          (iaxm_visa_sid),
       .iaxm_wdata_credit_inc  (iaxm_wdata_credit_inc),
       .iaxs_perr_errinjsts    (iaxs_perr_errinjsts),
       .iaxs_perr_perrstslog   (iaxs_perr_perrstslog),
       .iaxs_s2mrsvd_ports     (iaxs_s2mrsvd_ports),
       .iaxs_src1hc_credit_idx (iaxs_src1hc_credit_idx),
       .iaxs_src1hc_credit_inc (iaxs_src1hc_credit_inc),
       .iaxs_src2hc_credit_idx (iaxs_src2hc_credit_idx),
       .iaxs_src2hc_credit_inc (iaxs_src2hc_credit_inc),
       .iaxs_wdata_cmpl        (iaxs_wdata_cmpl),
       .iaxs_wdata_idx         (iaxs_wdata_idx),
       .iaxs_wdata_pkt         (iaxs_wdata_pkt),
       .iaxs_wdata_vld         (iaxs_wdata_vld),
       .prim_clk,
`ifndef NO_PWR_PINS
       .vcc_pwrgood_rst_b,
       .vcc_logic_rst_b,
`endif
       .cg_wake,
       .pg_wake,
       .fdfx_powergood,
       .fscan_shiften,
       .fscan_mode,
       .fscan_latchopen,
       .fscan_latchclosed_b,
       .fscan_clkungate,
       .fscan_clkungate_syn,
       .fscan_rstbypen,
       .fscan_byprst_b,
       .fscan_ret_ctrl,
       .fscan_ram_bypsel,
       .fscan_ram_init_en,
       .fscan_ram_init_val,
       .fscan_ram_rddis_b,
       .fscan_ram_wrdis_b,
       .fvisa_frame,
       .fvisa_serdata,
       .fvisa_serstb);

   iaas3p0s64b60 iaas3p0s64b60
      (.iaas3p0s64b60_ip_iax_base_secondary_prim_clk_en            (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_prim_clk_en),
       .iaas3p0s64b60_ip_iax_base_secondary_visa_all_dis           (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_visa_all_dis),
       .iaas3p0s64b60_ip_iax_base_secondary_visa_customer_dis      (iaab3p0s64b60_iaab3p0s64b60_ip_iax_base_secondary_visa_customer_dis),
       .avisa_dbgbus_0_s       (avisa_dbgbus_0_s),
       .avisa_dbgbus_1_s       (avisa_dbgbus_1_s),
       .avisa_dbgbus_2_s       (avisa_dbgbus_2_s),
       .avisa_dbgbus_3_s       (avisa_dbgbus_3_s),
       .iaxm_defeature_ctl     (iaxm_defeature_ctl),
       .iaxm_dstmp_credit_idx  (iaxm_dstmp_credit_idx),
       .iaxm_dstmp_credit_inc  (iaxm_dstmp_credit_inc),
       .iaxm_error             (iaxm_error),
       .iaxm_error_idx         (iaxm_error_idx),
       .iaxm_iaxcap_ctl        (iaxm_iaxcap_ctl),
       .iaxm_m2srsvd_ports     (iaxm_m2srsvd_ports),
       .iaxm_perr_cdparctl     (iaxm_perr_cdparctl),
       .iaxm_perr_coreidx      (iaxm_perr_coreidx),
       .iaxm_perr_eips         (iaxm_perr_eips),
       .iaxm_perr_errinjctl    (iaxm_perr_errinjctl),
       .iaxm_perr_errinjmode   (iaxm_perr_errinjmode),
       .iaxm_prim_rst_b        (iaxm_prim_rst_b),
       .iaxm_rdata             (iaxm_rdata),
       .iaxm_rdata_desc        (iaxm_rdata_desc),
       .iaxm_rdata_idx         (iaxm_rdata_idx),
       .iaxm_rdata_par         (iaxm_rdata_par),
       .iaxm_rdata_src2        (iaxm_rdata_src2),
       .iaxm_rdata_vld         (iaxm_rdata_vld),
       .iaxm_visa_sid          (iaxm_visa_sid),
       .iaxm_wdata_credit_inc  (iaxm_wdata_credit_inc),
       .iaxs_perr_errinjsts    (iaxs_perr_errinjsts),
       .iaxs_perr_perrstslog   (iaxs_perr_perrstslog),
       .iaxs_s2mrsvd_ports     (iaxs_s2mrsvd_ports),
       .iaxs_src1hc_credit_idx (iaxs_src1hc_credit_idx),
       .iaxs_src1hc_credit_inc (iaxs_src1hc_credit_inc),
       .iaxs_src2hc_credit_idx (iaxs_src2hc_credit_idx),
       .iaxs_src2hc_credit_inc (iaxs_src2hc_credit_inc),
       .iaxs_wdata_cmpl        (iaxs_wdata_cmpl),
       .iaxs_wdata_idx         (iaxs_wdata_idx),
       .iaxs_wdata_pkt         (iaxs_wdata_pkt),
       .iaxs_wdata_vld         (iaxs_wdata_vld),
       .prim_clk,
`ifndef NO_PWR_PINS
       .vcc_pwrgood_rst_b,
       .vcc_logic_rst_b,
`endif
       .cg_wake,
       .pg_wake,
       .fdfx_powergood,
       .fscan_shiften,
       .fscan_mode,
       .fscan_latchopen,
       .fscan_latchclosed_b,
       .fscan_clkungate,
       .fscan_clkungate_syn,
       .fscan_rstbypen,
       .fscan_byprst_b,
       .fscan_ret_ctrl,
       .fscan_ram_bypsel,
       .fscan_ram_init_en,
       .fscan_ram_init_val,
       .fscan_ram_rddis_b,
       .fscan_ram_wrdis_b,
       .fvisa_frame,
       .fvisa_serdata,
       .fvisa_serstb);



endmodule
