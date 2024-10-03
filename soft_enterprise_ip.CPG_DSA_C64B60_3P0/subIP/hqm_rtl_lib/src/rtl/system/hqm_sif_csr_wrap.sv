// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_ri_csr
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Thursday December 11, 2008
// -- Description :
// The CSR FUB contains the instantiation for all physical and
// virtual CSR functions.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_sif_csr_wrap

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*, hqm_system_pkg::*, hqm_sif_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input  logic                                           prim_nonflr_clk
    ,input  logic                                           prim_gated_rst_b
    ,input  logic                                           side_gated_rst_prim_b

    ,input  logic                                           hqm_csr_mmio_rst_n

    ,input  logic                                           hard_rst_np

    ,input  hqm_rtlgen_pkg_v12::cfg_req_32bit_t             hqm_csr_int_mmio_req
    ,output hqm_rtlgen_pkg_v12::cfg_ack_32bit_t             hqm_csr_int_mmio_ack


    //-----------------------------------------------------------------
    // Inputs
    //-----------------------------------------------------------------

    // Initialize SAI access control CP and WAC registers - intended to be done by straps

    ,input  logic [63:0]                                    strap_hqm_csr_cp
    ,input  logic [63:0]                                    strap_hqm_csr_rac
    ,input  logic [63:0]                                    strap_hqm_csr_wac

    //-----------------------------------------------------------------
    // Outputs
    //-----------------------------------------------------------------

    ,output logic [63:0]                                    hqm_csr_rac     // OS_W SAI group RAC register
    ,output logic [63:0]                                    hqm_csr_wac     // OS_W SAI group WAC register

    // fuses

    ,input  hqm_sif_fuses_t                                 sb_ep_fuses     

    // SAI read/write enables for OS_W security policy group

    ,output hqm_sif_csr_pkg::hqm_sif_csr_sai_export_t       hqm_sif_csr_sai_export

    // hqm_sif memory interfaces

    ,input  hqm_sif_csr_pkg::hqm_sif_csr_hc_rvalid_t        hqm_sif_csr_hc_rvalid
    ,input  hqm_sif_csr_pkg::hqm_sif_csr_hc_wvalid_t        hqm_sif_csr_hc_wvalid
    ,input  hqm_sif_csr_pkg::hqm_sif_csr_hc_error_t         hqm_sif_csr_hc_error
    ,input  hqm_sif_csr_pkg::hqm_sif_csr_hc_reg_read_t      hqm_sif_csr_hc_reg_read

    ,output hqm_sif_csr_pkg::hqm_sif_csr_handcoded_t        hqm_sif_csr_hc_we
    ,output hqm_sif_csr_pkg::hqm_sif_csr_hc_re_t            hqm_sif_csr_hc_re
    ,output hqm_sif_csr_pkg::hqm_sif_csr_hc_reg_write_t     hqm_sif_csr_hc_reg_write

    // hqm_sif status and control CSRs

    ,input  new_CFGM_STATUS_t                               cfgm_status
    ,input  new_CFGM_STATUS2_t                              cfgm_status2

    ,input  new_RI_PHDR_FIFO_STATUS_t                       ri_phdr_fifo_status
    ,input  new_RI_PDATA_FIFO_STATUS_t                      ri_pdata_fifo_status
    ,input  new_RI_NPHDR_FIFO_STATUS_t                      ri_nphdr_fifo_status
    ,input  new_RI_NPDATA_FIFO_STATUS_t                     ri_npdata_fifo_status
    ,input  new_RI_IOQ_FIFO_STATUS_t                        ri_ioq_fifo_status
    ,input  new_IBCPL_HDR_FIFO_STATUS_t                     ibcpl_hdr_fifo_status
    ,input  new_IBCPL_DATA_FIFO_STATUS_t                    ibcpl_data_fifo_status
    ,input  new_OBCPL_FIFO_STATUS_t                         obcpl_fifo_status
    ,input  new_P_RL_CQ_FIFO_STATUS_t                       p_rl_cq_fifo_status

    ,input  new_SIF_DB_STATUS_t                             sif_db_status
    ,input  new_RI_DB_STATUS_t                              ri_db_status
    ,input  new_DEVTLB_STATUS_t                             devtlb_status
    ,input  new_SCRBD_STATUS_t                              scrbd_status
    ,input  new_MSTR_CRD_STATUS_t                           mstr_crd_status
    ,input  new_MSTR_FL_STATUS_t                            mstr_fl_status
    ,input  new_MSTR_LL_STATUS_t                            mstr_ll_status

    ,input  new_LOCAL_BME_STATUS_t                          local_bme_status
    ,input  new_LOCAL_MSIXE_STATUS_t                        local_msixe_status

    ,output PRIM_CDC_CTL_t                                  prim_cdc_ctl
    ,output SIDE_CDC_CTL_t                                  side_cdc_ctl
    ,output IOSFP_CGCTL_t                                   iosfp_cgctl
    ,output IOSFS_CGCTL_t                                   iosfs_cgctl

    ,output DIR_CQ2TC_MAP_t                                 dir_cq2tc_map
    ,output LDB_CQ2TC_MAP_t                                 ldb_cq2tc_map
    ,output INT2TC_MAP_t                                    int2tc_map

    ,output CFG_MASTER_TIMEOUT_t                            cfg_master_timeout
    ,output hqm_sif_csr_pkg::PARITY_CTL_t                   parity_ctl
    ,output MMIO_TIMEOUT_t                                  cfg_mmio_timeout
    ,output HCW_TIMEOUT_t                                   cfg_hcw_timeout
    ,input  VISA_SW_CONTROL_t                               cfg_visa_sw_control
    ,output logic                                           cfg_visa_sw_control_write
    ,input  logic                                           cfg_visa_sw_control_write_done
    ,output VISA_SW_CONTROL_t                               cfg_visa_sw_control_wdata
    ,output logic [63:0]                                    cfg_ph_trigger_addr
    ,output logic [63:0]                                    cfg_ph_trigger_mask

    ,output RI_PHDR_FIFO_CTL_t                              ri_phdr_fifo_ctl
    ,output RI_PDATA_FIFO_CTL_t                             ri_pdata_fifo_ctl
    ,output RI_NPHDR_FIFO_CTL_t                             ri_nphdr_fifo_ctl
    ,output RI_NPDATA_FIFO_CTL_t                            ri_npdata_fifo_ctl
    ,output RI_IOQ_FIFO_CTL_t                               ri_ioq_fifo_ctl
    ,output IBCPL_HDR_FIFO_CTL_t                            ibcpl_hdr_fifo_ctl
    ,output IBCPL_DATA_FIFO_CTL_t                           ibcpl_data_fifo_ctl

    ,output OBCPL_AFULL_AGITATE_CONTROL_t                   obcpl_afull_agitate_control

    ,input  new_SIF_MSTR_DEBUG_t                            sif_mstr_debug

    ,input  load_RI_PARITY_ERR_t                            set_ri_parity_err
    ,input  load_SIF_PARITY_ERR_t                           set_sif_parity_err
    ,input  load_DEVTLB_ATS_ERR_t                           set_devtlb_ats_err

    ,input  load_IBCPL_ERR_t                                set_ibcpl_err
    ,input  logic                                           set_ibcpl_err_hdr
    ,input  logic [95:0]                                    ibcpl_err_hdr
    ,output IBCPL_ERR_t                                     ibcpl_err

    ,input  load_SIF_ALARM_ERR_t                            set_sif_alarm_err
    ,output SIF_ALARM_ERR_t                                 sif_alarm_err

    ,output HQM_SIF_CNT_CTL_t                               hqm_sif_cnt_ctl
    ,input  logic [11:0] [31:0]                             hqm_sif_cnt

    ,output SIF_CTL_t                                       cfg_sif_ctl
    ,output SIF_VC_RXMAP_t                                  cfg_sif_vc_rxmap
    ,output SIF_VC_TXMAP_t                                  cfg_sif_vc_txmap

    ,input  new_SIF_IDLE_STATUS_t                           sif_idle_status
    ,output SIF_IDLE_STATUS_t                               sif_idle_status_reg

    ,input  new_TGT_INIT_HCREDITS_t                         tgt_init_hcredits                       
    ,input  new_TGT_INIT_DCREDITS_t                         tgt_init_dcredits   
    ,input  new_TGT_REM_HCREDITS_t                          tgt_rem_hcredits            
    ,input  new_TGT_REM_DCREDITS_t                          tgt_rem_dcredits   
    ,input  new_TGT_RET_HCREDITS_t                          tgt_ret_hcredits   
    ,input  new_TGT_RET_DCREDITS_t                          tgt_ret_dcredits   

    ,output SCRBD_CTL_t                                     scrbd_ctl
    ,output MSTR_LL_CTL_t                                   mstr_ll_ctl
    ,output DEVTLB_CTL_t                                    devtlb_ctl
    ,output DEVTLB_SPARE_t                                  devtlb_spare
    ,output DEVTLB_DEFEATURE0_t                             devtlb_defeature0
    ,output DEVTLB_DEFEATURE1_t                             devtlb_defeature1
    ,output DEVTLB_DEFEATURE2_t                             devtlb_defeature2

);

