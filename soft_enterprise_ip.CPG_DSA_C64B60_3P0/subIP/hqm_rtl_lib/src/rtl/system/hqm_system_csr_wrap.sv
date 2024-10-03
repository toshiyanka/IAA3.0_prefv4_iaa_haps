// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name : hqm_system_csr_wrap
// -- Author : Dannie Feekes
// -- Project Name : Cave Creek
// -- Creation Date: Thursday December 11, 2008
// -- Description :
// The CSR FUB contains the instantiation for all physical and
// virtual CSR functions.
// -------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_system_csr_wrap

    import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    //-----------------------------------------------------------------
    // Clock and reset
    //-----------------------------------------------------------------

     input  logic                                                           hqm_inp_gated_clk
    ,input  logic                                                           hqm_inp_gated_rst_n

    ,input  hqm_rtlgen_pkg_v12::cfg_req_32bit_t                             hqm_system_csr_req
    ,output hqm_rtlgen_pkg_v12::cfg_ack_32bit_t                             hqm_system_csr_ack

    // SAI read/write enables for OS_W security policy group

    ,input  hqm_system_csr_pkg::hqm_system_csr_sai_import_t                 hqm_system_csr_sai_import

    // hqm_system memory interfaces

    ,input  hqm_system_csr_pkg::hqm_system_csr_hc_rvalid_t                  hqm_system_csr_hc_rvalid
    ,input  hqm_system_csr_pkg::hqm_system_csr_hc_wvalid_t                  hqm_system_csr_hc_wvalid
    ,input  hqm_system_csr_pkg::hqm_system_csr_hc_error_t                   hqm_system_csr_hc_error
    ,input  hqm_system_csr_pkg::hqm_system_csr_hc_reg_read_t                hqm_system_csr_hc_reg_read

    ,output hqm_system_csr_pkg::hqm_system_csr_handcoded_t                  hqm_system_csr_hc_we
    ,output hqm_system_csr_pkg::hqm_system_csr_hc_re_t                      hqm_system_csr_hc_re
    ,output hqm_system_csr_pkg::hqm_system_csr_hc_reg_write_t               hqm_system_csr_hc_reg_write

    // hqm_system status and control CSRs

    ,input  new_ALARM_DB_STATUS_t                                           alarm_db_status
    ,input  new_EGRESS_DB_STATUS_t                                          egress_db_status
    ,input  new_INGRESS_DB_STATUS_t                                         ingress_db_status

    ,input  new_SYS_IDLE_STATUS_t                                           sys_idle_status
    ,input  new_ALARM_STATUS_t                                              alarm_status
    ,input  new_EGRESS_STATUS_t                                             egress_status
    ,input  new_INGRESS_STATUS_t                                            ingress_status
    ,input  new_WBUF_STATUS_t                                               wbuf_status
    ,input  new_WBUF_STATUS2_t                                              wbuf_status2
    ,input  new_WBUF_DEBUG_t                                                wbuf_debug
    ,input  logic [83:0]                                                    cfg_phdr_debug
    ,input  logic [511:0]                                                   cfg_pdata_debug
    ,input  logic [153:0]                                                   hcw_debug_data

    ,input  new_HCW_ENQ_FIFO_STATUS_t                                       hcw_enq_fifo_status
    ,input  new_HCW_SCH_FIFO_STATUS_t                                       hcw_sch_fifo_status
    ,input  new_SCH_OUT_FIFO_STATUS_t                                       sch_out_fifo_status
    ,input  new_CFG_RX_FIFO_STATUS_t                                        cfg_rx_fifo_status
    ,input  new_CWDI_RX_FIFO_STATUS_t                                       cwdi_rx_fifo_status
    ,input  new_HQM_ALARM_RX_FIFO_STATUS_t                                  hqm_alarm_rx_fifo_status
    ,input  new_SIF_ALARM_FIFO_STATUS_t                                     sif_alarm_fifo_status

    ,input  new_ALARM_LUT_PERR_t                                            alarm_lut_perr
    ,input  new_EGRESS_LUT_ERR_t                                            egress_lut_err
    ,input  new_INGRESS_LUT_ERR_t                                           ingress_lut_err

    ,output ECC_CTL_t                                                       ecc_ctl
    ,output PARITY_CTL_t                                                    parity_ctl
    ,output INGRESS_ALARM_ENABLE_t                                          ingress_alarm_enable
    ,output SYS_ALARM_INT_ENABLE_t                                          sys_alarm_int_enable
    ,output SYS_ALARM_SB_ECC_INT_ENABLE_t                                   sys_alarm_sb_ecc_int_enable
    ,output SYS_ALARM_MB_ECC_INT_ENABLE_t                                   sys_alarm_mb_ecc_int_enable
    ,output WRITE_BUFFER_CTL_t                                              write_buffer_ctl
    ,output INGRESS_CTL_t                                                   ingress_ctl
    ,output EGRESS_CTL_t                                                    egress_ctl
    ,output ALARM_CTL_t                                                     alarm_ctl
    ,output CFG_PATCH_CONTROL_t                                             cfg_patch_control

    ,output HCW_ENQ_FIFO_CTL_t                                              hcw_enq_fifo_ctl
    ,output SCH_OUT_FIFO_CTL_t                                              sch_out_fifo_ctl
    ,output SIF_ALARM_FIFO_CTL_t                                            sif_alarm_fifo_ctl

    // HW agitate control
    ,output WB_SCH_OUT_AFULL_AGITATE_CONTROL_t                              wb_sch_out_afull_agitate_control      // SCH_OUT almost full agitate control
    ,output IG_HCW_ENQ_AFULL_AGITATE_CONTROL_t                              ig_hcw_enq_afull_agitate_control      // HCW Enqueue almost full agitate control
    ,output IG_HCW_ENQ_W_DB_AGITATE_CONTROL_t                               ig_hcw_enq_w_db_agitate_control       // HCW Enqueue W double buffer agitate control
    ,output EG_HCW_SCHED_DB_AGITATE_CONTROL_t                               eg_hcw_sched_db_agitate_control
    ,output AL_IMS_MSIX_DB_AGITATE_CONTROL_t                                al_ims_msix_db_agitate_control
    ,output AL_CWD_ALARM_DB_AGITATE_CONTROL_t                               al_cwd_alarm_db_agitate_control
    ,output AL_SIF_ALARM_AFULL_AGITATE_CONTROL_t                            al_sif_alarm_afull_agitate_control
    ,output AL_HQM_ALARM_DB_AGITATE_CONTROL_t                               al_hqm_alarm_db_agitate_control

    ,input  load_MSIX_ACK_t                                                 set_msix_ack
    ,input  load_ALARM_ERR_t                                                set_alarm_err
    ,input  load_ALARM_SB_ECC_ERR_t                                         set_alarm_sb_ecc_err
    ,input  load_ALARM_MB_ECC_ERR_t                                         set_alarm_mb_ecc_err
    ,input  load_DIR_CQ_63_32_OCC_INT_STATUS_t                              set_dir_cq_63_32_occ_int_status
    ,input  load_DIR_CQ_31_0_OCC_INT_STATUS_t                               set_dir_cq_31_0_occ_int_status
    ,input  load_LDB_CQ_63_32_OCC_INT_STATUS_t                              set_ldb_cq_63_32_occ_int_status
    ,input  load_LDB_CQ_31_0_OCC_INT_STATUS_t                               set_ldb_cq_31_0_occ_int_status

    ,output MSIX_ACK_t                                                      msix_ack
    ,output MSIX_PASSTHROUGH_t                                              msix_passthrough
    ,output MSIX_MODE_t                                                     msix_mode
    ,output logic [HQM_SYSTEM_NUM_MSIX-1:0]                                 msix_pba_clear
    ,output DIR_CQ_63_32_OCC_INT_STATUS_t                                   dir_cq_63_32_occ_int_status
    ,output DIR_CQ_31_0_OCC_INT_STATUS_t                                    dir_cq_31_0_occ_int_status
    ,output LDB_CQ_63_32_OCC_INT_STATUS_t                                   ldb_cq_63_32_occ_int_status
    ,output LDB_CQ_31_0_OCC_INT_STATUS_t                                    ldb_cq_31_0_occ_int_status

    ,output ALARM_ERR_t                                                     alarm_err

    ,output SYS_IDLE_STATUS_t                                               sys_idle_status_reg

    ,output HQM_SYSTEM_CNT_CTL_t                                            hqm_system_cnt_ctl
    ,input  logic [21:0] [31:0]                                             hqm_system_cnt

    ,input  logic [HQM_SYSTEM_NUM_MSIX-1:0]                                 msix_synd

    ,output HQM_DIR_PP2VDEV_t [NUM_DIR_PP-1:0]                              dir_pp2vdev
    ,output HQM_LDB_PP2VDEV_t [NUM_LDB_PP-1:0]                              ldb_pp2vdev

    ,output DIR_PP_ROB_V_t [NUM_DIR_PP-1:0]                                 dir_pp_rob_v
    ,output LDB_PP_ROB_V_t [NUM_LDB_PP-1:0]                                 ldb_pp_rob_v

    ,input  logic [(NUM_DIR_CQ+NUM_LDB_CQ)-1:0]                             ims_pend
    ,output logic [(NUM_DIR_CQ+NUM_LDB_CQ)-1:0]                             ims_mask
    ,output IMS_PEND_CLEAR_t                                                ims_pend_clear

    ,input  load_ROB_SYNDROME_t                                             set_rob_syndrome
    ,input  new_ROB_SYNDROME_t                                              rob_syndrome
);

MSIX_PBA_31_0_CLEAR_t           msix_pba_31_0_clear;
MSIX_PBA_63_32_CLEAR_t          msix_pba_63_32_clear;
MSIX_PBA_64_CLEAR_t             msix_pba_64_clear;

CFG_UNIT_VERSION_t              cfg_unit_version_nc;
HCW_ENQ_FIFO_STATUS_t           hcw_enq_fifo_status_nc;
HCW_SCH_FIFO_STATUS_t           hcw_sch_fifo_status_nc;
SCH_OUT_FIFO_STATUS_t           sch_out_fifo_status_nc;
CFG_RX_FIFO_STATUS_t            cfg_rx_fifo_status_nc;
CWDI_RX_FIFO_STATUS_t           cwdi_rx_fifo_status_nc;
HQM_ALARM_RX_FIFO_STATUS_t      hqm_alarm_rx_fifo_status_nc;
SIF_ALARM_FIFO_STATUS_t         sif_alarm_fifo_status_nc;
ALARM_DB_STATUS_t               alarm_db_status_nc;
EGRESS_DB_STATUS_t              egress_db_status_nc;
INGRESS_DB_STATUS_t             ingress_db_status_nc;
ALARM_STATUS_t                  alarm_status_nc;
EGRESS_STATUS_t                 egress_status_nc;
INGRESS_STATUS_t                ingress_status_nc;
WBUF_STATUS_t                   wbuf_status_nc;
WBUF_STATUS2_t                  wbuf_status2_nc;
WBUF_DEBUG_t                    wbuf_debug_nc;
PHDR_DEBUG_0_t                  phdr_debug_0_nc;
PHDR_DEBUG_1_t                  phdr_debug_1_nc;
PHDR_DEBUG_2_t                  phdr_debug_2_nc;
HQM_PDATA_DEBUG_t [15:0]        pdata_debug_nc;
HCW_REQ_DEBUG_t                 hcw_req_debug_nc;
HQM_HCW_DATA_DEBUG_t [3:0]      hcw_data_debug_nc;
ALARM_LUT_PERR_t                alarm_lut_perr_nc;
EGRESS_LUT_ERR_t                egress_lut_err_nc;
INGRESS_LUT_ERR_t               ingress_lut_err_nc;
MSIX_31_0_SYND_t                msix_31_0_synd_nc;
MSIX_63_32_SYND_t               msix_63_32_synd_nc;
MSIX_64_SYND_t                  msix_64_synd_nc;
HQM_SYSTEM_CNT_0_t              hqm_system_cnt_0_nc;
HQM_SYSTEM_CNT_1_t              hqm_system_cnt_1_nc;
HQM_SYSTEM_CNT_2_t              hqm_system_cnt_2_nc;
HQM_SYSTEM_CNT_3_t              hqm_system_cnt_3_nc;
HQM_SYSTEM_CNT_4_t              hqm_system_cnt_4_nc;
HQM_SYSTEM_CNT_5_t              hqm_system_cnt_5_nc;
HQM_SYSTEM_CNT_6_t              hqm_system_cnt_6_nc;
HQM_SYSTEM_CNT_7_t              hqm_system_cnt_7_nc;
HQM_SYSTEM_CNT_8_t              hqm_system_cnt_8_nc;
HQM_SYSTEM_CNT_9_t              hqm_system_cnt_9_nc;
HQM_SYSTEM_CNT_10_t             hqm_system_cnt_10_nc;
HQM_SYSTEM_CNT_11_t             hqm_system_cnt_11_nc;
HQM_SYSTEM_CNT_12_t             hqm_system_cnt_12_nc;
HQM_SYSTEM_CNT_13_t             hqm_system_cnt_13_nc;
HQM_SYSTEM_CNT_14_t             hqm_system_cnt_14_nc;
HQM_SYSTEM_CNT_15_t             hqm_system_cnt_15_nc;
HQM_SYSTEM_CNT_16_t             hqm_system_cnt_16_nc;
HQM_SYSTEM_CNT_17_t             hqm_system_cnt_17_nc;
HQM_SYSTEM_CNT_18_t             hqm_system_cnt_18_nc;
HQM_SYSTEM_CNT_19_t             hqm_system_cnt_19_nc;
HQM_SYSTEM_CNT_20_t             hqm_system_cnt_20_nc;
HQM_SYSTEM_CNT_21_t             hqm_system_cnt_21_nc;
ALARM_SB_ECC_ERR_t              alarm_sb_ecc_err_nc;
ALARM_MB_ECC_ERR_t              alarm_mb_ecc_err_nc;