//-----------------------------------------------------------------------------------------------------

new_HQM_PULLED_FUSES_0_t            pulled_fuses_0;

RI_PHDR_FIFO_STATUS_t               ri_phdr_fifo_status_nc;
RI_PDATA_FIFO_STATUS_t              ri_pdata_fifo_status_nc;
RI_NPHDR_FIFO_STATUS_t              ri_nphdr_fifo_status_nc;
RI_NPDATA_FIFO_STATUS_t             ri_npdata_fifo_status_nc;
RI_IOQ_FIFO_STATUS_t                ri_ioq_fifo_status_nc;
IBCPL_HDR_FIFO_STATUS_t             ibcpl_hdr_fifo_status_nc;
IBCPL_DATA_FIFO_STATUS_t            ibcpl_data_fifo_status_nc;
OBCPL_FIFO_STATUS_t                 obcpl_fifo_status_nc;
P_RL_CQ_FIFO_STATUS_t               p_rl_cq_fifo_status_nc;
SIF_DB_STATUS_t                     sif_db_status_nc;
DEVTLB_STATUS_t                     devtlb_status_nc;
SCRBD_STATUS_t                      scrbd_status_nc;
MSTR_CRD_STATUS_t                   mstr_crd_status_nc;
MSTR_FL_STATUS_t                    mstr_fl_status_nc;
MSTR_LL_STATUS_t                    mstr_ll_status_nc;
LOCAL_BME_STATUS_t                  local_bme_status_nc;
LOCAL_MSIXE_STATUS_t                local_msixe_status_nc;
RI_DB_STATUS_t                      ri_db_status_nc;
CFGM_STATUS_t                       cfgm_status_nc;
CFGM_STATUS2_t                      cfgm_status2_nc;
HQM_PULLED_FUSES_0_t                pulled_fuses_0_nc;
CFG_UNIT_VERSION_t                  cfg_unit_version_nc;
SIF_MSTR_DEBUG_t                    sif_mstr_debug_nc;
RI_PARITY_ERR_t                     ri_parity_err_nc;
DEVTLB_ATS_ERR_t                    devtlb_ats_err_nc;
SIF_PARITY_ERR_t                    sif_parity_err_nc;
HQM_SIF_CNT_0_t                     hqm_sif_cnt_0_nc;
HQM_SIF_CNT_1_t                     hqm_sif_cnt_1_nc;
HQM_SIF_CNT_2_t                     hqm_sif_cnt_2_nc;
HQM_SIF_CNT_3_t                     hqm_sif_cnt_3_nc;
HQM_SIF_CNT_4_t                     hqm_sif_cnt_4_nc;
HQM_SIF_CNT_5_t                     hqm_sif_cnt_5_nc;
HQM_SIF_CNT_6_t                     hqm_sif_cnt_6_nc;
HQM_SIF_CNT_7_t                     hqm_sif_cnt_7_nc;
HQM_SIF_CNT_8_t                     hqm_sif_cnt_8_nc;
HQM_SIF_CNT_9_t                     hqm_sif_cnt_9_nc;
HQM_SIF_CNT_10_t                    hqm_sif_cnt_10_nc;
HQM_SIF_CNT_11_t                    hqm_sif_cnt_11_nc;
TGT_INIT_HCREDITS_t                 tgt_init_hcredits_nc;
TGT_INIT_DCREDITS_t                 tgt_init_dcredits_nc;
TGT_REM_HCREDITS_t                  tgt_rem_hcredits_nc;
TGT_REM_DCREDITS_t                  tgt_rem_dcredits_nc;
TGT_RET_HCREDITS_t                  tgt_ret_hcredits_nc;
TGT_RET_DCREDITS_t                  tgt_ret_dcredits_nc;
logic [95:0]                        ibcpl_err_hdr_nc;

logic [63:0]                        hqm_csr_cp_nc;
logic                               strap_hqm_csr_load;

re_VISA_SW_CONTROL_t                cfg_visa_sw_control_re;
we_VISA_SW_CONTROL_t                cfg_visa_sw_control_we;

//-----------------------------------------------------------------------------------------------------

hqm_AW_width_scale #(.A_WIDTH($bits(sb_ep_fuses)), .Z_WIDTH(32)) i_pulled_fuses (

     .a     (sb_ep_fuses)
    ,.z     (pulled_fuses_0)
);

logic [31:0]    HQM_CSR_CP_LO_sai_rst_strap;
logic [31:0]    HQM_CSR_CP_HI_sai_rst_strap;
logic [31:0]    HQM_CSR_RAC_LO_sai_rst_strap;
logic [31:0]    HQM_CSR_RAC_HI_sai_rst_strap;
logic [31:0]    HQM_CSR_WAC_LO_sai_rst_strap;
logic [31:0]    HQM_CSR_WAC_HI_sai_rst_strap;

// Conditional load is defeatured; always use pin/strap value as default value
assign strap_hqm_csr_load       = 1'b1 ;

always_comb begin : new_hqm_csr_sai_p
  HQM_CSR_CP_LO_sai_rst_strap   = strap_hqm_csr_load ? strap_hqm_csr_cp[31:0]   : HQM_CSR_CP_LO_SAI_MASK_RESET ;
  HQM_CSR_CP_HI_sai_rst_strap   = strap_hqm_csr_load ? strap_hqm_csr_cp[63:32]  : HQM_CSR_CP_HI_SAI_MASK_RESET ;
  HQM_CSR_RAC_LO_sai_rst_strap  = strap_hqm_csr_load ? strap_hqm_csr_rac[31:0]  : HQM_CSR_RAC_LO_SAI_MASK_RESET ;
  HQM_CSR_RAC_HI_sai_rst_strap  = strap_hqm_csr_load ? strap_hqm_csr_rac[63:32] : HQM_CSR_RAC_HI_SAI_MASK_RESET ;
  HQM_CSR_WAC_LO_sai_rst_strap  = strap_hqm_csr_load ? strap_hqm_csr_wac[31:0]  : HQM_CSR_WAC_LO_SAI_MASK_RESET ;
  HQM_CSR_WAC_HI_sai_rst_strap  = strap_hqm_csr_load ? strap_hqm_csr_wac[63:32] : HQM_CSR_WAC_HI_SAI_MASK_RESET ;
end