TOTAL_CREDITS_t                 total_credits_nc;
TOTAL_DIR_PORTS_t               total_dir_ports_nc;
TOTAL_DIR_QID_t                 total_dir_qid_nc;
TOTAL_LDB_PORTS_t               total_ldb_ports_nc;
TOTAL_LDB_QID_t                 total_ldb_qid_nc;
TOTAL_SN_REGIONS_t              total_sn_regions_nc;
TOTAL_VAS_t                     total_vas_nc;
TOTAL_VF_t                      total_vf_nc;

ROB_SYNDROME_t                  rob_syndrome_nc;

AI_CTRL_t [(NUM_DIR_CQ+NUM_LDB_CQ)-1:0] ai_ctrl;

logic                           ims_rsvd_nc;

assign msix_pba_clear = {msix_pba_64_clear[0], msix_pba_63_32_clear, msix_pba_31_0_clear};

hqm_system_csr #(

     .TOTAL_CREDITS_PARAM                           (hqm_pkg::NUM_CREDITS)
    ,.TOTAL_DIR_PORTS_PARAM                         (hqm_pkg::NUM_DIR_PP)
    ,.TOTAL_DIR_QID_PARAM                           (hqm_pkg::NUM_DIR_QID)
    ,.TOTAL_LDB_PORTS_PARAM                         (hqm_pkg::NUM_LDB_PP)
    ,.TOTAL_LDB_QID_PARAM                           (hqm_pkg::NUM_LDB_QID)
    ,.TOTAL_SN_GROUP_PARAM                          (hqm_pkg::TOTAL_SN_GROUP)
    ,.TOTAL_SN_SLOT_PARAM                           (hqm_pkg::TOTAL_SN_SLOT)
    ,.TOTAL_SN_MODE_PARAM                           (hqm_pkg::TOTAL_SN_MODE)
    ,.TOTAL_VAS_PARAM                               (hqm_pkg::NUM_VAS)
    ,.TOTAL_VF_PARAM                                (hqm_pkg::NUM_VF)

) i_hqm_system_csr (

     .rtl_clk                                       (hqm_inp_gated_clk)
    ,.gated_clk                                     (hqm_inp_gated_clk)
    ,.hqm_inp_gated_rst_n                           (hqm_inp_gated_rst_n)

    ,.req                                           (hqm_system_csr_req)

    ,.load_MSIX_ACK                                 (set_msix_ack)
    ,.load_ALARM_ERR                                (set_alarm_err)
    ,.load_ALARM_SB_ECC_ERR                         (set_alarm_sb_ecc_err)
    ,.load_ALARM_MB_ECC_ERR                         (set_alarm_mb_ecc_err)
    ,.load_DIR_CQ_63_32_OCC_INT_STATUS              (set_dir_cq_63_32_occ_int_status)
    ,.load_DIR_CQ_31_0_OCC_INT_STATUS               (set_dir_cq_31_0_occ_int_status)
    ,.load_LDB_CQ_63_32_OCC_INT_STATUS              (set_ldb_cq_63_32_occ_int_status)
    ,.load_LDB_CQ_31_0_OCC_INT_STATUS               (set_ldb_cq_31_0_occ_int_status)

    ,.new_MSIX_ACK                                  ('1)
    ,.new_ALARM_ERR                                 ('1)
    ,.new_ALARM_SB_ECC_ERR                          ('1)
    ,.new_ALARM_MB_ECC_ERR                          ('1)
    ,.new_DIR_CQ_63_32_OCC_INT_STATUS               ('1)
    ,.new_DIR_CQ_31_0_OCC_INT_STATUS                ('1)
    ,.new_LDB_CQ_63_32_OCC_INT_STATUS               ('1)
    ,.new_LDB_CQ_31_0_OCC_INT_STATUS                ('1)

    ,.MSIX_ACK                                      (msix_ack)
    ,.MSIX_PASSTHROUGH                              (msix_passthrough)
    ,.MSIX_MODE                                     (msix_mode)
    ,.MSIX_PBA_31_0_CLEAR                           (msix_pba_31_0_clear)
    ,.MSIX_PBA_63_32_CLEAR                          (msix_pba_63_32_clear)
    ,.MSIX_PBA_64_CLEAR                             (msix_pba_64_clear)
    ,.DIR_CQ_63_32_OCC_INT_STATUS                   (dir_cq_63_32_occ_int_status)
    ,.DIR_CQ_31_0_OCC_INT_STATUS                    (dir_cq_31_0_occ_int_status)
    ,.LDB_CQ_63_32_OCC_INT_STATUS                   (ldb_cq_63_32_occ_int_status)
    ,.LDB_CQ_31_0_OCC_INT_STATUS                    (ldb_cq_31_0_occ_int_status)

    ,.ALARM_ERR                                     (alarm_err)

    ,.new_ALARM_DB_STATUS                           (alarm_db_status)
    ,.new_EGRESS_DB_STATUS                          (egress_db_status)
    ,.new_INGRESS_DB_STATUS                         (ingress_db_status)

    ,.load_HCW_ENQ_FIFO_STATUS                      ({hcw_enq_fifo_status.OVRFLOW,       hcw_enq_fifo_status.UNDFLOW})
    ,.load_HCW_SCH_FIFO_STATUS                      ({hcw_sch_fifo_status.OVRFLOW,       hcw_sch_fifo_status.UNDFLOW})
    ,.load_SCH_OUT_FIFO_STATUS                      ({sch_out_fifo_status.OVRFLOW,       sch_out_fifo_status.UNDFLOW})
    ,.load_CFG_RX_FIFO_STATUS                       ({cfg_rx_fifo_status.OVRFLOW,        cfg_rx_fifo_status.UNDFLOW})
    ,.load_CWDI_RX_FIFO_STATUS                      ({cwdi_rx_fifo_status.OVRFLOW,       cwdi_rx_fifo_status.UNDFLOW})
    ,.load_HQM_ALARM_RX_FIFO_STATUS                 ({hqm_alarm_rx_fifo_status.OVRFLOW,  hqm_alarm_rx_fifo_status.UNDFLOW})
    ,.load_SIF_ALARM_FIFO_STATUS                    ({sif_alarm_fifo_status.OVRFLOW,     sif_alarm_fifo_status.UNDFLOW})

    ,.new_HCW_ENQ_FIFO_STATUS                       (hcw_enq_fifo_status)
    ,.new_HCW_SCH_FIFO_STATUS                       (hcw_sch_fifo_status)
    ,.new_SCH_OUT_FIFO_STATUS                       (sch_out_fifo_status)
    ,.new_CFG_RX_FIFO_STATUS                        (cfg_rx_fifo_status)
    ,.new_CWDI_RX_FIFO_STATUS                       (cwdi_rx_fifo_status)
    ,.new_HQM_ALARM_RX_FIFO_STATUS                  (hqm_alarm_rx_fifo_status)
    ,.new_SIF_ALARM_FIFO_STATUS                     (sif_alarm_fifo_status)

    ,.new_SYS_IDLE_STATUS                           (sys_idle_status)
    ,.new_ALARM_STATUS                              (alarm_status)
    ,.new_EGRESS_STATUS                             (egress_status)
    ,.new_INGRESS_STATUS                            (ingress_status)
    ,.new_WBUF_STATUS                               (wbuf_status)
    ,.new_WBUF_STATUS2                              (wbuf_status2)
    ,.new_WBUF_DEBUG                                (wbuf_debug)
    ,.new_PHDR_DEBUG_0                              (cfg_phdr_debug[31: 0])
    ,.new_PHDR_DEBUG_1                              (cfg_phdr_debug[63:32])
    ,.new_PHDR_DEBUG_2                              (cfg_phdr_debug[83:64])
    ,.new_HQM_PDATA_DEBUG                           (cfg_pdata_debug)
    ,.new_HCW_REQ_DEBUG                             ( hcw_debug_data[153:128])
    ,.new_HQM_HCW_DATA_DEBUG                        ({hcw_debug_data[127: 96]
                                                     ,hcw_debug_data[ 95: 64]
                                                     ,hcw_debug_data[ 63: 32]
                                                     ,hcw_debug_data[ 31:  0]
                                                    })

    ,.new_ALARM_LUT_PERR                            ('1)
    ,.new_EGRESS_LUT_ERR                            ('1)
    ,.new_INGRESS_LUT_ERR                           ('1)

    ,.load_ALARM_LUT_PERR                           (alarm_lut_perr)
    ,.load_EGRESS_LUT_ERR                           (egress_lut_err)
    ,.load_INGRESS_LUT_ERR                          (ingress_lut_err)

    ,.HQM_SYSTEM_CNT_CTL                            (hqm_system_cnt_ctl)
    ,.new_HQM_SYSTEM_CNT_0                          (hqm_system_cnt[0])
    ,.new_HQM_SYSTEM_CNT_1                          (hqm_system_cnt[1])
    ,.new_HQM_SYSTEM_CNT_2                          (hqm_system_cnt[2])
    ,.new_HQM_SYSTEM_CNT_3                          (hqm_system_cnt[3])
    ,.new_HQM_SYSTEM_CNT_4                          (hqm_system_cnt[4])
    ,.new_HQM_SYSTEM_CNT_5                          (hqm_system_cnt[5])
    ,.new_HQM_SYSTEM_CNT_6                          (hqm_system_cnt[6])
    ,.new_HQM_SYSTEM_CNT_7                          (hqm_system_cnt[7])
    ,.new_HQM_SYSTEM_CNT_8                          (hqm_system_cnt[8])
    ,.new_HQM_SYSTEM_CNT_9                          (hqm_system_cnt[9])
    ,.new_HQM_SYSTEM_CNT_10                         (hqm_system_cnt[10])
    ,.new_HQM_SYSTEM_CNT_11                         (hqm_system_cnt[11])
    ,.new_HQM_SYSTEM_CNT_12                         (hqm_system_cnt[12])
    ,.new_HQM_SYSTEM_CNT_13                         (hqm_system_cnt[13])
    ,.new_HQM_SYSTEM_CNT_14                         (hqm_system_cnt[14])
    ,.new_HQM_SYSTEM_CNT_15                         (hqm_system_cnt[15])
    ,.new_HQM_SYSTEM_CNT_16                         (hqm_system_cnt[16])
    ,.new_HQM_SYSTEM_CNT_17                         (hqm_system_cnt[17])
    ,.new_HQM_SYSTEM_CNT_18                         (hqm_system_cnt[18])
    ,.new_HQM_SYSTEM_CNT_19                         (hqm_system_cnt[19])
    ,.new_HQM_SYSTEM_CNT_20                         (hqm_system_cnt[20])
    ,.new_HQM_SYSTEM_CNT_21                         (hqm_system_cnt[21])

    ,.CFG_UNIT_VERSION                              (cfg_unit_version_nc)

    ,.ECC_CTL                                       (ecc_ctl)
    ,.PARITY_CTL                                    (parity_ctl)
    ,.INGRESS_ALARM_ENABLE                          (ingress_alarm_enable)
    ,.SYS_ALARM_INT_ENABLE                          (sys_alarm_int_enable)
    ,.SYS_ALARM_SB_ECC_INT_ENABLE                   (sys_alarm_sb_ecc_int_enable)
    ,.SYS_ALARM_MB_ECC_INT_ENABLE                   (sys_alarm_mb_ecc_int_enable)
    ,.WRITE_BUFFER_CTL                              (write_buffer_ctl)
    ,.INGRESS_CTL                                   (ingress_ctl)
    ,.EGRESS_CTL                                    (egress_ctl)
    ,.ALARM_CTL                                     (alarm_ctl)
    ,.CFG_PATCH_CONTROL                             (cfg_patch_control)

    ,.HCW_ENQ_FIFO_CTL                              (hcw_enq_fifo_ctl)
    ,.SCH_OUT_FIFO_CTL                              (sch_out_fifo_ctl)
    ,.SIF_ALARM_FIFO_CTL                            (sif_alarm_fifo_ctl)

    ,.WB_SCH_OUT_AFULL_AGITATE_CONTROL              (wb_sch_out_afull_agitate_control)
    ,.IG_HCW_ENQ_AFULL_AGITATE_CONTROL              (ig_hcw_enq_afull_agitate_control)
    ,.IG_HCW_ENQ_W_DB_AGITATE_CONTROL               (ig_hcw_enq_w_db_agitate_control)
    ,.EG_HCW_SCHED_DB_AGITATE_CONTROL               (eg_hcw_sched_db_agitate_control)
    ,.AL_IMS_MSIX_DB_AGITATE_CONTROL                (al_ims_msix_db_agitate_control)
    ,.AL_CWD_ALARM_DB_AGITATE_CONTROL               (al_cwd_alarm_db_agitate_control)
    ,.AL_SIF_ALARM_AFULL_AGITATE_CONTROL            (al_sif_alarm_afull_agitate_control)
    ,.AL_HQM_ALARM_DB_AGITATE_CONTROL               (al_hqm_alarm_db_agitate_control)

    ,.SYS_IDLE_STATUS                               (sys_idle_status_reg)

    ,.load_MSIX_31_0_SYND                           (msix_synd[31:0])
    ,.load_MSIX_63_32_SYND                          (msix_synd[63:32])
    ,.load_MSIX_64_SYND                             (msix_synd[64])
    ,.new_MSIX_31_0_SYND                            ('1)
    ,.new_MSIX_63_32_SYND                           ('1)
    ,.new_MSIX_64_SYND                              ('1)

    // These are all unused RO/V outputs,.  The new_* values above are the read-only values used.

    ,.HCW_ENQ_FIFO_STATUS                           (hcw_enq_fifo_status_nc)
    ,.HCW_SCH_FIFO_STATUS                           (hcw_sch_fifo_status_nc)
    ,.SCH_OUT_FIFO_STATUS                           (sch_out_fifo_status_nc)
    ,.CFG_RX_FIFO_STATUS                            (cfg_rx_fifo_status_nc)
    ,.CWDI_RX_FIFO_STATUS                           (cwdi_rx_fifo_status_nc)
    ,.HQM_ALARM_RX_FIFO_STATUS                      (hqm_alarm_rx_fifo_status_nc)
    ,.SIF_ALARM_FIFO_STATUS                         (sif_alarm_fifo_status_nc)
    ,.ALARM_DB_STATUS                               (alarm_db_status_nc)
    ,.EGRESS_DB_STATUS                              (egress_db_status_nc)
    ,.INGRESS_DB_STATUS                             (ingress_db_status_nc)
    ,.ALARM_STATUS                                  (alarm_status_nc)
    ,.EGRESS_STATUS                                 (egress_status_nc)
    ,.INGRESS_STATUS                                (ingress_status_nc)
    ,.WBUF_STATUS                                   (wbuf_status_nc)
    ,.WBUF_STATUS2                                  (wbuf_status2_nc)
    ,.WBUF_DEBUG                                    (wbuf_debug_nc)
    ,.PHDR_DEBUG_0                                  (phdr_debug_0_nc)
    ,.PHDR_DEBUG_1                                  (phdr_debug_1_nc)
    ,.PHDR_DEBUG_2                                  (phdr_debug_2_nc)
    ,.HQM_PDATA_DEBUG                               (pdata_debug_nc)
    ,.HCW_REQ_DEBUG                                 (hcw_req_debug_nc)
    ,.HQM_HCW_DATA_DEBUG                            (hcw_data_debug_nc)
    ,.ALARM_LUT_PERR                                (alarm_lut_perr_nc)
    ,.EGRESS_LUT_ERR                                (egress_lut_err_nc)
    ,.INGRESS_LUT_ERR                               (ingress_lut_err_nc)
    ,.MSIX_31_0_SYND                                (msix_31_0_synd_nc)
    ,.MSIX_63_32_SYND                               (msix_63_32_synd_nc)
    ,.MSIX_64_SYND                                  (msix_64_synd_nc)
    ,.HQM_SYSTEM_CNT_0                              (hqm_system_cnt_0_nc)
    ,.HQM_SYSTEM_CNT_1                              (hqm_system_cnt_1_nc)
    ,.HQM_SYSTEM_CNT_2                              (hqm_system_cnt_2_nc)
    ,.HQM_SYSTEM_CNT_3                              (hqm_system_cnt_3_nc)
    ,.HQM_SYSTEM_CNT_4                              (hqm_system_cnt_4_nc)
    ,.HQM_SYSTEM_CNT_5                              (hqm_system_cnt_5_nc)
    ,.HQM_SYSTEM_CNT_6                              (hqm_system_cnt_6_nc)
    ,.HQM_SYSTEM_CNT_7                              (hqm_system_cnt_7_nc)
    ,.HQM_SYSTEM_CNT_8                              (hqm_system_cnt_8_nc)
    ,.HQM_SYSTEM_CNT_9                              (hqm_system_cnt_9_nc)
    ,.HQM_SYSTEM_CNT_10                             (hqm_system_cnt_10_nc)
    ,.HQM_SYSTEM_CNT_11                             (hqm_system_cnt_11_nc)
    ,.HQM_SYSTEM_CNT_12                             (hqm_system_cnt_12_nc)
    ,.HQM_SYSTEM_CNT_13                             (hqm_system_cnt_13_nc)
    ,.HQM_SYSTEM_CNT_14                             (hqm_system_cnt_14_nc)
    ,.HQM_SYSTEM_CNT_15                             (hqm_system_cnt_15_nc)
    ,.HQM_SYSTEM_CNT_16                             (hqm_system_cnt_16_nc)
    ,.HQM_SYSTEM_CNT_17                             (hqm_system_cnt_17_nc)
    ,.HQM_SYSTEM_CNT_18                             (hqm_system_cnt_18_nc)
    ,.HQM_SYSTEM_CNT_19                             (hqm_system_cnt_19_nc)
    ,.HQM_SYSTEM_CNT_20                             (hqm_system_cnt_20_nc)
    ,.HQM_SYSTEM_CNT_21                             (hqm_system_cnt_21_nc)
    ,.ALARM_SB_ECC_ERR                              (alarm_sb_ecc_err_nc)
    ,.ALARM_MB_ECC_ERR                              (alarm_mb_ecc_err_nc)

    ,.AI_CTRL                                       (ai_ctrl)
    ,.new_AI_CTRL                                   (ims_pend)
    ,.IMS_PEND_CLEAR                                (ims_pend_clear)

    ,.handcode_reg_rdata_SBE_CNT_0                  (hqm_system_csr_hc_reg_read.SBE_CNT_0)
    ,.handcode_reg_rdata_SBE_CNT_1                  (hqm_system_csr_hc_reg_read.SBE_CNT_1)
    ,.handcode_reg_rdata_ALARM_HW_SYND              (hqm_system_csr_hc_reg_read.ALARM_HW_SYND)
    ,.handcode_reg_rdata_ALARM_PF_SYND0             (hqm_system_csr_hc_reg_read.ALARM_PF_SYND0)
    ,.handcode_reg_rdata_ALARM_PF_SYND1             (hqm_system_csr_hc_reg_read.ALARM_PF_SYND1)
    ,.handcode_reg_rdata_ALARM_PF_SYND2             (hqm_system_csr_hc_reg_read.ALARM_PF_SYND2)
    ,.handcode_reg_rdata_ALARM_VF_SYND0             (hqm_system_csr_hc_reg_read.ALARM_VF_SYND0)
    ,.handcode_reg_rdata_ALARM_VF_SYND1             (hqm_system_csr_hc_reg_read.ALARM_VF_SYND1)
    ,.handcode_reg_rdata_ALARM_VF_SYND2             (hqm_system_csr_hc_reg_read.ALARM_VF_SYND2)
    ,.handcode_reg_rdata_DIR_CQ_PASID               (hqm_system_csr_hc_reg_read.DIR_CQ_PASID)
    ,.handcode_reg_rdata_DIR_CQ_ADDR_L              (hqm_system_csr_hc_reg_read.DIR_CQ_ADDR_L)
    ,.handcode_reg_rdata_DIR_CQ_ADDR_U              (hqm_system_csr_hc_reg_read.DIR_CQ_ADDR_U)
    ,.handcode_reg_rdata_DIR_CQ2VF_PF_RO            (hqm_system_csr_hc_reg_read.DIR_CQ2VF_PF_RO)
    ,.handcode_reg_rdata_DIR_CQ_ISR                 (hqm_system_csr_hc_reg_read.DIR_CQ_ISR)
    ,.handcode_reg_rdata_AI_ADDR_L                  (hqm_system_csr_hc_reg_read.AI_ADDR_L)
    ,.handcode_reg_rdata_AI_ADDR_U                  (hqm_system_csr_hc_reg_read.AI_ADDR_U)
    ,.handcode_reg_rdata_AI_DATA                    (hqm_system_csr_hc_reg_read.AI_DATA)
    ,.handcode_reg_rdata_AW_SMON_ACTIVITYCOUNTER0   (hqm_system_csr_hc_reg_read.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_reg_rdata_AW_SMON_ACTIVITYCOUNTER1   (hqm_system_csr_hc_reg_read.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_reg_rdata_AW_SMON_COMPARE0           (hqm_system_csr_hc_reg_read.AW_SMON_COMPARE0)
    ,.handcode_reg_rdata_AW_SMON_COMPARE1           (hqm_system_csr_hc_reg_read.AW_SMON_COMPARE1)
    ,.handcode_reg_rdata_AW_SMON_CONFIGURATION0     (hqm_system_csr_hc_reg_read.AW_SMON_CONFIGURATION0)
    ,.handcode_reg_rdata_AW_SMON_CONFIGURATION1     (hqm_system_csr_hc_reg_read.AW_SMON_CONFIGURATION1)
    ,.handcode_reg_rdata_AW_SMON_MAXIMUM_TIMER      (hqm_system_csr_hc_reg_read.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_reg_rdata_AW_SMON_TIMER              (hqm_system_csr_hc_reg_read.AW_SMON_TIMER)
    ,.handcode_reg_rdata_AW_SMON_COMP_MASK0         (hqm_system_csr_hc_reg_read.AW_SMON_COMP_MASK0)
    ,.handcode_reg_rdata_AW_SMON_COMP_MASK1         (hqm_system_csr_hc_reg_read.AW_SMON_COMP_MASK1)
    ,.handcode_reg_rdata_PERF_SMON_ACTIVITYCOUNTER0 (hqm_system_csr_hc_reg_read.PERF_SMON_ACTIVITYCOUNTER0)
    ,.handcode_reg_rdata_PERF_SMON_ACTIVITYCOUNTER1 (hqm_system_csr_hc_reg_read.PERF_SMON_ACTIVITYCOUNTER1)
    ,.handcode_reg_rdata_PERF_SMON_COMPARE0         (hqm_system_csr_hc_reg_read.PERF_SMON_COMPARE0)
    ,.handcode_reg_rdata_PERF_SMON_COMPARE1         (hqm_system_csr_hc_reg_read.PERF_SMON_COMPARE1)
    ,.handcode_reg_rdata_PERF_SMON_CONFIGURATION0   (hqm_system_csr_hc_reg_read.PERF_SMON_CONFIGURATION0)
    ,.handcode_reg_rdata_PERF_SMON_CONFIGURATION1   (hqm_system_csr_hc_reg_read.PERF_SMON_CONFIGURATION1)
    ,.handcode_reg_rdata_PERF_SMON_MAXIMUM_TIMER    (hqm_system_csr_hc_reg_read.PERF_SMON_MAXIMUM_TIMER)
    ,.handcode_reg_rdata_PERF_SMON_TIMER            (hqm_system_csr_hc_reg_read.PERF_SMON_TIMER)
    ,.handcode_reg_rdata_PERF_SMON_COMP_MASK0       (hqm_system_csr_hc_reg_read.PERF_SMON_COMP_MASK0)
    ,.handcode_reg_rdata_PERF_SMON_COMP_MASK1       (hqm_system_csr_hc_reg_read.PERF_SMON_COMP_MASK1)
    ,.handcode_reg_rdata_DIR_CQ_FMT                 (hqm_system_csr_hc_reg_read.DIR_CQ_FMT)
    ,.handcode_reg_rdata_DIR_QID_ITS                (hqm_system_csr_hc_reg_read.DIR_QID_ITS)
    ,.handcode_reg_rdata_DIR_QID_V                  (hqm_system_csr_hc_reg_read.DIR_QID_V)
    ,.handcode_reg_rdata_DIR_PP2VAS                 (hqm_system_csr_hc_reg_read.DIR_PP2VAS)
    ,.handcode_reg_rdata_DIR_VASQID_V               (hqm_system_csr_hc_reg_read.DIR_VASQID_V)
    ,.handcode_reg_rdata_LDB_CQ_PASID               (hqm_system_csr_hc_reg_read.LDB_CQ_PASID)
    ,.handcode_reg_rdata_LDB_CQ_ADDR_L              (hqm_system_csr_hc_reg_read.LDB_CQ_ADDR_L)
    ,.handcode_reg_rdata_LDB_CQ_ADDR_U              (hqm_system_csr_hc_reg_read.LDB_CQ_ADDR_U)
    ,.handcode_reg_rdata_LDB_CQ2VF_PF_RO            (hqm_system_csr_hc_reg_read.LDB_CQ2VF_PF_RO)
    ,.handcode_reg_rdata_LDB_CQ_ISR                 (hqm_system_csr_hc_reg_read.LDB_CQ_ISR)
    ,.handcode_reg_rdata_LDB_QID_ITS                (hqm_system_csr_hc_reg_read.LDB_QID_ITS)
    ,.handcode_reg_rdata_LDB_QID_V                  (hqm_system_csr_hc_reg_read.LDB_QID_V)
    ,.handcode_reg_rdata_LDB_PP2VAS                 (hqm_system_csr_hc_reg_read.LDB_PP2VAS)
    ,.handcode_reg_rdata_LDB_QID_CFG_V              (hqm_system_csr_hc_reg_read.LDB_QID_CFG_V)
    ,.handcode_reg_rdata_LDB_VASQID_V               (hqm_system_csr_hc_reg_read.LDB_VASQID_V)
    ,.handcode_reg_rdata_VF_DIR_VPP2PP              (hqm_system_csr_hc_reg_read.VF_DIR_VPP2PP)
    ,.handcode_reg_rdata_VF_DIR_VPP_V               (hqm_system_csr_hc_reg_read.VF_DIR_VPP_V)
    ,.handcode_reg_rdata_DIR_PP_V                   (hqm_system_csr_hc_reg_read.DIR_PP_V)
    ,.handcode_reg_rdata_LDB_PP_V                   (hqm_system_csr_hc_reg_read.LDB_PP_V)
    ,.handcode_reg_rdata_VF_DIR_VQID2QID            (hqm_system_csr_hc_reg_read.VF_DIR_VQID2QID)
    ,.handcode_reg_rdata_VF_DIR_VQID_V              (hqm_system_csr_hc_reg_read.VF_DIR_VQID_V)
    ,.handcode_reg_rdata_LDB_QID2VQID               (hqm_system_csr_hc_reg_read.LDB_QID2VQID)
    ,.handcode_reg_rdata_VF_LDB_VPP2PP              (hqm_system_csr_hc_reg_read.VF_LDB_VPP2PP)
    ,.handcode_reg_rdata_VF_LDB_VPP_V               (hqm_system_csr_hc_reg_read.VF_LDB_VPP_V)
    ,.handcode_reg_rdata_VF_LDB_VQID2QID            (hqm_system_csr_hc_reg_read.VF_LDB_VQID2QID)
    ,.handcode_reg_rdata_VF_LDB_VQID_V              (hqm_system_csr_hc_reg_read.VF_LDB_VQID_V)
    ,.handcode_reg_rdata_WB_DIR_CQ_STATE            (hqm_system_csr_hc_reg_read.WB_DIR_CQ_STATE)
    ,.handcode_reg_rdata_WB_LDB_CQ_STATE            (hqm_system_csr_hc_reg_read.WB_LDB_CQ_STATE)

    ,.handcode_rvalid_SBE_CNT_0                     (hqm_system_csr_hc_rvalid.SBE_CNT_0)
    ,.handcode_rvalid_SBE_CNT_1                     (hqm_system_csr_hc_rvalid.SBE_CNT_1)
    ,.handcode_rvalid_ALARM_HW_SYND                 (hqm_system_csr_hc_rvalid.ALARM_HW_SYND)
    ,.handcode_rvalid_ALARM_PF_SYND0                (hqm_system_csr_hc_rvalid.ALARM_PF_SYND0)
    ,.handcode_rvalid_ALARM_PF_SYND1                (hqm_system_csr_hc_rvalid.ALARM_PF_SYND1)
    ,.handcode_rvalid_ALARM_PF_SYND2                (hqm_system_csr_hc_rvalid.ALARM_PF_SYND2)
    ,.handcode_rvalid_ALARM_VF_SYND0                (hqm_system_csr_hc_rvalid.ALARM_VF_SYND0)
    ,.handcode_rvalid_ALARM_VF_SYND1                (hqm_system_csr_hc_rvalid.ALARM_VF_SYND1)
    ,.handcode_rvalid_ALARM_VF_SYND2                (hqm_system_csr_hc_rvalid.ALARM_VF_SYND2)
    ,.handcode_rvalid_DIR_CQ_PASID                  (hqm_system_csr_hc_rvalid.DIR_CQ_PASID)
    ,.handcode_rvalid_DIR_CQ_ADDR_L                 (hqm_system_csr_hc_rvalid.DIR_CQ_ADDR_L)
    ,.handcode_rvalid_DIR_CQ_ADDR_U                 (hqm_system_csr_hc_rvalid.DIR_CQ_ADDR_U)
    ,.handcode_rvalid_DIR_CQ2VF_PF_RO               (hqm_system_csr_hc_rvalid.DIR_CQ2VF_PF_RO)
    ,.handcode_rvalid_DIR_CQ_ISR                    (hqm_system_csr_hc_rvalid.DIR_CQ_ISR)
    ,.handcode_rvalid_AI_ADDR_L                     (hqm_system_csr_hc_rvalid.AI_ADDR_L)
    ,.handcode_rvalid_AI_ADDR_U                     (hqm_system_csr_hc_rvalid.AI_ADDR_U)
    ,.handcode_rvalid_AI_DATA                       (hqm_system_csr_hc_rvalid.AI_DATA)
    ,.handcode_rvalid_AW_SMON_ACTIVITYCOUNTER0      (hqm_system_csr_hc_rvalid.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_rvalid_AW_SMON_ACTIVITYCOUNTER1      (hqm_system_csr_hc_rvalid.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_rvalid_AW_SMON_COMPARE0              (hqm_system_csr_hc_rvalid.AW_SMON_COMPARE0)
    ,.handcode_rvalid_AW_SMON_COMPARE1              (hqm_system_csr_hc_rvalid.AW_SMON_COMPARE1)
    ,.handcode_rvalid_AW_SMON_CONFIGURATION0        (hqm_system_csr_hc_rvalid.AW_SMON_CONFIGURATION0)
    ,.handcode_rvalid_AW_SMON_CONFIGURATION1        (hqm_system_csr_hc_rvalid.AW_SMON_CONFIGURATION1)
    ,.handcode_rvalid_AW_SMON_MAXIMUM_TIMER         (hqm_system_csr_hc_rvalid.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_rvalid_AW_SMON_TIMER                 (hqm_system_csr_hc_rvalid.AW_SMON_TIMER)
    ,.handcode_rvalid_AW_SMON_COMP_MASK0            (hqm_system_csr_hc_rvalid.AW_SMON_COMP_MASK0)
    ,.handcode_rvalid_AW_SMON_COMP_MASK1            (hqm_system_csr_hc_rvalid.AW_SMON_COMP_MASK1)
    ,.handcode_rvalid_PERF_SMON_ACTIVITYCOUNTER0    (hqm_system_csr_hc_rvalid.PERF_SMON_ACTIVITYCOUNTER0)
    ,.handcode_rvalid_PERF_SMON_ACTIVITYCOUNTER1    (hqm_system_csr_hc_rvalid.PERF_SMON_ACTIVITYCOUNTER1)
    ,.handcode_rvalid_PERF_SMON_COMPARE0            (hqm_system_csr_hc_rvalid.PERF_SMON_COMPARE0)
    ,.handcode_rvalid_PERF_SMON_COMPARE1            (hqm_system_csr_hc_rvalid.PERF_SMON_COMPARE1)
    ,.handcode_rvalid_PERF_SMON_CONFIGURATION0      (hqm_system_csr_hc_rvalid.PERF_SMON_CONFIGURATION0)
    ,.handcode_rvalid_PERF_SMON_CONFIGURATION1      (hqm_system_csr_hc_rvalid.PERF_SMON_CONFIGURATION1)
    ,.handcode_rvalid_PERF_SMON_MAXIMUM_TIMER       (hqm_system_csr_hc_rvalid.PERF_SMON_MAXIMUM_TIMER)
    ,.handcode_rvalid_PERF_SMON_TIMER               (hqm_system_csr_hc_rvalid.PERF_SMON_TIMER)
    ,.handcode_rvalid_PERF_SMON_COMP_MASK0          (hqm_system_csr_hc_rvalid.PERF_SMON_COMP_MASK0)
    ,.handcode_rvalid_PERF_SMON_COMP_MASK1          (hqm_system_csr_hc_rvalid.PERF_SMON_COMP_MASK1)
    ,.handcode_rvalid_DIR_CQ_FMT                    (hqm_system_csr_hc_rvalid.DIR_CQ_FMT)
    ,.handcode_rvalid_DIR_QID_ITS                   (hqm_system_csr_hc_rvalid.DIR_QID_ITS)
    ,.handcode_rvalid_DIR_QID_V                     (hqm_system_csr_hc_rvalid.DIR_QID_V)
    ,.handcode_rvalid_DIR_PP2VAS                    (hqm_system_csr_hc_rvalid.DIR_PP2VAS)
    ,.handcode_rvalid_DIR_VASQID_V                  (hqm_system_csr_hc_rvalid.DIR_VASQID_V)
    ,.handcode_rvalid_LDB_CQ_PASID                  (hqm_system_csr_hc_rvalid.LDB_CQ_PASID)
    ,.handcode_rvalid_LDB_CQ_ADDR_L                 (hqm_system_csr_hc_rvalid.LDB_CQ_ADDR_L)
    ,.handcode_rvalid_LDB_CQ_ADDR_U                 (hqm_system_csr_hc_rvalid.LDB_CQ_ADDR_U)
    ,.handcode_rvalid_LDB_CQ2VF_PF_RO               (hqm_system_csr_hc_rvalid.LDB_CQ2VF_PF_RO)
    ,.handcode_rvalid_LDB_CQ_ISR                    (hqm_system_csr_hc_rvalid.LDB_CQ_ISR)
    ,.handcode_rvalid_LDB_QID_ITS                   (hqm_system_csr_hc_rvalid.LDB_QID_ITS)
    ,.handcode_rvalid_LDB_QID_V                     (hqm_system_csr_hc_rvalid.LDB_QID_V)
    ,.handcode_rvalid_LDB_PP2VAS                    (hqm_system_csr_hc_rvalid.LDB_PP2VAS)
    ,.handcode_rvalid_LDB_QID_CFG_V                 (hqm_system_csr_hc_rvalid.LDB_QID_CFG_V)
    ,.handcode_rvalid_LDB_VASQID_V                  (hqm_system_csr_hc_rvalid.LDB_VASQID_V)
    ,.handcode_rvalid_VF_DIR_VPP2PP                 (hqm_system_csr_hc_rvalid.VF_DIR_VPP2PP)
    ,.handcode_rvalid_VF_DIR_VPP_V                  (hqm_system_csr_hc_rvalid.VF_DIR_VPP_V)
    ,.handcode_rvalid_DIR_PP_V                      (hqm_system_csr_hc_rvalid.DIR_PP_V)
    ,.handcode_rvalid_LDB_PP_V                      (hqm_system_csr_hc_rvalid.LDB_PP_V)
    ,.handcode_rvalid_VF_DIR_VQID2QID               (hqm_system_csr_hc_rvalid.VF_DIR_VQID2QID)
    ,.handcode_rvalid_VF_DIR_VQID_V                 (hqm_system_csr_hc_rvalid.VF_DIR_VQID_V)
    ,.handcode_rvalid_LDB_QID2VQID                  (hqm_system_csr_hc_rvalid.LDB_QID2VQID)
    ,.handcode_rvalid_VF_LDB_VPP2PP                 (hqm_system_csr_hc_rvalid.VF_LDB_VPP2PP)
    ,.handcode_rvalid_VF_LDB_VPP_V                  (hqm_system_csr_hc_rvalid.VF_LDB_VPP_V)
    ,.handcode_rvalid_VF_LDB_VQID2QID               (hqm_system_csr_hc_rvalid.VF_LDB_VQID2QID)
    ,.handcode_rvalid_VF_LDB_VQID_V                 (hqm_system_csr_hc_rvalid.VF_LDB_VQID_V)
    ,.handcode_rvalid_WB_DIR_CQ_STATE               (hqm_system_csr_hc_rvalid.WB_DIR_CQ_STATE)
    ,.handcode_rvalid_WB_LDB_CQ_STATE               (hqm_system_csr_hc_rvalid.WB_LDB_CQ_STATE)

    ,.handcode_wvalid_SBE_CNT_0                     (hqm_system_csr_hc_wvalid.SBE_CNT_0)
    ,.handcode_wvalid_SBE_CNT_1                     (hqm_system_csr_hc_wvalid.SBE_CNT_1)
    ,.handcode_wvalid_ALARM_HW_SYND                 (hqm_system_csr_hc_wvalid.ALARM_HW_SYND)
    ,.handcode_wvalid_ALARM_PF_SYND0                (hqm_system_csr_hc_wvalid.ALARM_PF_SYND0)
    ,.handcode_wvalid_ALARM_PF_SYND1                (hqm_system_csr_hc_wvalid.ALARM_PF_SYND1)
    ,.handcode_wvalid_ALARM_PF_SYND2                (hqm_system_csr_hc_wvalid.ALARM_PF_SYND2)
    ,.handcode_wvalid_ALARM_VF_SYND0                (hqm_system_csr_hc_wvalid.ALARM_VF_SYND0)
    ,.handcode_wvalid_ALARM_VF_SYND1                (hqm_system_csr_hc_wvalid.ALARM_VF_SYND1)
    ,.handcode_wvalid_ALARM_VF_SYND2                (hqm_system_csr_hc_wvalid.ALARM_VF_SYND2)
    ,.handcode_wvalid_DIR_CQ_PASID                  (hqm_system_csr_hc_wvalid.DIR_CQ_PASID)
    ,.handcode_wvalid_DIR_CQ_ADDR_L                 (hqm_system_csr_hc_wvalid.DIR_CQ_ADDR_L)
    ,.handcode_wvalid_DIR_CQ_ADDR_U                 (hqm_system_csr_hc_wvalid.DIR_CQ_ADDR_U)
    ,.handcode_wvalid_DIR_CQ2VF_PF_RO               (hqm_system_csr_hc_wvalid.DIR_CQ2VF_PF_RO)
    ,.handcode_wvalid_DIR_CQ_ISR                    (hqm_system_csr_hc_wvalid.DIR_CQ_ISR)
    ,.handcode_wvalid_AI_ADDR_L                     (hqm_system_csr_hc_wvalid.AI_ADDR_L)
    ,.handcode_wvalid_AI_ADDR_U                     (hqm_system_csr_hc_wvalid.AI_ADDR_U)
    ,.handcode_wvalid_AI_DATA                       (hqm_system_csr_hc_wvalid.AI_DATA)
    ,.handcode_wvalid_AW_SMON_ACTIVITYCOUNTER0      (hqm_system_csr_hc_wvalid.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_wvalid_AW_SMON_ACTIVITYCOUNTER1      (hqm_system_csr_hc_wvalid.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_wvalid_AW_SMON_COMPARE0              (hqm_system_csr_hc_wvalid.AW_SMON_COMPARE0)
    ,.handcode_wvalid_AW_SMON_COMPARE1              (hqm_system_csr_hc_wvalid.AW_SMON_COMPARE1)
    ,.handcode_wvalid_AW_SMON_CONFIGURATION0        (hqm_system_csr_hc_wvalid.AW_SMON_CONFIGURATION0)
    ,.handcode_wvalid_AW_SMON_CONFIGURATION1        (hqm_system_csr_hc_wvalid.AW_SMON_CONFIGURATION1)
    ,.handcode_wvalid_AW_SMON_MAXIMUM_TIMER         (hqm_system_csr_hc_wvalid.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_wvalid_AW_SMON_TIMER                 (hqm_system_csr_hc_wvalid.AW_SMON_TIMER)
    ,.handcode_wvalid_AW_SMON_COMP_MASK0            (hqm_system_csr_hc_wvalid.AW_SMON_COMP_MASK0)
    ,.handcode_wvalid_AW_SMON_COMP_MASK1            (hqm_system_csr_hc_wvalid.AW_SMON_COMP_MASK1)
    ,.handcode_wvalid_PERF_SMON_ACTIVITYCOUNTER0    (hqm_system_csr_hc_wvalid.PERF_SMON_ACTIVITYCOUNTER0)
    ,.handcode_wvalid_PERF_SMON_ACTIVITYCOUNTER1    (hqm_system_csr_hc_wvalid.PERF_SMON_ACTIVITYCOUNTER1)
    ,.handcode_wvalid_PERF_SMON_COMPARE0            (hqm_system_csr_hc_wvalid.PERF_SMON_COMPARE0)
    ,.handcode_wvalid_PERF_SMON_COMPARE1            (hqm_system_csr_hc_wvalid.PERF_SMON_COMPARE1)
    ,.handcode_wvalid_PERF_SMON_CONFIGURATION0      (hqm_system_csr_hc_wvalid.PERF_SMON_CONFIGURATION0)
    ,.handcode_wvalid_PERF_SMON_CONFIGURATION1      (hqm_system_csr_hc_wvalid.PERF_SMON_CONFIGURATION1)
    ,.handcode_wvalid_PERF_SMON_MAXIMUM_TIMER       (hqm_system_csr_hc_wvalid.PERF_SMON_MAXIMUM_TIMER)
    ,.handcode_wvalid_PERF_SMON_TIMER               (hqm_system_csr_hc_wvalid.PERF_SMON_TIMER)
    ,.handcode_wvalid_PERF_SMON_COMP_MASK0          (hqm_system_csr_hc_wvalid.PERF_SMON_COMP_MASK0)
    ,.handcode_wvalid_PERF_SMON_COMP_MASK1          (hqm_system_csr_hc_wvalid.PERF_SMON_COMP_MASK1)
    ,.handcode_wvalid_DIR_CQ_FMT                    (hqm_system_csr_hc_wvalid.DIR_CQ_FMT)
    ,.handcode_wvalid_DIR_QID_ITS                   (hqm_system_csr_hc_wvalid.DIR_QID_ITS)
    ,.handcode_wvalid_DIR_QID_V                     (hqm_system_csr_hc_wvalid.DIR_QID_V)
    ,.handcode_wvalid_DIR_PP2VAS                    (hqm_system_csr_hc_wvalid.DIR_PP2VAS)
    ,.handcode_wvalid_DIR_VASQID_V                  (hqm_system_csr_hc_wvalid.DIR_VASQID_V)
    ,.handcode_wvalid_LDB_CQ_PASID                  (hqm_system_csr_hc_wvalid.LDB_CQ_PASID)
    ,.handcode_wvalid_LDB_CQ_ADDR_L                 (hqm_system_csr_hc_wvalid.LDB_CQ_ADDR_L)
    ,.handcode_wvalid_LDB_CQ_ADDR_U                 (hqm_system_csr_hc_wvalid.LDB_CQ_ADDR_U)
    ,.handcode_wvalid_LDB_CQ2VF_PF_RO               (hqm_system_csr_hc_wvalid.LDB_CQ2VF_PF_RO)
    ,.handcode_wvalid_LDB_CQ_ISR                    (hqm_system_csr_hc_wvalid.LDB_CQ_ISR)
    ,.handcode_wvalid_LDB_QID_ITS                   (hqm_system_csr_hc_wvalid.LDB_QID_ITS)
    ,.handcode_wvalid_LDB_QID_V                     (hqm_system_csr_hc_wvalid.LDB_QID_V)
    ,.handcode_wvalid_LDB_PP2VAS                    (hqm_system_csr_hc_wvalid.LDB_PP2VAS)
    ,.handcode_wvalid_LDB_QID_CFG_V                 (hqm_system_csr_hc_wvalid.LDB_QID_CFG_V)
    ,.handcode_wvalid_LDB_VASQID_V                  (hqm_system_csr_hc_wvalid.LDB_VASQID_V)
    ,.handcode_wvalid_VF_DIR_VPP2PP                 (hqm_system_csr_hc_wvalid.VF_DIR_VPP2PP)
    ,.handcode_wvalid_VF_DIR_VPP_V                  (hqm_system_csr_hc_wvalid.VF_DIR_VPP_V)
    ,.handcode_wvalid_DIR_PP_V                      (hqm_system_csr_hc_wvalid.DIR_PP_V)
    ,.handcode_wvalid_LDB_PP_V                      (hqm_system_csr_hc_wvalid.LDB_PP_V)
    ,.handcode_wvalid_VF_DIR_VQID2QID               (hqm_system_csr_hc_wvalid.VF_DIR_VQID2QID)
    ,.handcode_wvalid_VF_DIR_VQID_V                 (hqm_system_csr_hc_wvalid.VF_DIR_VQID_V)
    ,.handcode_wvalid_LDB_QID2VQID                  (hqm_system_csr_hc_wvalid.LDB_QID2VQID)
    ,.handcode_wvalid_VF_LDB_VPP2PP                 (hqm_system_csr_hc_wvalid.VF_LDB_VPP2PP)
    ,.handcode_wvalid_VF_LDB_VPP_V                  (hqm_system_csr_hc_wvalid.VF_LDB_VPP_V)
    ,.handcode_wvalid_VF_LDB_VQID2QID               (hqm_system_csr_hc_wvalid.VF_LDB_VQID2QID)
    ,.handcode_wvalid_VF_LDB_VQID_V                 (hqm_system_csr_hc_wvalid.VF_LDB_VQID_V)
    ,.handcode_wvalid_WB_DIR_CQ_STATE               (hqm_system_csr_hc_wvalid.WB_DIR_CQ_STATE)
    ,.handcode_wvalid_WB_LDB_CQ_STATE               (hqm_system_csr_hc_wvalid.WB_LDB_CQ_STATE)

    ,.handcode_error_SBE_CNT_0                      (hqm_system_csr_hc_error.SBE_CNT_0)
    ,.handcode_error_SBE_CNT_1                      (hqm_system_csr_hc_error.SBE_CNT_1)
    ,.handcode_error_ALARM_HW_SYND                  (hqm_system_csr_hc_error.ALARM_HW_SYND)
    ,.handcode_error_ALARM_PF_SYND0                 (hqm_system_csr_hc_error.ALARM_PF_SYND0)
    ,.handcode_error_ALARM_PF_SYND1                 (hqm_system_csr_hc_error.ALARM_PF_SYND1)
    ,.handcode_error_ALARM_PF_SYND2                 (hqm_system_csr_hc_error.ALARM_PF_SYND2)
    ,.handcode_error_ALARM_VF_SYND0                 (hqm_system_csr_hc_error.ALARM_VF_SYND0)
    ,.handcode_error_ALARM_VF_SYND1                 (hqm_system_csr_hc_error.ALARM_VF_SYND1)
    ,.handcode_error_ALARM_VF_SYND2                 (hqm_system_csr_hc_error.ALARM_VF_SYND2)
    ,.handcode_error_DIR_CQ_PASID                   (hqm_system_csr_hc_error.DIR_CQ_PASID)
    ,.handcode_error_DIR_CQ_ADDR_L                  (hqm_system_csr_hc_error.DIR_CQ_ADDR_L)
    ,.handcode_error_DIR_CQ_ADDR_U                  (hqm_system_csr_hc_error.DIR_CQ_ADDR_U)
    ,.handcode_error_DIR_CQ2VF_PF_RO                (hqm_system_csr_hc_error.DIR_CQ2VF_PF_RO)
    ,.handcode_error_DIR_CQ_ISR                     (hqm_system_csr_hc_error.DIR_CQ_ISR)
    ,.handcode_error_AI_ADDR_L                      (hqm_system_csr_hc_error.AI_ADDR_L)
    ,.handcode_error_AI_ADDR_U                      (hqm_system_csr_hc_error.AI_ADDR_U)
    ,.handcode_error_AI_DATA                        (hqm_system_csr_hc_error.AI_DATA)
    ,.handcode_error_AW_SMON_ACTIVITYCOUNTER0       (hqm_system_csr_hc_error.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_error_AW_SMON_ACTIVITYCOUNTER1       (hqm_system_csr_hc_error.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_error_AW_SMON_COMPARE0               (hqm_system_csr_hc_error.AW_SMON_COMPARE0)
    ,.handcode_error_AW_SMON_COMPARE1               (hqm_system_csr_hc_error.AW_SMON_COMPARE1)
    ,.handcode_error_AW_SMON_CONFIGURATION0         (hqm_system_csr_hc_error.AW_SMON_CONFIGURATION0)
    ,.handcode_error_AW_SMON_CONFIGURATION1         (hqm_system_csr_hc_error.AW_SMON_CONFIGURATION1)
    ,.handcode_error_AW_SMON_MAXIMUM_TIMER          (hqm_system_csr_hc_error.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_error_AW_SMON_TIMER                  (hqm_system_csr_hc_error.AW_SMON_TIMER)
    ,.handcode_error_AW_SMON_COMP_MASK0             (hqm_system_csr_hc_error.AW_SMON_COMP_MASK0)
    ,.handcode_error_AW_SMON_COMP_MASK1             (hqm_system_csr_hc_error.AW_SMON_COMP_MASK1)
    ,.handcode_error_PERF_SMON_ACTIVITYCOUNTER0     (hqm_system_csr_hc_error.PERF_SMON_ACTIVITYCOUNTER0)
    ,.handcode_error_PERF_SMON_ACTIVITYCOUNTER1     (hqm_system_csr_hc_error.PERF_SMON_ACTIVITYCOUNTER1)
    ,.handcode_error_PERF_SMON_COMPARE0             (hqm_system_csr_hc_error.PERF_SMON_COMPARE0)
    ,.handcode_error_PERF_SMON_COMPARE1             (hqm_system_csr_hc_error.PERF_SMON_COMPARE1)
    ,.handcode_error_PERF_SMON_CONFIGURATION0       (hqm_system_csr_hc_error.PERF_SMON_CONFIGURATION0)
    ,.handcode_error_PERF_SMON_CONFIGURATION1       (hqm_system_csr_hc_error.PERF_SMON_CONFIGURATION1)
    ,.handcode_error_PERF_SMON_MAXIMUM_TIMER        (hqm_system_csr_hc_error.PERF_SMON_MAXIMUM_TIMER)
    ,.handcode_error_PERF_SMON_TIMER                (hqm_system_csr_hc_error.PERF_SMON_TIMER)
    ,.handcode_error_PERF_SMON_COMP_MASK0           (hqm_system_csr_hc_error.PERF_SMON_COMP_MASK0)
    ,.handcode_error_PERF_SMON_COMP_MASK1           (hqm_system_csr_hc_error.PERF_SMON_COMP_MASK1)
    ,.handcode_error_DIR_CQ_FMT                     (hqm_system_csr_hc_error.DIR_CQ_FMT)
    ,.handcode_error_DIR_QID_ITS                    (hqm_system_csr_hc_error.DIR_QID_ITS)
    ,.handcode_error_DIR_QID_V                      (hqm_system_csr_hc_error.DIR_QID_V)
    ,.handcode_error_DIR_PP2VAS                     (hqm_system_csr_hc_error.DIR_PP2VAS)
    ,.handcode_error_DIR_VASQID_V                   (hqm_system_csr_hc_error.DIR_VASQID_V)
    ,.handcode_error_LDB_CQ_PASID                   (hqm_system_csr_hc_error.LDB_CQ_PASID)
    ,.handcode_error_LDB_CQ_ADDR_L                  (hqm_system_csr_hc_error.LDB_CQ_ADDR_L)
    ,.handcode_error_LDB_CQ_ADDR_U                  (hqm_system_csr_hc_error.LDB_CQ_ADDR_U)
    ,.handcode_error_LDB_CQ2VF_PF_RO                (hqm_system_csr_hc_error.LDB_CQ2VF_PF_RO)
    ,.handcode_error_LDB_CQ_ISR                     (hqm_system_csr_hc_error.LDB_CQ_ISR)
    ,.handcode_error_LDB_QID_ITS                    (hqm_system_csr_hc_error.LDB_QID_ITS)
    ,.handcode_error_LDB_QID_V                      (hqm_system_csr_hc_error.LDB_QID_V)
    ,.handcode_error_LDB_PP2VAS                     (hqm_system_csr_hc_error.LDB_PP2VAS)
    ,.handcode_error_LDB_QID_CFG_V                  (hqm_system_csr_hc_error.LDB_QID_CFG_V)
    ,.handcode_error_LDB_VASQID_V                   (hqm_system_csr_hc_error.LDB_VASQID_V)
    ,.handcode_error_VF_DIR_VPP2PP                  (hqm_system_csr_hc_error.VF_DIR_VPP2PP)
    ,.handcode_error_VF_DIR_VPP_V                   (hqm_system_csr_hc_error.VF_DIR_VPP_V)
    ,.handcode_error_DIR_PP_V                       (hqm_system_csr_hc_error.DIR_PP_V)
    ,.handcode_error_LDB_PP_V                       (hqm_system_csr_hc_error.LDB_PP_V)
    ,.handcode_error_VF_DIR_VQID2QID                (hqm_system_csr_hc_error.VF_DIR_VQID2QID)
    ,.handcode_error_VF_DIR_VQID_V                  (hqm_system_csr_hc_error.VF_DIR_VQID_V)
    ,.handcode_error_LDB_QID2VQID                   (hqm_system_csr_hc_error.LDB_QID2VQID)
    ,.handcode_error_VF_LDB_VPP2PP                  (hqm_system_csr_hc_error.VF_LDB_VPP2PP)
    ,.handcode_error_VF_LDB_VPP_V                   (hqm_system_csr_hc_error.VF_LDB_VPP_V)
    ,.handcode_error_VF_LDB_VQID2QID                (hqm_system_csr_hc_error.VF_LDB_VQID2QID)
    ,.handcode_error_VF_LDB_VQID_V                  (hqm_system_csr_hc_error.VF_LDB_VQID_V)
    ,.handcode_error_WB_DIR_CQ_STATE                (hqm_system_csr_hc_error.WB_DIR_CQ_STATE)
    ,.handcode_error_WB_LDB_CQ_STATE                (hqm_system_csr_hc_error.WB_LDB_CQ_STATE)

    ,.ack                                           (hqm_system_csr_ack)
    ,.sai_import                                    (hqm_system_csr_sai_import)

    ,.TOTAL_CREDITS                                 (total_credits_nc)
    ,.TOTAL_DIR_PORTS                               (total_dir_ports_nc)
    ,.TOTAL_DIR_QID                                 (total_dir_qid_nc)
    ,.TOTAL_LDB_PORTS                               (total_ldb_ports_nc)
    ,.TOTAL_LDB_QID                                 (total_ldb_qid_nc)
    ,.TOTAL_SN_REGIONS                              (total_sn_regions_nc)
    ,.TOTAL_VAS                                     (total_vas_nc)
    ,.TOTAL_VF                                      (total_vf_nc)

    // Register signals for HandCoded registers

    ,.handcode_reg_wdata_SBE_CNT_0                  (hqm_system_csr_hc_reg_write.SBE_CNT_0)
    ,.handcode_reg_wdata_SBE_CNT_1                  (hqm_system_csr_hc_reg_write.SBE_CNT_1)
    ,.handcode_reg_wdata_ALARM_HW_SYND              (hqm_system_csr_hc_reg_write.ALARM_HW_SYND)
    ,.handcode_reg_wdata_ALARM_PF_SYND0             (hqm_system_csr_hc_reg_write.ALARM_PF_SYND0)
    ,.handcode_reg_wdata_ALARM_PF_SYND1             (hqm_system_csr_hc_reg_write.ALARM_PF_SYND1)
    ,.handcode_reg_wdata_ALARM_PF_SYND2             (hqm_system_csr_hc_reg_write.ALARM_PF_SYND2)
    ,.handcode_reg_wdata_ALARM_VF_SYND0             (hqm_system_csr_hc_reg_write.ALARM_VF_SYND0)
    ,.handcode_reg_wdata_ALARM_VF_SYND1             (hqm_system_csr_hc_reg_write.ALARM_VF_SYND1)
    ,.handcode_reg_wdata_ALARM_VF_SYND2             (hqm_system_csr_hc_reg_write.ALARM_VF_SYND2)
    ,.handcode_reg_wdata_DIR_CQ_PASID               (hqm_system_csr_hc_reg_write.DIR_CQ_PASID)
    ,.handcode_reg_wdata_DIR_CQ_ADDR_L              (hqm_system_csr_hc_reg_write.DIR_CQ_ADDR_L)
    ,.handcode_reg_wdata_DIR_CQ_ADDR_U              (hqm_system_csr_hc_reg_write.DIR_CQ_ADDR_U)
    ,.handcode_reg_wdata_DIR_CQ2VF_PF_RO            (hqm_system_csr_hc_reg_write.DIR_CQ2VF_PF_RO)
    ,.handcode_reg_wdata_DIR_CQ_ISR                 (hqm_system_csr_hc_reg_write.DIR_CQ_ISR)
    ,.handcode_reg_wdata_AI_ADDR_L                  (hqm_system_csr_hc_reg_write.AI_ADDR_L)
    ,.handcode_reg_wdata_AI_ADDR_U                  (hqm_system_csr_hc_reg_write.AI_ADDR_U)
    ,.handcode_reg_wdata_AI_DATA                    (hqm_system_csr_hc_reg_write.AI_DATA)
    ,.handcode_reg_wdata_AW_SMON_ACTIVITYCOUNTER0   (hqm_system_csr_hc_reg_write.AW_SMON_ACTIVITYCOUNTER0)
    ,.handcode_reg_wdata_AW_SMON_ACTIVITYCOUNTER1   (hqm_system_csr_hc_reg_write.AW_SMON_ACTIVITYCOUNTER1)
    ,.handcode_reg_wdata_AW_SMON_COMPARE0           (hqm_system_csr_hc_reg_write.AW_SMON_COMPARE0)
    ,.handcode_reg_wdata_AW_SMON_COMPARE1           (hqm_system_csr_hc_reg_write.AW_SMON_COMPARE1)
    ,.handcode_reg_wdata_AW_SMON_CONFIGURATION0     (hqm_system_csr_hc_reg_write.AW_SMON_CONFIGURATION0)
    ,.handcode_reg_wdata_AW_SMON_CONFIGURATION1     (hqm_system_csr_hc_reg_write.AW_SMON_CONFIGURATION1)
    ,.handcode_reg_wdata_AW_SMON_MAXIMUM_TIMER      (hqm_system_csr_hc_reg_write.AW_SMON_MAXIMUM_TIMER)
    ,.handcode_reg_wdata_AW_SMON_TIMER              (hqm_system_csr_hc_reg_write.AW_SMON_TIMER)
    ,.handcode_reg_wdata_AW_SMON_COMP_MASK0         (hqm_system_csr_hc_reg_write.AW_SMON_COMP_MASK0)
    ,.handcode_reg_wdata_AW_SMON_COMP_MASK1         (hqm_system_csr_hc_reg_write.AW_SMON_COMP_MASK1)
    ,.handcode_reg_wdata_PERF_SMON_ACTIVITYCOUNTER0 (hqm_system_csr_hc_reg_write.PERF_SMON_ACTIVITYCOUNTER0)
    ,.handcode_reg_wdata_PERF_SMON_ACTIVITYCOUNTER1 (hqm_system_csr_hc_reg_write.PERF_SMON_ACTIVITYCOUNTER1)
    ,.handcode_reg_wdata_PERF_SMON_COMPARE0         (hqm_system_csr_hc_reg_write.PERF_SMON_COMPARE0)
    ,.handcode_reg_wdata_PERF_SMON_COMPARE1         (hqm_system_csr_hc_reg_write.PERF_SMON_COMPARE1)
    ,.handcode_reg_wdata_PERF_SMON_CONFIGURATION0   (hqm_system_csr_hc_reg_write.PERF_SMON_CONFIGURATION0)
    ,.handcode_reg_wdata_PERF_SMON_CONFIGURATION1   (hqm_system_csr_hc_reg_write.PERF_SMON_CONFIGURATION1)
    ,.handcode_reg_wdata_PERF_SMON_MAXIMUM_TIMER    (hqm_system_csr_hc_reg_write.PERF_SMON_MAXIMUM_TIMER)
    ,.handcode_reg_wdata_PERF_SMON_TIMER            (hqm_system_csr_hc_reg_write.PERF_SMON_TIMER)
    ,.handcode_reg_wdata_PERF_SMON_COMP_MASK0       (hqm_system_csr_hc_reg_write.PERF_SMON_COMP_MASK0)
    ,.handcode_reg_wdata_PERF_SMON_COMP_MASK1       (hqm_system_csr_hc_reg_write.PERF_SMON_COMP_MASK1)
    ,.handcode_reg_wdata_DIR_CQ_FMT                 (hqm_system_csr_hc_reg_write.DIR_CQ_FMT)
    ,.handcode_reg_wdata_DIR_QID_ITS                (hqm_system_csr_hc_reg_write.DIR_QID_ITS)
    ,.handcode_reg_wdata_DIR_QID_V                  (hqm_system_csr_hc_reg_write.DIR_QID_V)
    ,.handcode_reg_wdata_DIR_PP2VAS                 (hqm_system_csr_hc_reg_write.DIR_PP2VAS)
    ,.handcode_reg_wdata_DIR_VASQID_V               (hqm_system_csr_hc_reg_write.DIR_VASQID_V)
    ,.handcode_reg_wdata_LDB_CQ_PASID               (hqm_system_csr_hc_reg_write.LDB_CQ_PASID)
    ,.handcode_reg_wdata_LDB_CQ_ADDR_L              (hqm_system_csr_hc_reg_write.LDB_CQ_ADDR_L)
    ,.handcode_reg_wdata_LDB_CQ_ADDR_U              (hqm_system_csr_hc_reg_write.LDB_CQ_ADDR_U)
    ,.handcode_reg_wdata_LDB_CQ2VF_PF_RO            (hqm_system_csr_hc_reg_write.LDB_CQ2VF_PF_RO)
    ,.handcode_reg_wdata_LDB_CQ_ISR                 (hqm_system_csr_hc_reg_write.LDB_CQ_ISR)
    ,.handcode_reg_wdata_LDB_QID_ITS                (hqm_system_csr_hc_reg_write.LDB_QID_ITS)
    ,.handcode_reg_wdata_LDB_QID_V                  (hqm_system_csr_hc_reg_write.LDB_QID_V)
    ,.handcode_reg_wdata_LDB_PP2VAS                 (hqm_system_csr_hc_reg_write.LDB_PP2VAS)
    ,.handcode_reg_wdata_LDB_QID_CFG_V              (hqm_system_csr_hc_reg_write.LDB_QID_CFG_V)
    ,.handcode_reg_wdata_LDB_VASQID_V               (hqm_system_csr_hc_reg_write.LDB_VASQID_V)
    ,.handcode_reg_wdata_VF_DIR_VPP2PP              (hqm_system_csr_hc_reg_write.VF_DIR_VPP2PP)
    ,.handcode_reg_wdata_VF_DIR_VPP_V               (hqm_system_csr_hc_reg_write.VF_DIR_VPP_V)
    ,.handcode_reg_wdata_DIR_PP_V                   (hqm_system_csr_hc_reg_write.DIR_PP_V)
    ,.handcode_reg_wdata_LDB_PP_V                   (hqm_system_csr_hc_reg_write.LDB_PP_V)
    ,.handcode_reg_wdata_VF_DIR_VQID2QID            (hqm_system_csr_hc_reg_write.VF_DIR_VQID2QID)
    ,.handcode_reg_wdata_VF_DIR_VQID_V              (hqm_system_csr_hc_reg_write.VF_DIR_VQID_V)
    ,.handcode_reg_wdata_LDB_QID2VQID               (hqm_system_csr_hc_reg_write.LDB_QID2VQID)
    ,.handcode_reg_wdata_VF_LDB_VPP2PP              (hqm_system_csr_hc_reg_write.VF_LDB_VPP2PP)
    ,.handcode_reg_wdata_VF_LDB_VPP_V               (hqm_system_csr_hc_reg_write.VF_LDB_VPP_V)
    ,.handcode_reg_wdata_VF_LDB_VQID2QID            (hqm_system_csr_hc_reg_write.VF_LDB_VQID2QID)
    ,.handcode_reg_wdata_VF_LDB_VQID_V              (hqm_system_csr_hc_reg_write.VF_LDB_VQID_V)
    ,.handcode_reg_wdata_WB_DIR_CQ_STATE            (hqm_system_csr_hc_reg_write.WB_DIR_CQ_STATE)
    ,.handcode_reg_wdata_WB_LDB_CQ_STATE            (hqm_system_csr_hc_reg_write.WB_LDB_CQ_STATE)

    ,.we_SBE_CNT_0                                  (hqm_system_csr_hc_we.SBE_CNT_0)
    ,.we_SBE_CNT_1                                  (hqm_system_csr_hc_we.SBE_CNT_1)
    ,.we_ALARM_HW_SYND                              (hqm_system_csr_hc_we.ALARM_HW_SYND)
    ,.we_ALARM_PF_SYND0                             (hqm_system_csr_hc_we.ALARM_PF_SYND0)
    ,.we_ALARM_PF_SYND1                             (hqm_system_csr_hc_we.ALARM_PF_SYND1)
    ,.we_ALARM_PF_SYND2                             (hqm_system_csr_hc_we.ALARM_PF_SYND2)
    ,.we_ALARM_VF_SYND0                             (hqm_system_csr_hc_we.ALARM_VF_SYND0)
    ,.we_ALARM_VF_SYND1                             (hqm_system_csr_hc_we.ALARM_VF_SYND1)
    ,.we_ALARM_VF_SYND2                             (hqm_system_csr_hc_we.ALARM_VF_SYND2)
    ,.we_DIR_CQ_PASID                               (hqm_system_csr_hc_we.DIR_CQ_PASID)
    ,.we_DIR_CQ_ADDR_L                              (hqm_system_csr_hc_we.DIR_CQ_ADDR_L)
    ,.we_DIR_CQ_ADDR_U                              (hqm_system_csr_hc_we.DIR_CQ_ADDR_U)
    ,.we_DIR_CQ2VF_PF_RO                            (hqm_system_csr_hc_we.DIR_CQ2VF_PF_RO)
    ,.we_DIR_CQ_ISR                                 (hqm_system_csr_hc_we.DIR_CQ_ISR)
    ,.we_AI_ADDR_L                                  (hqm_system_csr_hc_we.AI_ADDR_L)
    ,.we_AI_ADDR_U                                  (hqm_system_csr_hc_we.AI_ADDR_U)
    ,.we_AI_DATA                                    (hqm_system_csr_hc_we.AI_DATA)
    ,.we_AW_SMON_ACTIVITYCOUNTER0                   (hqm_system_csr_hc_we.AW_SMON_ACTIVITYCOUNTER0)
    ,.we_AW_SMON_ACTIVITYCOUNTER1                   (hqm_system_csr_hc_we.AW_SMON_ACTIVITYCOUNTER1)
    ,.we_AW_SMON_COMPARE0                           (hqm_system_csr_hc_we.AW_SMON_COMPARE0)
    ,.we_AW_SMON_COMPARE1                           (hqm_system_csr_hc_we.AW_SMON_COMPARE1)
    ,.we_AW_SMON_CONFIGURATION0                     (hqm_system_csr_hc_we.AW_SMON_CONFIGURATION0)
    ,.we_AW_SMON_CONFIGURATION1                     (hqm_system_csr_hc_we.AW_SMON_CONFIGURATION1)
    ,.we_AW_SMON_MAXIMUM_TIMER                      (hqm_system_csr_hc_we.AW_SMON_MAXIMUM_TIMER)
    ,.we_AW_SMON_TIMER                              (hqm_system_csr_hc_we.AW_SMON_TIMER)
    ,.we_AW_SMON_COMP_MASK0                         (hqm_system_csr_hc_we.AW_SMON_COMP_MASK0)
    ,.we_AW_SMON_COMP_MASK1                         (hqm_system_csr_hc_we.AW_SMON_COMP_MASK1)
    ,.we_PERF_SMON_ACTIVITYCOUNTER0                 (hqm_system_csr_hc_we.PERF_SMON_ACTIVITYCOUNTER0)
    ,.we_PERF_SMON_ACTIVITYCOUNTER1                 (hqm_system_csr_hc_we.PERF_SMON_ACTIVITYCOUNTER1)
    ,.we_PERF_SMON_COMPARE0                         (hqm_system_csr_hc_we.PERF_SMON_COMPARE0)
    ,.we_PERF_SMON_COMPARE1                         (hqm_system_csr_hc_we.PERF_SMON_COMPARE1)
    ,.we_PERF_SMON_CONFIGURATION0                   (hqm_system_csr_hc_we.PERF_SMON_CONFIGURATION0)
    ,.we_PERF_SMON_CONFIGURATION1                   (hqm_system_csr_hc_we.PERF_SMON_CONFIGURATION1)
    ,.we_PERF_SMON_MAXIMUM_TIMER                    (hqm_system_csr_hc_we.PERF_SMON_MAXIMUM_TIMER)
    ,.we_PERF_SMON_TIMER                            (hqm_system_csr_hc_we.PERF_SMON_TIMER)
    ,.we_PERF_SMON_COMP_MASK0                       (hqm_system_csr_hc_we.PERF_SMON_COMP_MASK0)
    ,.we_PERF_SMON_COMP_MASK1                       (hqm_system_csr_hc_we.PERF_SMON_COMP_MASK1)
    ,.we_DIR_CQ_FMT                                 (hqm_system_csr_hc_we.DIR_CQ_FMT)
    ,.we_DIR_QID_ITS                                (hqm_system_csr_hc_we.DIR_QID_ITS)
    ,.we_DIR_QID_V                                  (hqm_system_csr_hc_we.DIR_QID_V)
    ,.we_DIR_PP2VAS                                 (hqm_system_csr_hc_we.DIR_PP2VAS)
    ,.we_DIR_VASQID_V                               (hqm_system_csr_hc_we.DIR_VASQID_V)
    ,.we_LDB_CQ_PASID                               (hqm_system_csr_hc_we.LDB_CQ_PASID)
    ,.we_LDB_CQ_ADDR_L                              (hqm_system_csr_hc_we.LDB_CQ_ADDR_L)
    ,.we_LDB_CQ_ADDR_U                              (hqm_system_csr_hc_we.LDB_CQ_ADDR_U)
    ,.we_LDB_CQ2VF_PF_RO                            (hqm_system_csr_hc_we.LDB_CQ2VF_PF_RO)
    ,.we_LDB_CQ_ISR                                 (hqm_system_csr_hc_we.LDB_CQ_ISR)
    ,.we_LDB_QID_ITS                                (hqm_system_csr_hc_we.LDB_QID_ITS)
    ,.we_LDB_QID_V                                  (hqm_system_csr_hc_we.LDB_QID_V)
    ,.we_LDB_PP2VAS                                 (hqm_system_csr_hc_we.LDB_PP2VAS)
    ,.we_LDB_QID_CFG_V                              (hqm_system_csr_hc_we.LDB_QID_CFG_V)
    ,.we_LDB_VASQID_V                               (hqm_system_csr_hc_we.LDB_VASQID_V)
    ,.we_VF_DIR_VPP2PP                              (hqm_system_csr_hc_we.VF_DIR_VPP2PP)
    ,.we_VF_DIR_VPP_V                               (hqm_system_csr_hc_we.VF_DIR_VPP_V)
    ,.we_DIR_PP_V                                   (hqm_system_csr_hc_we.DIR_PP_V)
    ,.we_LDB_PP_V                                   (hqm_system_csr_hc_we.LDB_PP_V)
    ,.we_VF_DIR_VQID2QID                            (hqm_system_csr_hc_we.VF_DIR_VQID2QID)
    ,.we_VF_DIR_VQID_V                              (hqm_system_csr_hc_we.VF_DIR_VQID_V)
    ,.we_LDB_QID2VQID                               (hqm_system_csr_hc_we.LDB_QID2VQID)
    ,.we_VF_LDB_VPP2PP                              (hqm_system_csr_hc_we.VF_LDB_VPP2PP)
    ,.we_VF_LDB_VPP_V                               (hqm_system_csr_hc_we.VF_LDB_VPP_V)
    ,.we_VF_LDB_VQID2QID                            (hqm_system_csr_hc_we.VF_LDB_VQID2QID)
    ,.we_VF_LDB_VQID_V                              (hqm_system_csr_hc_we.VF_LDB_VQID_V)
    ,.we_WB_DIR_CQ_STATE                            (hqm_system_csr_hc_we.WB_DIR_CQ_STATE)
    ,.we_WB_LDB_CQ_STATE                            (hqm_system_csr_hc_we.WB_LDB_CQ_STATE)

    ,.re_SBE_CNT_0                                  (hqm_system_csr_hc_re.SBE_CNT_0)
    ,.re_SBE_CNT_1                                  (hqm_system_csr_hc_re.SBE_CNT_1)
    ,.re_ALARM_HW_SYND                              (hqm_system_csr_hc_re.ALARM_HW_SYND)
    ,.re_ALARM_PF_SYND0                             (hqm_system_csr_hc_re.ALARM_PF_SYND0)
    ,.re_ALARM_PF_SYND1                             (hqm_system_csr_hc_re.ALARM_PF_SYND1)
    ,.re_ALARM_PF_SYND2                             (hqm_system_csr_hc_re.ALARM_PF_SYND2)
    ,.re_ALARM_VF_SYND0                             (hqm_system_csr_hc_re.ALARM_VF_SYND0)
    ,.re_ALARM_VF_SYND1                             (hqm_system_csr_hc_re.ALARM_VF_SYND1)
    ,.re_ALARM_VF_SYND2                             (hqm_system_csr_hc_re.ALARM_VF_SYND2)
    ,.re_DIR_CQ_PASID                               (hqm_system_csr_hc_re.DIR_CQ_PASID)
    ,.re_DIR_CQ_ADDR_L                              (hqm_system_csr_hc_re.DIR_CQ_ADDR_L)
    ,.re_DIR_CQ_ADDR_U                              (hqm_system_csr_hc_re.DIR_CQ_ADDR_U)
    ,.re_DIR_CQ2VF_PF_RO                            (hqm_system_csr_hc_re.DIR_CQ2VF_PF_RO)
    ,.re_DIR_CQ_ISR                                 (hqm_system_csr_hc_re.DIR_CQ_ISR)
    ,.re_AI_ADDR_L                                  (hqm_system_csr_hc_re.AI_ADDR_L)
    ,.re_AI_ADDR_U                                  (hqm_system_csr_hc_re.AI_ADDR_U)
    ,.re_AI_DATA                                    (hqm_system_csr_hc_re.AI_DATA)
    ,.re_AW_SMON_ACTIVITYCOUNTER0                   (hqm_system_csr_hc_re.AW_SMON_ACTIVITYCOUNTER0)
    ,.re_AW_SMON_ACTIVITYCOUNTER1                   (hqm_system_csr_hc_re.AW_SMON_ACTIVITYCOUNTER1)
    ,.re_AW_SMON_COMPARE0                           (hqm_system_csr_hc_re.AW_SMON_COMPARE0)
    ,.re_AW_SMON_COMPARE1                           (hqm_system_csr_hc_re.AW_SMON_COMPARE1)
    ,.re_AW_SMON_CONFIGURATION0                     (hqm_system_csr_hc_re.AW_SMON_CONFIGURATION0)
    ,.re_AW_SMON_CONFIGURATION1                     (hqm_system_csr_hc_re.AW_SMON_CONFIGURATION1)
    ,.re_AW_SMON_MAXIMUM_TIMER                      (hqm_system_csr_hc_re.AW_SMON_MAXIMUM_TIMER)
    ,.re_AW_SMON_TIMER                              (hqm_system_csr_hc_re.AW_SMON_TIMER)
    ,.re_AW_SMON_COMP_MASK0                         (hqm_system_csr_hc_re.AW_SMON_COMP_MASK0)
    ,.re_AW_SMON_COMP_MASK1                         (hqm_system_csr_hc_re.AW_SMON_COMP_MASK1)
    ,.re_PERF_SMON_ACTIVITYCOUNTER0                 (hqm_system_csr_hc_re.PERF_SMON_ACTIVITYCOUNTER0)
    ,.re_PERF_SMON_ACTIVITYCOUNTER1                 (hqm_system_csr_hc_re.PERF_SMON_ACTIVITYCOUNTER1)
    ,.re_PERF_SMON_COMPARE0                         (hqm_system_csr_hc_re.PERF_SMON_COMPARE0)
    ,.re_PERF_SMON_COMPARE1                         (hqm_system_csr_hc_re.PERF_SMON_COMPARE1)
    ,.re_PERF_SMON_CONFIGURATION0                   (hqm_system_csr_hc_re.PERF_SMON_CONFIGURATION0)
    ,.re_PERF_SMON_CONFIGURATION1                   (hqm_system_csr_hc_re.PERF_SMON_CONFIGURATION1)
    ,.re_PERF_SMON_MAXIMUM_TIMER                    (hqm_system_csr_hc_re.PERF_SMON_MAXIMUM_TIMER)
    ,.re_PERF_SMON_TIMER                            (hqm_system_csr_hc_re.PERF_SMON_TIMER)
    ,.re_PERF_SMON_COMP_MASK0                       (hqm_system_csr_hc_re.PERF_SMON_COMP_MASK0)
    ,.re_PERF_SMON_COMP_MASK1                       (hqm_system_csr_hc_re.PERF_SMON_COMP_MASK1)
    ,.re_DIR_CQ_FMT                                 (hqm_system_csr_hc_re.DIR_CQ_FMT)
    ,.re_DIR_QID_ITS                                (hqm_system_csr_hc_re.DIR_QID_ITS)
    ,.re_DIR_QID_V                                  (hqm_system_csr_hc_re.DIR_QID_V)
    ,.re_DIR_PP2VAS                                 (hqm_system_csr_hc_re.DIR_PP2VAS)
    ,.re_DIR_VASQID_V                               (hqm_system_csr_hc_re.DIR_VASQID_V)
    ,.re_LDB_CQ_PASID                               (hqm_system_csr_hc_re.LDB_CQ_PASID)
    ,.re_LDB_CQ_ADDR_L                              (hqm_system_csr_hc_re.LDB_CQ_ADDR_L)
    ,.re_LDB_CQ_ADDR_U                              (hqm_system_csr_hc_re.LDB_CQ_ADDR_U)
    ,.re_LDB_CQ2VF_PF_RO                            (hqm_system_csr_hc_re.LDB_CQ2VF_PF_RO)
    ,.re_LDB_CQ_ISR                                 (hqm_system_csr_hc_re.LDB_CQ_ISR)
    ,.re_LDB_QID_ITS                                (hqm_system_csr_hc_re.LDB_QID_ITS)
    ,.re_LDB_QID_V                                  (hqm_system_csr_hc_re.LDB_QID_V)
    ,.re_LDB_PP2VAS                                 (hqm_system_csr_hc_re.LDB_PP2VAS)
    ,.re_LDB_QID_CFG_V                              (hqm_system_csr_hc_re.LDB_QID_CFG_V)
    ,.re_LDB_VASQID_V                               (hqm_system_csr_hc_re.LDB_VASQID_V)
    ,.re_VF_DIR_VPP2PP                              (hqm_system_csr_hc_re.VF_DIR_VPP2PP)
    ,.re_VF_DIR_VPP_V                               (hqm_system_csr_hc_re.VF_DIR_VPP_V)
    ,.re_DIR_PP_V                                   (hqm_system_csr_hc_re.DIR_PP_V)
    ,.re_LDB_PP_V                                   (hqm_system_csr_hc_re.LDB_PP_V)
    ,.re_VF_DIR_VQID2QID                            (hqm_system_csr_hc_re.VF_DIR_VQID2QID)
    ,.re_VF_DIR_VQID_V                              (hqm_system_csr_hc_re.VF_DIR_VQID_V)
    ,.re_LDB_QID2VQID                               (hqm_system_csr_hc_re.LDB_QID2VQID)
    ,.re_VF_LDB_VPP2PP                              (hqm_system_csr_hc_re.VF_LDB_VPP2PP)
    ,.re_VF_LDB_VPP_V                               (hqm_system_csr_hc_re.VF_LDB_VPP_V)
    ,.re_VF_LDB_VQID2QID                            (hqm_system_csr_hc_re.VF_LDB_VQID2QID)
    ,.re_VF_LDB_VQID_V                              (hqm_system_csr_hc_re.VF_LDB_VQID_V)
    ,.re_WB_DIR_CQ_STATE                            (hqm_system_csr_hc_re.WB_DIR_CQ_STATE)
    ,.re_WB_LDB_CQ_STATE                            (hqm_system_csr_hc_re.WB_LDB_CQ_STATE)

    ,.HQM_DIR_PP2VDEV                               (dir_pp2vdev)
    ,.HQM_LDB_PP2VDEV                               (ldb_pp2vdev)

    ,.DIR_PP_ROB_V                                  (dir_pp_rob_v)
    ,.LDB_PP_ROB_V                                  (ldb_pp_rob_v)

    ,.load_ROB_SYNDROME                             (set_rob_syndrome)
    ,.new_ROB_SYNDROME                              (rob_syndrome)
    ,.ROB_SYNDROME                                  (rob_syndrome_nc)
);  // i_hqm_system_csr

always_comb begin

  ims_rsvd_nc = '0;

  for (int i=0; i<(NUM_DIR_CQ+NUM_LDB_CQ); i=i+1) begin
    ims_mask[i] = ai_ctrl[i].IMS_MASK;
    ims_rsvd_nc |= (|{ai_ctrl[i].IMS_PEND, ai_ctrl[i].reserved0});
  end

end

hqm_AW_unused_bits i_unused (   

    .a  (|{hcw_enq_fifo_status_nc
          ,cfg_unit_version_nc
          ,hcw_sch_fifo_status_nc
          ,sch_out_fifo_status_nc
          ,cfg_rx_fifo_status_nc
          ,cwdi_rx_fifo_status_nc
          ,hqm_alarm_rx_fifo_status_nc
          ,sif_alarm_fifo_status_nc
          ,alarm_db_status_nc
          ,egress_db_status_nc
          ,ingress_db_status_nc
          ,alarm_status_nc
          ,egress_status_nc
          ,ingress_status_nc
          ,wbuf_status_nc
          ,wbuf_status2_nc
          ,wbuf_debug_nc
          ,phdr_debug_0_nc
          ,phdr_debug_1_nc
          ,phdr_debug_2_nc
          ,pdata_debug_nc
          ,hcw_req_debug_nc
          ,hcw_data_debug_nc
          ,alarm_lut_perr_nc
          ,egress_lut_err_nc
          ,ingress_lut_err_nc
          ,msix_31_0_synd_nc
          ,msix_63_32_synd_nc
          ,msix_64_synd_nc
          ,hqm_system_cnt_0_nc
          ,hqm_system_cnt_1_nc
          ,hqm_system_cnt_2_nc
          ,hqm_system_cnt_3_nc
          ,hqm_system_cnt_4_nc
          ,hqm_system_cnt_5_nc
          ,hqm_system_cnt_6_nc
          ,hqm_system_cnt_7_nc
          ,hqm_system_cnt_8_nc
          ,hqm_system_cnt_9_nc
          ,hqm_system_cnt_10_nc
          ,hqm_system_cnt_11_nc
          ,hqm_system_cnt_12_nc
          ,hqm_system_cnt_13_nc
          ,hqm_system_cnt_14_nc
          ,hqm_system_cnt_15_nc
          ,hqm_system_cnt_16_nc
          ,hqm_system_cnt_17_nc
          ,hqm_system_cnt_18_nc
          ,hqm_system_cnt_19_nc
          ,hqm_system_cnt_20_nc
          ,hqm_system_cnt_21_nc
          ,alarm_sb_ecc_err_nc
          ,alarm_mb_ecc_err_nc
          ,total_credits_nc
          ,total_dir_ports_nc
          ,total_dir_qid_nc
          ,total_ldb_ports_nc
          ,total_ldb_qid_nc
          ,total_sn_regions_nc
          ,total_vas_nc
          ,total_vf_nc
          ,ims_rsvd_nc
          ,rob_syndrome_nc
        })
);

endmodule   // hqm_system_csr_wrap