hqm_sif_csr i_hqm_sif_csr (

     .rtl_clk                                       (prim_nonflr_clk)
    ,.gated_clk                                     (prim_nonflr_clk)
    ,.prim_gated_rst_b                              (prim_gated_rst_b)
    ,.side_gated_rst_prim_b                         (side_gated_rst_prim_b)
    ,.hqm_csr_mmio_rst_n                            (hqm_csr_mmio_rst_n)
    ,.powergood_rst_b                               (hard_rst_np)

    ,.req                                           (hqm_csr_int_mmio_req)

    ,.HQM_CSR_CP_HI_sai_rst_strap                   (HQM_CSR_CP_HI_sai_rst_strap)
    ,.HQM_CSR_CP_LO_sai_rst_strap                   (HQM_CSR_CP_LO_sai_rst_strap)
    ,.HQM_CSR_RAC_HI_sai_rst_strap                  (HQM_CSR_RAC_HI_sai_rst_strap)
    ,.HQM_CSR_RAC_LO_sai_rst_strap                  (HQM_CSR_RAC_LO_sai_rst_strap)
    ,.HQM_CSR_WAC_HI_sai_rst_strap                  (HQM_CSR_WAC_HI_sai_rst_strap)
    ,.HQM_CSR_WAC_LO_sai_rst_strap                  (HQM_CSR_WAC_LO_sai_rst_strap)

    ,.load_SIF_ALARM_ERR                            (set_sif_alarm_err)
    ,.new_SIF_ALARM_ERR                             ('1)
    ,.SIF_ALARM_ERR                                 (sif_alarm_err)

    ,.load_RI_PHDR_FIFO_STATUS                      ({ri_phdr_fifo_status.OVRFLOW,ri_phdr_fifo_status.UNDFLOW})
    ,.load_RI_PDATA_FIFO_STATUS                     ({ri_pdata_fifo_status.OVRFLOW,ri_pdata_fifo_status.UNDFLOW})
    ,.load_RI_NPHDR_FIFO_STATUS                     ({ri_nphdr_fifo_status.OVRFLOW,ri_nphdr_fifo_status.UNDFLOW})
    ,.load_RI_NPDATA_FIFO_STATUS                    ({ri_npdata_fifo_status.OVRFLOW,ri_npdata_fifo_status.UNDFLOW})
    ,.load_RI_IOQ_FIFO_STATUS                       ({ri_ioq_fifo_status.OVRFLOW,ri_ioq_fifo_status.UNDFLOW})
    ,.load_IBCPL_HDR_FIFO_STATUS                    ({ibcpl_hdr_fifo_status.OVRFLOW,ibcpl_hdr_fifo_status.UNDFLOW})
    ,.load_IBCPL_DATA_FIFO_STATUS                   ({ibcpl_data_fifo_status.OVRFLOW,ibcpl_data_fifo_status.UNDFLOW})
    ,.load_OBCPL_FIFO_STATUS                        ({obcpl_fifo_status.OVRFLOW,obcpl_fifo_status.UNDFLOW})
    ,.load_P_RL_CQ_FIFO_STATUS                      ({p_rl_cq_fifo_status.OVRFLOW,p_rl_cq_fifo_status.UNDFLOW})

    ,.new_RI_PHDR_FIFO_STATUS                       (ri_phdr_fifo_status)
    ,.new_RI_PDATA_FIFO_STATUS                      (ri_pdata_fifo_status)
    ,.new_RI_NPHDR_FIFO_STATUS                      (ri_nphdr_fifo_status)
    ,.new_RI_NPDATA_FIFO_STATUS                     (ri_npdata_fifo_status)
    ,.new_RI_IOQ_FIFO_STATUS                        (ri_ioq_fifo_status)
    ,.new_IBCPL_HDR_FIFO_STATUS                     (ibcpl_hdr_fifo_status)
    ,.new_IBCPL_DATA_FIFO_STATUS                    (ibcpl_data_fifo_status)
    ,.new_OBCPL_FIFO_STATUS                         (obcpl_fifo_status)
    ,.new_P_RL_CQ_FIFO_STATUS                       (p_rl_cq_fifo_status)

    ,.new_SIF_DB_STATUS                             (sif_db_status)
    ,.new_RI_DB_STATUS                              (ri_db_status)
    ,.new_DEVTLB_STATUS                             (devtlb_status)
    ,.new_SCRBD_STATUS                              (scrbd_status)
    ,.new_MSTR_CRD_STATUS                           (mstr_crd_status)
    ,.new_MSTR_FL_STATUS                            (mstr_fl_status)
    ,.new_MSTR_LL_STATUS                            (mstr_ll_status)

    ,.new_LOCAL_BME_STATUS                          (local_bme_status)
    ,.new_LOCAL_MSIXE_STATUS                        (local_msixe_status)

    ,.RI_PHDR_FIFO_STATUS                           (ri_phdr_fifo_status_nc)
    ,.RI_PDATA_FIFO_STATUS                          (ri_pdata_fifo_status_nc)
    ,.RI_NPHDR_FIFO_STATUS                          (ri_nphdr_fifo_status_nc)
    ,.RI_NPDATA_FIFO_STATUS                         (ri_npdata_fifo_status_nc)
    ,.RI_IOQ_FIFO_STATUS                            (ri_ioq_fifo_status_nc)
    ,.IBCPL_HDR_FIFO_STATUS                         (ibcpl_hdr_fifo_status_nc)
    ,.P_RL_CQ_FIFO_STATUS                           (p_rl_cq_fifo_status_nc)
    ,.IBCPL_DATA_FIFO_STATUS                        (ibcpl_data_fifo_status_nc)
    ,.OBCPL_FIFO_STATUS                             (obcpl_fifo_status_nc)

    ,.SIF_DB_STATUS                                 (sif_db_status_nc)
    ,.RI_DB_STATUS                                  (ri_db_status_nc)
    ,.DEVTLB_STATUS                                 (devtlb_status_nc)
    ,.SCRBD_STATUS                                  (scrbd_status_nc)
    ,.MSTR_CRD_STATUS                               (mstr_crd_status_nc)
    ,.MSTR_FL_STATUS                                (mstr_fl_status_nc)
    ,.MSTR_LL_STATUS                                (mstr_ll_status_nc)

    ,.LOCAL_BME_STATUS                              (local_bme_status_nc)
    ,.LOCAL_MSIXE_STATUS                            (local_msixe_status_nc)

    ,.RI_PHDR_FIFO_CTL                              (ri_phdr_fifo_ctl)
    ,.RI_PDATA_FIFO_CTL                             (ri_pdata_fifo_ctl)
    ,.RI_NPHDR_FIFO_CTL                             (ri_nphdr_fifo_ctl)
    ,.RI_NPDATA_FIFO_CTL                            (ri_npdata_fifo_ctl)
    ,.RI_IOQ_FIFO_CTL                               (ri_ioq_fifo_ctl)
    ,.IBCPL_HDR_FIFO_CTL                            (ibcpl_hdr_fifo_ctl)
    ,.IBCPL_DATA_FIFO_CTL                           (ibcpl_data_fifo_ctl)

    ,.OBCPL_AFULL_AGITATE_CONTROL                   (obcpl_afull_agitate_control)

    ,.new_HQM_PULLED_FUSES_0                        (pulled_fuses_0)

    ,.HQM_PULLED_FUSES_0                            (pulled_fuses_0_nc)

    ,.new_CFGM_STATUS                               (cfgm_status)
    ,.new_CFGM_STATUS2                              (cfgm_status2)

    ,.CFGM_STATUS                                   (cfgm_status_nc)
    ,.CFGM_STATUS2                                  (cfgm_status2_nc)

    ,.new_SIF_MSTR_DEBUG                            (sif_mstr_debug)

    ,.SIF_MSTR_DEBUG                                (sif_mstr_debug_nc)

    ,.CFG_UNIT_VERSION                              (cfg_unit_version_nc)

    ,.new_TGT_INIT_HCREDITS                         (tgt_init_hcredits)
    ,.new_TGT_INIT_DCREDITS                         (tgt_init_dcredits)
    ,.new_TGT_REM_HCREDITS                          (tgt_rem_hcredits)
    ,.new_TGT_REM_DCREDITS                          (tgt_rem_dcredits)
    ,.new_TGT_RET_HCREDITS                          (tgt_ret_hcredits)
    ,.new_TGT_RET_DCREDITS                          (tgt_ret_dcredits)

    ,.TGT_INIT_HCREDITS                             (tgt_init_hcredits_nc)
    ,.TGT_INIT_DCREDITS                             (tgt_init_dcredits_nc)
    ,.TGT_REM_HCREDITS                              (tgt_rem_hcredits_nc)
    ,.TGT_REM_DCREDITS                              (tgt_rem_dcredits_nc)
    ,.TGT_RET_HCREDITS                              (tgt_ret_hcredits_nc)
    ,.TGT_RET_DCREDITS                              (tgt_ret_dcredits_nc)

    ,.load_RI_PARITY_ERR                            (set_ri_parity_err)
    ,.new_RI_PARITY_ERR                             ('1)
    ,.RI_PARITY_ERR                                 (ri_parity_err_nc)

    ,.load_SIF_PARITY_ERR                           (set_sif_parity_err)
    ,.new_SIF_PARITY_ERR                            ('1)
    ,.SIF_PARITY_ERR                                (sif_parity_err_nc)

    ,.load_DEVTLB_ATS_ERR                           (set_devtlb_ats_err)
    ,.new_DEVTLB_ATS_ERR                            ('1)
    ,.DEVTLB_ATS_ERR                                (devtlb_ats_err_nc)

    ,.load_IBCPL_ERR                                (set_ibcpl_err)
    ,.load_IBCPL_ERR_HDR_2                          (set_ibcpl_err_hdr)
    ,.load_IBCPL_ERR_HDR_1                          (set_ibcpl_err_hdr)
    ,.load_IBCPL_ERR_HDR_0                          (set_ibcpl_err_hdr)
    ,.new_IBCPL_ERR                                 ('1)
    ,.new_IBCPL_ERR_HDR_2                           (ibcpl_err_hdr[95:64])
    ,.new_IBCPL_ERR_HDR_1                           (ibcpl_err_hdr[63:32])
    ,.new_IBCPL_ERR_HDR_0                           (ibcpl_err_hdr[31: 0])
    ,.IBCPL_ERR                                     (ibcpl_err)
    ,.IBCPL_ERR_HDR_2                               (ibcpl_err_hdr_nc[95:64])
    ,.IBCPL_ERR_HDR_1                               (ibcpl_err_hdr_nc[63:32])
    ,.IBCPL_ERR_HDR_0                               (ibcpl_err_hdr_nc[31: 0])

    ,.new_HQM_SIF_CNT_0                             (hqm_sif_cnt[0])
    ,.new_HQM_SIF_CNT_1                             (hqm_sif_cnt[1])
    ,.new_HQM_SIF_CNT_2                             (hqm_sif_cnt[2])
    ,.new_HQM_SIF_CNT_3                             (hqm_sif_cnt[3])
    ,.new_HQM_SIF_CNT_4                             (hqm_sif_cnt[4])
    ,.new_HQM_SIF_CNT_5                             (hqm_sif_cnt[5])
    ,.new_HQM_SIF_CNT_6                             (hqm_sif_cnt[6])
    ,.new_HQM_SIF_CNT_7                             (hqm_sif_cnt[7])
    ,.new_HQM_SIF_CNT_8                             (hqm_sif_cnt[8])
    ,.new_HQM_SIF_CNT_9                             (hqm_sif_cnt[9])
    ,.new_HQM_SIF_CNT_10                            (hqm_sif_cnt[10])
    ,.new_HQM_SIF_CNT_11                            (hqm_sif_cnt[11])

    ,.HQM_SIF_CNT_CTL                               (hqm_sif_cnt_ctl)
    ,.HQM_SIF_CNT_0                                 (hqm_sif_cnt_0_nc)
    ,.HQM_SIF_CNT_1                                 (hqm_sif_cnt_1_nc)
    ,.HQM_SIF_CNT_2                                 (hqm_sif_cnt_2_nc)
    ,.HQM_SIF_CNT_3                                 (hqm_sif_cnt_3_nc)
    ,.HQM_SIF_CNT_4                                 (hqm_sif_cnt_4_nc)
    ,.HQM_SIF_CNT_5                                 (hqm_sif_cnt_5_nc)
    ,.HQM_SIF_CNT_6                                 (hqm_sif_cnt_6_nc)
    ,.HQM_SIF_CNT_7                                 (hqm_sif_cnt_7_nc)
    ,.HQM_SIF_CNT_8                                 (hqm_sif_cnt_8_nc)
    ,.HQM_SIF_CNT_9                                 (hqm_sif_cnt_9_nc)
    ,.HQM_SIF_CNT_10                                (hqm_sif_cnt_10_nc)
    ,.HQM_SIF_CNT_11                                (hqm_sif_cnt_11_nc)

    ,.SIF_CTL                                       (cfg_sif_ctl)
    ,.SIF_VC_RXMAP                                  (cfg_sif_vc_rxmap)
    ,.SIF_VC_TXMAP                                  (cfg_sif_vc_txmap)

    ,.PRIM_CDC_CTL                                  (prim_cdc_ctl)
    ,.SIDE_CDC_CTL                                  (side_cdc_ctl)
    ,.IOSFP_CGCTL                                   (iosfp_cgctl)
    ,.IOSFS_CGCTL                                   (iosfs_cgctl)

    ,.DIR_CQ2TC_MAP                                 (dir_cq2tc_map)
    ,.LDB_CQ2TC_MAP                                 (ldb_cq2tc_map)
    ,.INT2TC_MAP                                    (int2tc_map)

    ,.PARITY_CTL                                    (parity_ctl)

    ,.CFG_MASTER_TIMEOUT                            (cfg_master_timeout)
    ,.MMIO_TIMEOUT                                  (cfg_mmio_timeout)
    ,.HCW_TIMEOUT                                   (cfg_hcw_timeout)

    ,.handcode_reg_rdata_VISA_SW_CONTROL            (cfg_visa_sw_control)
    ,.handcode_rvalid_VISA_SW_CONTROL               (|cfg_visa_sw_control_re)           
    ,.handcode_wvalid_VISA_SW_CONTROL               (cfg_visa_sw_control_write_done)
    ,.handcode_error_VISA_SW_CONTROL                ('0)
    ,.handcode_reg_wdata_VISA_SW_CONTROL            (cfg_visa_sw_control_wdata)
    ,.we_VISA_SW_CONTROL                            (cfg_visa_sw_control_we)
    ,.re_VISA_SW_CONTROL                            (cfg_visa_sw_control_re)

    ,.CFG_PH_TRIGGER_ADDR_L                         (cfg_ph_trigger_addr[31: 0])
    ,.CFG_PH_TRIGGER_ADDR_U                         (cfg_ph_trigger_addr[63:32])
    ,.CFG_PH_TRIGGER_MASK_L                         (cfg_ph_trigger_mask[31: 0])
    ,.CFG_PH_TRIGGER_MASK_U                         (cfg_ph_trigger_mask[63:32])

    ,.new_SIF_IDLE_STATUS                           (sif_idle_status)
    ,.SIF_IDLE_STATUS                               (sif_idle_status_reg)

    ,.SCRBD_CTL                                     (scrbd_ctl)
    ,.MSTR_LL_CTL                                   (mstr_ll_ctl)
    ,.DEVTLB_CTL                                    (devtlb_ctl)
    ,.DEVTLB_SPARE                                  (devtlb_spare)
    ,.DEVTLB_DEFEATURE0                             (devtlb_defeature0)
    ,.DEVTLB_DEFEATURE1                             (devtlb_defeature1)
    ,.DEVTLB_DEFEATURE2                             (devtlb_defeature2)

    ,.handcode_reg_rdata_AW_SMON_ACTIVITYCOUNTER0   (hqm_sif_csr_hc_reg_read.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_reg_rdata_AW_SMON_ACTIVITYCOUNTER1   (hqm_sif_csr_hc_reg_read.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_reg_rdata_AW_SMON_COMPARE0           (hqm_sif_csr_hc_reg_read.AW_SMON_COMPARE0)
    ,.handcode_reg_rdata_AW_SMON_COMPARE1           (hqm_sif_csr_hc_reg_read.AW_SMON_COMPARE1)
    ,.handcode_reg_rdata_AW_SMON_CONFIGURATION0     (hqm_sif_csr_hc_reg_read.AW_SMON_CONFIGURATION0)
    ,.handcode_reg_rdata_AW_SMON_CONFIGURATION1     (hqm_sif_csr_hc_reg_read.AW_SMON_CONFIGURATION1)
    ,.handcode_reg_rdata_AW_SMON_MAXIMUM_TIMER      (hqm_sif_csr_hc_reg_read.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_reg_rdata_AW_SMON_TIMER              (hqm_sif_csr_hc_reg_read.AW_SMON_TIMER)
    ,.handcode_reg_rdata_AW_SMON_COMP_MASK0         (hqm_sif_csr_hc_reg_read.AW_SMON_COMP_MASK0)
    ,.handcode_reg_rdata_AW_SMON_COMP_MASK1         (hqm_sif_csr_hc_reg_read.AW_SMON_COMP_MASK1)

    ,.handcode_rvalid_AW_SMON_ACTIVITYCOUNTER0      (hqm_sif_csr_hc_rvalid.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_rvalid_AW_SMON_ACTIVITYCOUNTER1      (hqm_sif_csr_hc_rvalid.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_rvalid_AW_SMON_COMPARE0              (hqm_sif_csr_hc_rvalid.AW_SMON_COMPARE0)
    ,.handcode_rvalid_AW_SMON_COMPARE1              (hqm_sif_csr_hc_rvalid.AW_SMON_COMPARE1)
    ,.handcode_rvalid_AW_SMON_CONFIGURATION0        (hqm_sif_csr_hc_rvalid.AW_SMON_CONFIGURATION0)
    ,.handcode_rvalid_AW_SMON_CONFIGURATION1        (hqm_sif_csr_hc_rvalid.AW_SMON_CONFIGURATION1)
    ,.handcode_rvalid_AW_SMON_MAXIMUM_TIMER         (hqm_sif_csr_hc_rvalid.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_rvalid_AW_SMON_TIMER                 (hqm_sif_csr_hc_rvalid.AW_SMON_TIMER)
    ,.handcode_rvalid_AW_SMON_COMP_MASK0            (hqm_sif_csr_hc_rvalid.AW_SMON_COMP_MASK0)
    ,.handcode_rvalid_AW_SMON_COMP_MASK1            (hqm_sif_csr_hc_rvalid.AW_SMON_COMP_MASK1)

    ,.handcode_wvalid_AW_SMON_ACTIVITYCOUNTER0      (hqm_sif_csr_hc_wvalid.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_wvalid_AW_SMON_ACTIVITYCOUNTER1      (hqm_sif_csr_hc_wvalid.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_wvalid_AW_SMON_COMPARE0              (hqm_sif_csr_hc_wvalid.AW_SMON_COMPARE0)
    ,.handcode_wvalid_AW_SMON_COMPARE1              (hqm_sif_csr_hc_wvalid.AW_SMON_COMPARE1)
    ,.handcode_wvalid_AW_SMON_CONFIGURATION0        (hqm_sif_csr_hc_wvalid.AW_SMON_CONFIGURATION0)
    ,.handcode_wvalid_AW_SMON_CONFIGURATION1        (hqm_sif_csr_hc_wvalid.AW_SMON_CONFIGURATION1)
    ,.handcode_wvalid_AW_SMON_MAXIMUM_TIMER         (hqm_sif_csr_hc_wvalid.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_wvalid_AW_SMON_TIMER                 (hqm_sif_csr_hc_wvalid.AW_SMON_TIMER)
    ,.handcode_wvalid_AW_SMON_COMP_MASK0            (hqm_sif_csr_hc_wvalid.AW_SMON_COMP_MASK0)
    ,.handcode_wvalid_AW_SMON_COMP_MASK1            (hqm_sif_csr_hc_wvalid.AW_SMON_COMP_MASK1)

    ,.handcode_error_AW_SMON_ACTIVITYCOUNTER0       (hqm_sif_csr_hc_error.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_error_AW_SMON_ACTIVITYCOUNTER1       (hqm_sif_csr_hc_error.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_error_AW_SMON_COMPARE0               (hqm_sif_csr_hc_error.AW_SMON_COMPARE0)
    ,.handcode_error_AW_SMON_COMPARE1               (hqm_sif_csr_hc_error.AW_SMON_COMPARE1)
    ,.handcode_error_AW_SMON_CONFIGURATION0         (hqm_sif_csr_hc_error.AW_SMON_CONFIGURATION0)
    ,.handcode_error_AW_SMON_CONFIGURATION1         (hqm_sif_csr_hc_error.AW_SMON_CONFIGURATION1)
    ,.handcode_error_AW_SMON_MAXIMUM_TIMER          (hqm_sif_csr_hc_error.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_error_AW_SMON_TIMER                  (hqm_sif_csr_hc_error.AW_SMON_TIMER)
    ,.handcode_error_AW_SMON_COMP_MASK0             (hqm_sif_csr_hc_error.AW_SMON_COMP_MASK0)
    ,.handcode_error_AW_SMON_COMP_MASK1             (hqm_sif_csr_hc_error.AW_SMON_COMP_MASK1)

    ,.ack                                           (hqm_csr_int_mmio_ack)
    ,.sai_export                                    (hqm_sif_csr_sai_export)

    ,.HQM_CSR_CP_HI                                 (hqm_csr_cp_nc[63:32])
    ,.HQM_CSR_CP_LO                                 (hqm_csr_cp_nc[31:0])
    ,.HQM_CSR_RAC_HI                                (hqm_csr_rac[63:32])
    ,.HQM_CSR_RAC_LO                                (hqm_csr_rac[31:0])
    ,.HQM_CSR_WAC_HI                                (hqm_csr_wac[63:32])
    ,.HQM_CSR_WAC_LO                                (hqm_csr_wac[31:0])

    // Register signals for HandCoded registers

    ,.handcode_reg_wdata_AW_SMON_ACTIVITYCOUNTER0   (hqm_sif_csr_hc_reg_write.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_reg_wdata_AW_SMON_ACTIVITYCOUNTER1   (hqm_sif_csr_hc_reg_write.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_reg_wdata_AW_SMON_COMPARE0           (hqm_sif_csr_hc_reg_write.AW_SMON_COMPARE0)
    ,.handcode_reg_wdata_AW_SMON_COMPARE1           (hqm_sif_csr_hc_reg_write.AW_SMON_COMPARE1)
    ,.handcode_reg_wdata_AW_SMON_CONFIGURATION0     (hqm_sif_csr_hc_reg_write.AW_SMON_CONFIGURATION0)
    ,.handcode_reg_wdata_AW_SMON_CONFIGURATION1     (hqm_sif_csr_hc_reg_write.AW_SMON_CONFIGURATION1)
    ,.handcode_reg_wdata_AW_SMON_MAXIMUM_TIMER      (hqm_sif_csr_hc_reg_write.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_reg_wdata_AW_SMON_TIMER              (hqm_sif_csr_hc_reg_write.AW_SMON_TIMER)
    ,.handcode_reg_wdata_AW_SMON_COMP_MASK0         (hqm_sif_csr_hc_reg_write.AW_SMON_COMP_MASK0)
    ,.handcode_reg_wdata_AW_SMON_COMP_MASK1         (hqm_sif_csr_hc_reg_write.AW_SMON_COMP_MASK1)

    ,.we_AW_SMON_ACTIVITYCOUNTER0                   (hqm_sif_csr_hc_we.AW_SMON_ACTIVITYCOUNTER0)
    ,.we_AW_SMON_ACTIVITYCOUNTER1                   (hqm_sif_csr_hc_we.AW_SMON_ACTIVITYCOUNTER1)
    ,.we_AW_SMON_COMPARE0                           (hqm_sif_csr_hc_we.AW_SMON_COMPARE0)
    ,.we_AW_SMON_COMPARE1                           (hqm_sif_csr_hc_we.AW_SMON_COMPARE1)
    ,.we_AW_SMON_CONFIGURATION0                     (hqm_sif_csr_hc_we.AW_SMON_CONFIGURATION0)
    ,.we_AW_SMON_CONFIGURATION1                     (hqm_sif_csr_hc_we.AW_SMON_CONFIGURATION1)
    ,.we_AW_SMON_MAXIMUM_TIMER                      (hqm_sif_csr_hc_we.AW_SMON_MAXIMUM_TIMER)
    ,.we_AW_SMON_TIMER                              (hqm_sif_csr_hc_we.AW_SMON_TIMER)
    ,.we_AW_SMON_COMP_MASK0                         (hqm_sif_csr_hc_we.AW_SMON_COMP_MASK0)
    ,.we_AW_SMON_COMP_MASK1                         (hqm_sif_csr_hc_we.AW_SMON_COMP_MASK1)

    ,.re_AW_SMON_ACTIVITYCOUNTER0                   (hqm_sif_csr_hc_re.AW_SMON_ACTIVITYCOUNTER0)
    ,.re_AW_SMON_ACTIVITYCOUNTER1                   (hqm_sif_csr_hc_re.AW_SMON_ACTIVITYCOUNTER1)
    ,.re_AW_SMON_COMPARE0                           (hqm_sif_csr_hc_re.AW_SMON_COMPARE0)
    ,.re_AW_SMON_COMPARE1                           (hqm_sif_csr_hc_re.AW_SMON_COMPARE1)
    ,.re_AW_SMON_CONFIGURATION0                     (hqm_sif_csr_hc_re.AW_SMON_CONFIGURATION0)
    ,.re_AW_SMON_CONFIGURATION1                     (hqm_sif_csr_hc_re.AW_SMON_CONFIGURATION1)
    ,.re_AW_SMON_MAXIMUM_TIMER                      (hqm_sif_csr_hc_re.AW_SMON_MAXIMUM_TIMER)
    ,.re_AW_SMON_TIMER                              (hqm_sif_csr_hc_re.AW_SMON_TIMER)
    ,.re_AW_SMON_COMP_MASK0                         (hqm_sif_csr_hc_re.AW_SMON_COMP_MASK0)
    ,.re_AW_SMON_COMP_MASK1                         (hqm_sif_csr_hc_re.AW_SMON_COMP_MASK1)

);        //    i_hqm_sif_csr

assign hqm_sif_csr_hc_we.VISA_SW_CONTROL        = '0;
assign hqm_sif_csr_hc_re.VISA_SW_CONTROL        = '0;
assign hqm_sif_csr_hc_reg_write.VISA_SW_CONTROL = '0;

assign cfg_visa_sw_control_write = &cfg_visa_sw_control_we;

hqm_AW_unused_bits i_unused (   

    .a  (|{ri_phdr_fifo_status_nc
          ,ri_pdata_fifo_status_nc
          ,ri_nphdr_fifo_status_nc
          ,ri_npdata_fifo_status_nc
          ,ri_ioq_fifo_status_nc
          ,ibcpl_hdr_fifo_status_nc
          ,ibcpl_data_fifo_status_nc
          ,obcpl_fifo_status_nc
          ,p_rl_cq_fifo_status_nc
          ,ri_db_status_nc
          ,sif_db_status_nc
          ,devtlb_status_nc
          ,scrbd_status_nc
          ,mstr_crd_status_nc
          ,mstr_fl_status_nc
          ,mstr_ll_status_nc
          ,local_bme_status_nc
          ,local_msixe_status_nc
          ,cfgm_status_nc
          ,cfgm_status2_nc
          ,pulled_fuses_0_nc
          ,cfg_unit_version_nc
          ,tgt_init_hcredits_nc
          ,tgt_init_dcredits_nc
          ,tgt_rem_hcredits_nc
          ,tgt_rem_dcredits_nc
          ,tgt_ret_hcredits_nc
          ,tgt_ret_dcredits_nc
          ,sif_mstr_debug_nc
          ,ri_parity_err_nc
          ,sif_parity_err_nc
          ,devtlb_ats_err_nc
          ,hqm_sif_cnt_0_nc
          ,hqm_sif_cnt_1_nc
          ,hqm_sif_cnt_2_nc
          ,hqm_sif_cnt_3_nc
          ,hqm_sif_cnt_4_nc
          ,hqm_sif_cnt_5_nc
          ,hqm_sif_cnt_6_nc
          ,hqm_sif_cnt_7_nc
          ,hqm_sif_cnt_8_nc
          ,hqm_sif_cnt_9_nc
          ,hqm_sif_cnt_10_nc
          ,hqm_sif_cnt_11_nc
          ,hqm_csr_cp_nc
          ,ibcpl_err_hdr_nc
        })
);

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Assertions
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// PROTOS & COVERAGE
//-------------------------------------------------------------------------
// - Hot reset when there are pending CSR reads/writes (Execute reset
//   with pending CSR reads/writes, come out of reset and successfully
//   execute a CSR read/write); !sh_ep_rst_np &
//   ri.ri_lli_ctl.csr_wr_wp, csr_read_wp (w/  csr_mem_mapped_wp=1/0, and
//   all functions; csr_wr_func_wxp, csr_rd_rund_wxp), iosf_csr_cmd_blk,
//   ri.ri_int.msix_tbl_wr, msix_tbl_rd.
// - FLR reset when there are pending CSR reads/writes (Execute reset
//   with pending CSR reads/writes, come out of reset and successfully
//   execute a CSR read/write); !ri_flr_rxp &
//   ri.ri_lli_ctl.csr_wr_wp, csr_read_wp (w/  csr_mem_mapped_wp=1/0, and
//   all functions; csr_wr_func_wxp, csr_rd_rund_wxp), iosf_csr_cmd_blk,
//   ri.ri_int.msix_tbl_wr, msix_tbl_rd.
// - Verify that after an FLR to each of the functions that the funtions
//   is put back into the pf*_pm_state=D0ACT and that the following
//   events to the given function are executed; csr_wr_wxp, csr_rd_wxp,
//   csr_cb_stall, csr_vf_write_wp, csr_mm_write, csr_pf_write, msi_cmd_req,
//   intx_req, int2me_req

endmodule // hqm_sif_csr_wrap

